library DTRFunctions version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS

context Patient

// -------------------------------------------------- CONDITIONS -----------------------------------------------------

// Codes From Condition Helper Function - Used to display relevant diagnoses
// Use Case: DeviceRequest relevant diagnoses
// Used by: HOT, Immunosuppressive Drugs, NEAT, PAP, RAD, Uroligcal Supplies
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

// The first chronologically recorded condition of a ConditionList
// Note: CDS_Connect_Commons_for_FHIR supports last condition but not first.

define function FirstDateConditionRecorded(ConditionList List<FHIR.Condition>):
  First(ConditionList C sort by FHIRHelpers."ToDateTime"(recordedDate))  

// -------------------------------------------------- OBSERVATIONS -----------------------------------------------------

// Used by: HBGM, HOT, Immunosuppressive Drugs, PAP
define function LowestObservation(ObsList List<Observation>):
  Min(ObsList O return FHIRHelpers.ToQuantity(O.value as Quantity))

// Get value of an observation, without a unit (CDS_Connect_Commons_for_FHIR only allows access to an observations value with it's unit)
// Used by: PAP
define function GetObservationValue(Obs Observation): 
  NullSafeToQuantityWithoutUnit(cast Obs.value as Quantity)

//Retrieve the numerical value of a FHIR quantity, without units
// Use Case: Quantity value of Observation
// Used by: PAP, RAD
define function NullSafeToQuantityWithoutUnit(Qty FHIR.Quantity):
  if Qty is not null then Qty.value.value 
  else null

// -------------------------------------------------- ENCOUNTERS -----------------------------------------------------

// Used by: HospitalBedsAndAccessories
define function EncounterLookBack(EncounterList List<Encounter>, LookBack System.Quantity):
  EncounterList E
    let LookBackInterval: Interval[Now() - LookBack, Now()]
    where (cast E.period.start as dateTime).value in LookBackInterval
      or CDS.PeriodToInterval(cast E.period as Period) overlaps LookBackInterval

// Used by: HospitalBedsAndAccessories
define function ConvertEncounterDetails(EncounterList List<Encounter>):
  distinct(
    flatten(
      EncounterList E
        let EncounterCodings:
          (E.type.coding) CODING
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value,
            periodStart: E.period.start.value,
            encounterReason: E.reasonCode[0].coding.display.value,
            type: 'encounter'
          }
        return EncounterCodings
    )
  )

  // -------------------------------------------------- PROCEDURES -----------------------------------------------------

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