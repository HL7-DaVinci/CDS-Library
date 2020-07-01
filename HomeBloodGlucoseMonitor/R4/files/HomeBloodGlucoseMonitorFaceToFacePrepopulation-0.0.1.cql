library HomeBloodGlucoseMonitorFaceToFacePrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

valueset "DiabetesMellitusValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.35'

parameter device_request DeviceRequest

context Patient
 
define "OtherDiagnoses": GetConditionCodings([Condition] except "DiabetesMellitusValueSet")
define "DMCodings": GetConditionCodings([Condition: "DiabetesMellitusValueSet"])

define function GetConditionCodings(ConditionList List<FHIR.Condition>):
  distinct(
    flatten(
      ConditionList C
        let ConditionCodings:
          (C.code.coding) CODING 
          return FHIRHelpers.ToCode(CODING)
        where C.clinicalStatus.coding.code = 'active' and exists(ICD10Codings)  
        return ConditionCodings
    )
  )