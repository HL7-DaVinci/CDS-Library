library ImmunosuppressiveDrugsPrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "OrganTransplantHistoryValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.81'
valueset "OrganTransplantProcedureValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.90'

parameter medication_request MedicationRequest

context Patient

define "QualifyingTransplant": [Condition: "OrganTransplantHistoryValueSet"] 

define "QualifyingTransplantProcedures": [Procedure: "OrganTransplantProcedureValueSet"]

define "QualifyingTransplantCodings": CodesFromConditions("QualifyingTransplant") union ProcedureCoding("QualifyingTransplantProcedures")

// get the first transplant date
define "TransplantDate": 
  if exists("QualifyingTransplant") then First("QualifyingTransplant").recordedDate.value
  else First("QualifyingTransplantProcedures").performed.value union First("QualifyingTransplantProcedures").performed.start.value


define function ProcedureCoding(ProcedureList List<FHIR.Procedure>):
  distinct(
    flatten(
      ProcedureList P
        let DiagnosesCodings:
          (P.code.coding) CODING 
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value
          }
        return DiagnosesCodings
    )
  )

// Get all medication related information
define "Medication": medication_request.medication

define "MedicationName": Medication.coding[0].display.value

define "MedicationHCPCS" : Medication.coding[0].code.value

define "MedicationDosage": medication_request.dosageInstruction[0]

define "MedicationDoseAndRate": MedicationDosage.doseAndRate[0]

define "MedicationDoseWithUnit": ToString(MedicationDoseAndRate.dose.value.value) + '' + MedicationDoseAndRate.dose.unit.value

define "MedicationRoute": MedicationDosage.route.coding[0].display.value

define "MedicationFrequency" : ToString(MedicationDosage.timing.repeat.frequency.value) + ' per ' + ToString(MedicationDosage.timing.repeat.period.value) + '' + MedicationDosage.timing.repeat.periodUnit.value

define CurrentDiagnoses:
  CodesFromConditions(Confirmed(ActiveOrRecurring([Condition]))) except QualifyingTransplant

define function CodesFromConditions(CondList List<Condition>):
  distinct(flatten(
    CondList C
      let DiagnosesCodings:
          (C.code.coding) CODING where CODING.system.value in {
            'http://hl7.org/fhir/sid/icd-10',
            'http://hl7.org/fhir/sid/icd-10-cm',
            'http://snomed.info/sct'
          }
          return FHIRHelpers.ToCode(CODING)
      return DiagnosesCodings
  ))
////////////////////////////// Taken from CDS Connect Commons for FHIR, could replace with r4 version of helper library
define function ActiveOrRecurring(CondList List<Condition>):
  CondList C where C.clinicalStatus.coding.code in {'active', 'relapse'}

define function ObservationLookBack(ObsList List<Observation>, LookBack System.Quantity):
  ObsList O
    let LookBackInterval: Interval[Now() - LookBack, Now()]
    where (cast O.effective as dateTime).value in LookBackInterval
      or NullSafeToInterval(cast O.effective as Period) overlaps LookBackInterval
      or FHIRHelpers."ToDateTime"(O.issued) in LookBackInterval

define function NullSafeToInterval(Pd FHIR.Period):
  if Pd is not null then Interval[Pd."start".value, Pd."end".value] else null

define function Verified(ObsList List<Observation>):
  ObsList O where O.status.value in {'final', 'amended'}

define function WithUnit(ObsList List<Observation>, Unit String):
  ObsList O where (cast O.value as Quantity).unit.value = Unit or (cast O.value as Quantity).code.value = Unit

define function HighestObservation(ObsList List<Observation>):
  Max(ObsList O return NullSafeToQuantity(cast O.value as Quantity))

define function Confirmed(CondList List<Condition>):
  CondList C where C.verificationStatus.coding.code = 'confirmed'

define function NullSafeToQuantity(Qty FHIR.Quantity):
  if Qty is not null then
    System.Quantity {
      value: Qty.value.value,
      unit: Coalesce(Qty.unit.value, Qty.code.value)
    }
  else null

define function LowestObservation(ObsList List<Observation>):
  Min(ObsList O return NullSafeToQuantity(cast O.value as Quantity))


