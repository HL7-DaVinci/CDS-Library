library HomeHealthServicesPlanOfCarePrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

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

define "RelavantDiagnosisCoding": DTR.CodesFromConditions(RelavantDiagnosis)

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
