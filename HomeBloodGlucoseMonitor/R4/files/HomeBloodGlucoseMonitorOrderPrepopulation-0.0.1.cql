library HomeBloodGlucoseMonitorOrderPrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR


codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'


valueset "Diabetes Mellitus": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.35'
valueset "Insulin Medication": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.85'

code "Standard Monitor": 'E0607' from "HCPCS"

parameter device_request DeviceRequest

context Patient

define "DeviceRequestHcpcsCoding": singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
    return FHIRHelpers."ToCode"(coding))

define "MonitorType":
  if "DeviceRequestHcpcsCoding" ~ "Standard Monitor"
    then Code { code: 'Standard Monitor', display: 'Standard Monitor' }
    else Code { code: 'Monitor With Special Features', display: 'Monitor With Special Features' }

define "DiabetesDiagnosed": exists( [Condition: "Diabetes Mellitus"] )     

define "InsulinTreated":
  if exists([MedicationStatement: "Insulin Medication"])
    then Code { code: 'Insulin Treated', display: 'Insulin Treated' }
    else Code { code: 'Non-insulin Treated', display: 'Non-insulin Treated' }