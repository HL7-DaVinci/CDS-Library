library HomeBloodGlucoseMonitorFaceToFacePrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "DiabetesMellitusValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.35'

parameter device_request DeviceRequest

context Patient

define "AllDiagnoses":
  distinct(flatten(
    [Condition] C
      let ICD10Codings:
        ((C.code.coding) CODING where CODING.system.value in {
          'http://hl7.org/fhir/sid/icd-10',
          'http://hl7.org/fhir/sid/icd-10-cm'
        }
        return CODING.code.value + ' - ' + CODING.display.value)
      where C.clinicalStatus.coding.code = 'active'
      and exists(ICD10Codings)
      return ICD10Codings
  ))

define "DM": "DiabetesMellitusValueSet"

define "DMDiagnosis": ["AllDiagnoses": "DiabetesMellitusValueSet"]

define "": 

