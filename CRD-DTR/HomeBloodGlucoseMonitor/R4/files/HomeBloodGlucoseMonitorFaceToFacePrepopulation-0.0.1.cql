library HomeBloodGlucoseMonitorFaceToFacePrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'

valueset "DiabetesMellitusValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.35'
valueset "InsulinMedicationValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.85'

//Continuous blood glucose monitor
code "S1031": 'S1031' from "HCPCS"

parameter device_request DeviceRequest

context Patient

define "DMDiagnoses":  [Condition: "DiabetesMellitusValueSet"]
define "OtherDiagnoses": [Condition] except "DMDiagnoses"
define "DMCodings": DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring("DMDiagnoses")))
define "OtherDiagnosesCodings": DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring("OtherDiagnoses")))

define "ConfirmingDiabetesCondition": not exists("DMDiagnoses") 
define "DMConfirmedDate": FHIRHelpers."ToDateTime"(DTR.FirstDateConditionRecorded("DMDiagnoses").recordedDate)

define "DeviceRequestHcpcsCoding": singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
    return FHIRHelpers."ToCode"(coding))
define "IsNonContinuousBloodGlucoseMonitorOrdered": "DeviceRequestHcpcsCoding" !~ "S1031"

define "MonitorTiming": device_request.occurrence
define "MonitorFrequency": "MonitorTiming".repeat.frequency.value
define "MonitorEvent": FHIRHelpers.ToCode("MonitorTiming".code.coding)

define "InsulinTreated": exists([MedicationStatement: "InsulinMedicationValueSet"])