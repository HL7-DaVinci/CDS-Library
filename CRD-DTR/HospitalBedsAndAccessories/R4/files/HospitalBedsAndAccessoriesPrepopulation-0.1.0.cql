library HospitalBedsAndAccessoriesPrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "FixedHeightBedsCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.50'
valueset "VariableHeightBedsCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.51'
valueset "SemiElectricBedsCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.52'
valueset "TrapezeCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.55'
valueset "BedcradleCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.56'
valueset "SafetyrailCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.57'

//Body Weight code
code "29463-7": '29463-7' from "LOINC"

parameter device_request DeviceRequest

context Patient

define "BodyWeight_Codes": { "29463-7" }

define "BodyWeight": CDS.HighestObservation(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "BodyWeight_Codes"], 6 months)), '[lb_av]'))

define "RecentEncounters": DTR.EncounterLookBack([Encounter], 6 months)
define "EncounterList": DTR.ConvertEncounterDetails("RecentEncounters")

define "DeviceRequestHcpcsCoding": singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define "DeviceRequestDescription": 'HCPCS ' + "DeviceRequestHcpcsCoding".code.value + ' - ' + "DeviceRequestHcpcsCoding".display.value
define "DeviceRequested":
  if "DeviceRequestHcpcsCoding".code.value = 'E0250' then 'E0250'
  else if "DeviceRequestHcpcsCoding".code.value = 'E0251' then 'E0251'
  else 'null'

define "FixedHeightBedsOrdered": "DeviceRequestHcpcsCoding" in "FixedHeightBedsCodes"
define "VariableHeightBedsOrdered": "DeviceRequestHcpcsCoding" in "VariableHeightBedsCodes"
define "SemiElectricBedsOrdered": "DeviceRequestHcpcsCoding" in "SemiElectricBedsCodes"
define "TrapezeOrdered": "DeviceRequestHcpcsCoding" in "TrapezeCodes"
define "BedcradleOrdered": "DeviceRequestHcpcsCoding" in "BedcradleCodes"
define "SafetyrailOrdered": "DeviceRequestHcpcsCoding" in "SafetyrailCodes"