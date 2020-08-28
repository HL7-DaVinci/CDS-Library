library VentilatorsPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

valueset "Ventilator Therapy Qualifying Condition": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.48'
valueset "Ventilator Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.49'

parameter device_request DeviceRequest

context Patient

// coverage requirement info
define RelevantDiagnoses: 
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition: "Ventilator Therapy Qualifying Condition"]))) 

define OtherDiagnoses:
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition]))) except RelevantDiagnoses

define DeviceRequestHcpcsCoding: singleton from (
  (device_request.code.coding) CODING
    where CODING.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define DeviceRequested:
  if "DeviceRequestHcpcsCoding".code in "Ventilator Device" then "DeviceRequestHcpcsCoding".code.value
  else 'null'