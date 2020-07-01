library HomeBloodGlucoseMonitorFaceToFacePrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

valueset "DiabetesMellitusValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.35'

parameter device_request DeviceRequest

context Patient

define "OtherDiagnoses":
  distinct(flatten(
    [Condition] C
      let ICD10Codings:
        ((C.code.coding) CODING where CODING.system.value in {
          'http://hl7.org/fhir/sid/icd-10',
          'http://hl7.org/fhir/sid/icd-10-cm'
        }
        return CODING.code.value + ' - ' + CODING.display.value)
      where C.clinicalStatus.coding.code = 'active' and exists(ICD10Codings) and ((C.code.coding[0].code in "DiabetesMellitusValueSet") = false)
      return ICD10Codings
  ))

define "DiabetesMellitusDiagnoses":
  distinct(flatten(
    [Condition] C
      let ICD10Codings:
        ((C.code.coding) CODING where CODING.system.value in {
          'http://hl7.org/fhir/sid/icd-10',
          'http://hl7.org/fhir/sid/icd-10-cm'
        }
        return CODING.code.value + ' - ' + CODING.display.value)
      where C.clinicalStatus.coding.code = 'active' and exists(ICD10Codings) and (C.code.coding[0].code in "DiabetesMellitusValueSet") = true
      return ICD10Codings
  ))

define "DMConditions": [Condition: "DiabetesMellitusValueSet"]  
define "DMCodings": GetConditionCodings("DMConditions")
define function GetConditionCodings(ConditionList List<FHIR.Condition>):
  distinct(
    flatten(
      ConditionList C
        let ConditionCodings:
          (C.code.coding) CODING 
          return FHIRHelpers.ToCode(CODING)
        return ConditionCodings
    )
  )