library HomeHealthServicesPrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10": 'http://hl7.org/fhir/sid/icd-10'
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'

valueset "Intermittent Home Health Procedures Skilled Nursing": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.105'
valueset "Physical Therapy Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.99'
valueset "Occupational Therapy Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.101'
valueset "Speech Language Therapy Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.103'
valueset "Home Health Procedure HCPCS": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.104'

parameter service_request ServiceRequest

context Patient

define "RequestEncounter": singleton from (
  [Encounter] encounter
    where ('Encounter/' + encounter.id) = service_request.encounter.reference.value)

define "RequestAuthoredOnDate": service_request.authoredOn.value

define "F2FDate": RequestEncounter.period.start.value

define "F2FStartDate": RequestEncounter.period.start.value

define "F2FEndDate": RequestEncounter.period.end.value

define "PatientMedicalRecordNumber": Patient.identifier[0].value.value

define "EncounterInterval": FHIRHelpers."ToInterval"(RequestEncounter.period)

define "ConsentACD": singleton from (
  [Consent] consent
    where consent.category[0].coding[0].code.value = 'acd'
)

define "ACDSigned": "ConsentACD" is not null
define "ACDDetails": 'Advanced Directives was signed on ' + ToString("ConsentACD".dateTime.value)

define "RelavantDiagnosis": 
  [Condition] condition
    where ('Condition/' + condition.id) = RequestEncounter.diagnosis[0].condition.reference.value

define "RelavantDiagnosisCoding": ConvertConditionDetails(RelavantDiagnosis)

define function ConvertConditionDetails(CondList List<Condition>):
  distinct(
    flatten(
      CondList C
        let ConditionCodings:
          (C.code.coding) CODING
          return FHIRHelpers.ToCode(CODING)     
        return ConditionCodings
    )
  )

// Care plan related queries
define "RequestCarePlan": singleton from (
  [CarePlan] carePlan
    where ('CarePlan/' + carePlan.id) = service_request.basedOn[0].reference.value)

define "CarePlanActivityList": "RequestCarePlan".activity  

define "CarePlanActivityForDeviceRequestsCodings": 
  distinct(
      flatten(
      "CarePlanActivityList" activity
        let activityCodings:
          (activity.detail.code.coding) CODING
          return FHIRHelpers.ToCode(CODING)
        where activity.detail.kind = 'DeviceRequest'  
        return activityCodings
        )
  )

define "CarePlanActivityForSafetyCodings": 
  distinct(
    flatten(
      "CarePlanActivityList" activity
        let activityCodings:
          (activity.detail.code) CODE
          return Tuple {
            display: CODE.text.value
          }
        where activity.detail.kind = 'Task' and activity.detail.reasonCode[0].text = 'Safety measures'
        return activityCodings
    )
  )

define "CarePlanActivityForNutritionOrderCodings": 
  distinct(
    flatten(
      "CarePlanActivityList" activity
        let activityCodings:
          (activity.detail.code.coding) CODING
          return FHIRHelpers.ToCode(CODING)
        where activity.detail.kind = 'NutritionOrder'  
        return activityCodings
    )
  )        

define "ClinicalImpression": singleton from (
  [ClinicalImpression] impression
    let impressionCodings:
      (impression.prognosisCodeableConcept[0].coding[0]) CODING
      return CODING.display.value
    where impression.encounter.reference.value = service_request.encounter.reference.value
    return impressionCodings  
  )  

// TODO 
define "RequestProvenance": singleton from (
  [Provenance] provenance
    where ('Provenance/' + provenance.id) = service_request.relevantHistory[0].reference
  )

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