library ImmunosuppressiveDrugsPriorAuthRule version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "LOINC": 'http://loinc.org'

context Patient

define PRIORAUTH_GRANTED:
  First([Claim] C
  return C.status.value = 'active')

define PRIORAUTH_PENDED:
  false