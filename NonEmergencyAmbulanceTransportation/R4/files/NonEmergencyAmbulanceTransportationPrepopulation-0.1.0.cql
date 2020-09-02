library NonEmergencyAmbulanceTransportationPrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

valueset "Ambulance Transport Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.108'
valueset "NEAT Qualifying Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.188'

parameter service_request ServiceRequest

context Patient

define "ServiceRequestHcpcsCoding": singleton from (
  ((cast service_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
    return FHIRHelpers.ToCode(coding))

define NeatServiceRequested: 
  if "ServiceRequestHcpcsCoding" in "Ambulance Transport Procedure" then "ServiceRequestHcpcsCoding".code
  else null

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

define RelevantDiagnoses: 
  CodesFromConditions(Confirmed(ActiveOrRecurring([Condition: "NEAT Qualifying Conditions"]))) 

define AllDiagnoses:
  CodesFromConditions(Confirmed(ActiveOrRecurring([Condition])))

// Helpers

define function CodesFromConditions(CondList List<Condition>):
  distinct(flatten(
    CondList C
      let DiagnosesCodings:
          (C.code.coding) CODING where CODING.system.value in {
            'http://hl7.org/fhir/sid/icd-10',
            'http://hl7.org/fhir/sid/icd-10-cm',
            'http://snomed.info/sct'
          }
          return FHIRHelpers.ToCode(CODING)
      return DiagnosesCodings
))

define function Confirmed(CondList List<Condition>):
  CondList C where C.verificationStatus.coding.code = 'confirmed'

define function ActiveOrRecurring(CondList List<Condition>):
  CondList C where C.clinicalStatus.coding.code in {'active', 'relapse'}
  
