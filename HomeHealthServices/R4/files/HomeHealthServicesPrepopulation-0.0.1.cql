library HomeHealthServicesPrepopulation  version '0.1.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

// This cql and questionnaire combo can be considered a partial implementation of these forms:
//  https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Medicare-Home-Health-Benefit-Text-Only.pdf

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'


parameter service_request ServiceRequest


context Patient 

define RelevantDiagnoses: 
  [Condition] condition
  	where ('Condition/' + condition.id) = RequestEncounter.diagnosis[0].condition.reference.value

define "RelavantDiagnosisCoding": DTR.CodesFromConditions(RelevantDiagnoses)

define "PatientDiagnoses": DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition])))

define "RequestEncounter": singleton from (
      [Encounter] encounter
        where ('Encounter/' + encounter.id) = service_request.encounter.reference.value)

//  returns Conditions
define "Diagnosis": RequestEncounter.diagnosis

define "DateF2F": RequestEncounter.period.start.value