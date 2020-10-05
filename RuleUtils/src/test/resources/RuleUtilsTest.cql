library RuleUtilsTest version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "LOINC": 'http://loinc.org'

context Patient

define TEST:
  true

define BUNDLE_TEST:
  First([Patient] P
  return P.id.value = 'pat001')
