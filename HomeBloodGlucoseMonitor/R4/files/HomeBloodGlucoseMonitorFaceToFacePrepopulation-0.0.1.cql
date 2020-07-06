library HomeBloodGlucoseMonitorFaceToFacePrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'

valueset "DiabetesMellitusValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.35'
valueset "InsulinMedicationValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.85'

//Continuous blood glucose monitor
code "S1031": 'S1031' from "HCPCS"

parameter device_request DeviceRequest

context Patient

define "DMDiagnoses":  [Condition: "DiabetesMellitusValueSet"]
define "OtherDiagnoses": [Condition] except "DMDiagnoses"
define "DMCodings": GetConditionCodings(ActiveOrOccurringCondition("DMDiagnoses"))
define "OtherDiagnosesCodings": GetConditionCodings(ActiveOrOccurringCondition("OtherDiagnoses"))

define "ConfirmingDiabetesCondition": not exists("DMDiagnoses") 
define "DMConfirmedDate": FHIRHelpers."ToDateTime"(FirstDateConditionRecorded("DMDiagnoses").recordedDate)

define "DeviceRequestHcpcsCoding": singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
    return FHIRHelpers."ToCode"(coding))
define "IsNonContinuousBloodGlucoseMonitorOrdered": "DeviceRequestHcpcsCoding" !~ "S1031"

define "MonitorTiming": device_request.occurrence
define "MonitorFrequency": "MonitorTiming".repeat.frequency.value
define "MonitorEvent": FHIRHelpers.ToCode("MonitorTiming".code.coding)

define "InsulinTreated": exists([MedicationStatement: "InsulinMedicationValueSet"])

define function GetConditionCodings(ConditionList List<FHIR.Condition>):
  distinct(
    flatten(
      ConditionList C
        let ConditionCodings:
          (C.code.coding) CODING 
          return FHIRHelpers.ToCode(CODING)
        where exists(ConditionCodings)  
        return ConditionCodings
    )
  )

define function ActiveOrOccurringCondition(ConditionList List<FHIR.Condition>):
  ConditionList C
  where C.clinicalStatus.coding.code in {'active', 'relapse'}

define function FirstDateConditionRecorded(ConditionList List<FHIR.Condition>):
  First(ConditionList C sort by FHIRHelpers."ToDateTime"(recordedDate))  