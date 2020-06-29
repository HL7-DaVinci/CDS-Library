library NonEmergencyAmbulanceTransportationPrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "AmbulanceTransportProcedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.108'

parameter service_request ServiceRequest

context Patient

define "ServiceRequestHcpcsCoding": singleton from (
  service_request.code.coding coding
    where coding[0].system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define "ServiceRequestDescription": 'HCPCS ' + "ServiceRequestHcpcsCoding".code.value + ' - ' + "ServiceRequestHcpcsCoding".display.value
define "NeatServiceRequested":
  if "ServiceRequestHcpcsCoding".code.value = 'A0426' then 'A0426'
  else if  "ServiceRequestHcpcsCoding".code.value = 'A0428' then 'A0428'
  else 'null'

define "NeatServiceRequestedCoding":
  {FHIRHelpers.ToCode(ServiceRequestHcpcsCoding)}

define "ServiceRequestReason": service_request.reasonCode[0].text.value

define "ServiceStartDate": FHIRHelpers.ToDateTime(
    Coalesce(
      service_request.occurrence as FHIR.dateTime, 
      (service_request.occurrence as FHIR.Period).start
    )
  )

define "ServiceEndDate": FHIRHelpers.ToDateTime(
    Coalesce(
      service_request.occurrence as FHIR.dateTime, 
      (service_request.occurrence as FHIR.Period).end
    )
  )
  
