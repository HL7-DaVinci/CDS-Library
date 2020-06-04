library HomeHealthServicesPrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

//define Today: Today()

parameter service_request ServiceRequest

context Patient

//define "ServiceRequestHcpcsCoding": singleton from (
//  service_request.code.coding coding
//    where coding[0].system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

//define "ServiceRequestDescription": 'HCPCS ' + "ServiceRequestHcpcsCoding".code.value + ' - ' + "ServiceRequestHcpcsCoding".display.value
//define "HomeHealthServiceRequested":
//  if "ServiceRequestHcpcsCoding".code.value = 'G0179' then 'G0179'
//  else if  "ServiceRequestHcpcsCoding".code.value = 'G0180' then 'G0180'
//  else 'null'

//define "ServiceRequestReason": service_request.reasonCode[0].text.value



