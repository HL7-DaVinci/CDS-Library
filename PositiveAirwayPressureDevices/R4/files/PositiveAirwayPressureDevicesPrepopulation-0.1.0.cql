library PositiveAirwayPressureDevicePrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "Sleep Apnea or Breathing Related Sleep Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.31'
valueset "Apnea Hypopnea Index Rate Measurement": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.123'
valueset "Respiratory Disturbance Index": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.133'

parameter device_request DeviceRequest

context Patient

// coverage requirement info
define "RelevantDiagnoses": CodesFromConditions(Confirmed(ActiveOrRecurring([Condition: "Sleep Apnea or Breathing Related Sleep Disorder"])))

define OtherDiagnoses:
  CodesFromConditions(Confirmed(ActiveOrRecurring([Condition]))) except "RelevantDiagnoses"

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

define DeviceRequestHcpcsCoding: singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define DeviceRequestDescription: 'HCPCS ' + "DeviceRequestHcpcsCoding".code.value + ' - ' + "DeviceRequestHcpcsCoding".display.value
define PapDeviceRequested:
  if "DeviceRequestHcpcsCoding".code.value = 'E0470' then 'E0470'
  else if  "DeviceRequestHcpcsCoding".code.value = 'E0601' then 'E0601'
  else 'null'

define "AHI": GetObservationValue(LastestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Apnea Hypopnea Index Rate Measurement"], 3 months)), '/h')))
define "RDI": GetObservationValue(LastestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Respiratory Disturbance Index"], 3 months)), '/h')))

define function LastestObservation(ObsList List<Observation>):
  First(ObsList O sort by FHIRHelpers."ToDateTime"(issued) desc)

define function GetObservationValue(Obs Observation): 
  NullSafeToQuantityWithoutUnit(cast Obs.value as Quantity)

define function NullSafeToQuantityWithoutUnit(Qty FHIR.Quantity):
  if Qty is not null then Qty.value.value 
  else null
////////////////////////////// Taken from CDS Connect Commons for FHIR, could replace with r4 version of helper library
define function ActiveOrRecurring(CondList List<Condition>):
  CondList C where C.clinicalStatus.coding.code in {'active', 'relapse'}

define function ObservationLookBack(ObsList List<Observation>, LookBack System.Quantity):
  ObsList O
    let LookBackInterval: Interval[Now() - LookBack, Now()]
    where (cast O.effective as dateTime).value in LookBackInterval
      or NullSafeToInterval(cast O.effective as Period) overlaps LookBackInterval
      or FHIRHelpers."ToDateTime"(O.issued) in LookBackInterval

define function NullSafeToInterval(Pd FHIR.Period):
  if Pd is not null then Interval[Pd."start".value, Pd."end".value] else null

define function Verified(ObsList List<Observation>):
  ObsList O where O.status.value in {'final', 'amended'}

define function WithUnit(ObsList List<Observation>, Unit String):
  ObsList O where (cast O.value as Quantity).unit.value = Unit or (cast O.value as Quantity).code.value = Unit

define function Confirmed(CondList List<Condition>):
  CondList C where C.verificationStatus.coding.code = 'confirmed'




