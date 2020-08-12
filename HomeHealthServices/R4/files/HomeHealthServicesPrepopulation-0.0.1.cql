library HomeHealthServicesPrepopulation  version '0.1.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'

parameter service_request ServiceRequest

context Patient

define "Today": Today()

define "True": true

define "False": false

define RelevantDiagnoses: 
  [Condition] condition
  	where ('Condition/' + condition.id) = RequestEncounter.diagnosis[0].condition.reference.value

define "RelavantDiagnosisCoding": ConvertConditionDetails(RelevantDiagnoses)

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

define "OtherDiagnoses": 
  ActiveOrRecurring([Condition] except RelevantDiagnoses)

define "OtherDiagnosesCoding":ConvertConditionDetails(OtherDiagnoses)

define function ActiveOrRecurring(CondList List<Condition>):
  CondList C where C.clinicalStatus.coding.code in {'active', 'relapse'}

define function getOnsetString(cond FHIR.Condition):
  Coalesce(cond.onset,'Unspecified')


define "RequestEncounter": singleton from (
      [Encounter] encounter
        where ('Encounter/' + encounter.id) = service_request.encounter.reference.value)

//  returns Conditions
define "Diagnosis": RequestEncounter.diagnosis

//  returns the index-th diagnosis (a Condition)
define function getCondition(index Integer) : singleton from (
    [Condition] cond
      where ('Condition/' + cond.id ) = Diagnosis[index].condition.reference.value)
    

