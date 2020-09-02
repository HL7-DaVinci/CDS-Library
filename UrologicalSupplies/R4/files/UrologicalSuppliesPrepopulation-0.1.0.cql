library UrologicalSuppliesPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

codesystem "ICD-10": 'http://hl7.org/fhir/sid/icd-10'
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'

valueset "Urinary Incontinence or Chronic Urinary Retention Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.70'
valueset "Urinary Collection and Irrigation System Device or Supply": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.61'
valueset "Intermittent Urinary Catheter or Urological Supply for Intermittent Urinary Catheter Supply": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.59'
valueset "External Catheter or Urinary Collection Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.62'
valueset "Miscellaneous Urinary Catheter Supply": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.63'
valueset "Indwelling Urinary Catheter Supply or Urological Supply for Indwelling Urinary Catheter Supply": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.60'


parameter device_request DeviceRequest

context Patient

// coverage requirement info
define RelevantDiagnoses: 
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition: "Urinary Incontinence or Chronic Urinary Retention Disorder"]))) 

define CurrentDiagnoses:
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition]))) except RelevantDiagnoses

define DeviceRequestHcpcsCoding: singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define DeviceRequested:
  if "DeviceRequestHcpcsCoding".code in "Urinary Collection and Irrigation System Device or Supply" then "DeviceRequestHcpcsCoding".code.value
  else if "DeviceRequestHcpcsCoding".code in "Intermittent Urinary Catheter or Urological Supply for Intermittent Urinary Catheter Supply" then "DeviceRequestHcpcsCoding".code.value
  else if "DeviceRequestHcpcsCoding".code in "External Catheter or Urinary Collection Device" then "DeviceRequestHcpcsCoding".code.value
  else if "DeviceRequestHcpcsCoding".code in "Miscellaneous Urinary Catheter Supply" then "DeviceRequestHcpcsCoding".code.value
  else if "DeviceRequestHcpcsCoding".code in "Indwelling Urinary Catheter Supply or Urological Supply for Indwelling Urinary Catheter Supply" then "DeviceRequestHcpcsCoding".code.value
  else 'null'