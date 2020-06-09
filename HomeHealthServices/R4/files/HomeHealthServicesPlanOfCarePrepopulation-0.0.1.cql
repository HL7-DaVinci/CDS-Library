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
define "Consent": [Consent]

define "RequestCarePlan": singleton from (
  [CarePlan] carePlan
    where ('CarePlan/' + carePlan.id) = service_request.basedOn[0].reference.value)

define "RequestEncounter": singleton from (
  [Encounter] encounter
    where ('Encounter/' + encounter.id) = service_request.encounter.reference.value)

define "ClinicalImpression": singleton from (
  [ClinicalImpression] impression
    where impression.encounter.reference.value = service_request.encounter.reference.value)    

