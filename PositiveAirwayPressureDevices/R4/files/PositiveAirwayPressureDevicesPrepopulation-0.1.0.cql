library PositiveAirwayPressureDevicePrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "Sleep Apnea or Breathing Related Sleep Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.31'
valueset "Apnea Hypopnea Index Rate Measurement": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.123'
valueset "Respiratory Disturbance Index": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.133'

parameter device_request DeviceRequest

context Patient

define "False": false
// coverage requirement info
define "RelevantDiagnoses": DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition: "Sleep Apnea or Breathing Related Sleep Disorder"])))

define OtherDiagnoses:
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition]))) except "RelevantDiagnoses"

define DeviceRequestHcpcsCoding: singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define DeviceRequestDescription: 'HCPCS ' + "DeviceRequestHcpcsCoding".code.value + ' - ' + "DeviceRequestHcpcsCoding".display.value
define PapDeviceRequested:
  if "DeviceRequestHcpcsCoding".code.value = 'E0470' then 'E0470'
  else if  "DeviceRequestHcpcsCoding".code.value = 'E0601' then 'E0601'
  else 'null'

define "AHI": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Apnea Hypopnea Index Rate Measurement"], 3 months)), '/h')))
define "RDI": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Respiratory Disturbance Index"], 3 months)), '/h')))