library HomeHealthServicesPlanOfCarePrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

parameter service_request ServiceRequest

context Patient

define "service_requestInput": service_request
define "PatientInput": Patient

define "RequestEncounter": singleton from (
  [Encounter] encounter
    where ('Encounter/' + encounter.id) = service_request.encounter.reference.value)

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
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value
          }
        
        return ConditionCodings
    )
  )


define "MedicationStatementList": [MedicationStatement]

// TODO 
//define "MedicationList": GetMedicationsList("MedicationStatementList")
// only work for the assumption that the medication statement contains the medication in contained
/*define function GetMedicationsList(MedStatementList List<MedicationStatement>):
  distinct(
    flatten(
      MedStatementList MedStatement
        let MedicationList:
          return MedStatement.category.coding
        return MedicationList  
    )
  )*/
define function MedicationCodings(MedList List<Medication>):
  distinct(
    flatten(
      MedList M
        let MedicationCodings:
          (M.code.coding) CODING
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value
          }
        
        return MedicationCodings
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
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value
          }
        where activity.detail.kind = 'DeviceRequest'  
        return activityCodings
        )
  )

define "CarePlanActivityForSafetyCodings": 
  distinct(
    flatten(
      "CarePlanActivityList" activity
        let activityCodings:
          (activity.detail.code.coding) CODING
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value
          }
        where activity.detail.kind = 'Task'  
        return activityCodings
    )
  )

define "CarePlanActivityForNutritionOrderCodings": 
  distinct(
    flatten(
      "CarePlanActivityList" activity
        let activityCodings:
          (activity.detail.code.coding) CODING
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value
          }
        where activity.detail.kind = 'NutritionOrder'  
        return activityCodings
    )
  )        

define "ClinicalImpression": singleton from (
  [ClinicalImpression] impression
    let impressionCodings:
      (impression.prognosisCodeableConcept[0].coding[0]) CODING
      return CODING.display.value + '-' + CODING.code.value
    where impression.encounter.reference.value = service_request.encounter.reference.value
    return impressionCodings  
  )  

// TODO 
define "RequestProvenance": singleton from (
  [Provenance] provenance
    where ('Provenance/' + provenance.id) = service_request.relevantHistory[0].reference
  )
