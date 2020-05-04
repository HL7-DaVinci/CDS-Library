library UrologicalSuppliesPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10": 'http://hl7.org/fhir/sid/icd-10'
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'

valueset "Urinary Incontinence or Chronic Urinary Retention Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.70'
// TODO: Update HCPCS codes after VSAC value set is done
valueset "Urinary Collection and Irrigation System Device or Supply": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.49'

parameter service_request ServiceRequest

context Patient

define Today: Today()

// coverage requirement info
define RelevantDiagnoses: 
  CodesFromConditions(Confirmed(ActiveOrRecurring([Condition: "Urinary Incontinence or Chronic Urinary Retention Disorder"]))) 

define CurrentDiagnoses:
  CodesFromConditions(Confirmed(ActiveOrRecurring([Condition]))) except RelevantDiagnoses

define Allergies:
  CodesFromAllergies(ConfirmedAllergies([AllergyIntolerance]))

define ServiceRequestHcpcsCoding: singleton from (
  ((cast service_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define ServiceRequested:
  if "DeviceRequestHcpcsCoding".code in "Urinary Collection and Irrigation System Device or Supply" then "DeviceRequestHcpcsCoding".code.value
  else 'null'

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

define function CodesFromAllergies(AllergyList List<AllergyIntolerance>):
  distinct(flatten(
    AllergyList C
      let AllergyCodings:
          (C.code.coding) CODING where CODING.system.value in {
            'http://www.nlm.nih.gov/research/umls/rxnorm'
          }
          return FHIRHelpers.ToCode(CODING)
      return AllergyCodings
  ))

define AnswerYes:
  System.Code {
    code: 'Y',
    display: 'Yes'
  }
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

define function ConfirmedAllergies(AllergyList List<AllergyIntolerance>):
  AllergyList C where C.verificationStatus.coding.code = 'confirmed'

define function NullSafeToQuantity(Qty FHIR.Quantity):
  if Qty is not null then
    System.Quantity {
      value: Qty.value.value,
      unit: Coalesce(Qty.unit.value, Qty.code.value)
    }
  else null

define function LowestObservation(ObsList List<Observation>):
  Min(ObsList O return NullSafeToQuantity(cast O.value as Quantity))
