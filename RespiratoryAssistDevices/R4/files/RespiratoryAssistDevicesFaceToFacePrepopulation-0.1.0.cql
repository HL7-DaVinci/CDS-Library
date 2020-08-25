library RespiratoryAssistDevicesFaceToFacePrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRFunctions version '0.1.0' called DTR

codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'

//Motor Neuron Disease or Spinal Muscular Atrophy Disorder
valueset "Neuromuscular Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.44'
//Chronic Obstructive Lung Disease (COPD)
valueset "COPD": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.6'
//Hypoventilation Disorder
valueset "Hypoventilation Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.121'
//Sleep Apnea or Breathing Related Sleep Disorder
valueset "Apnea Sleep Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.31'

//Apnea Hypopnea Index Rate Measurement
valueset "AHI_Codes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.123'
//Maximal Inspiratory Pressure Measurement
valueset "MIP_Codes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.125'
//Forced Vital Capacity (FVC) Measurement Prediction
valueset "FVC_Codes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.131'
//Forced Expiratory Volume in One Second (FEV1)/Forced Vital Capacity (FVC) Measurement
valueset "FEV1_FVC_Ratio_Codes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.124'


// LOINC code 'FEV1 measured/predicted' observation
code "20152-5": '20152-5' from "LOINC"

parameter device_request DeviceRequest


context Patient

define "HasNeuromuscularDisease": exists([Condition: "Neuromuscular Disease"])
define "HasCOPD": exists([Condition: "COPD"])
define "HasCSAorCompSA": exists([Condition: "Apnea Sleep Disorder"])
define "HasHypoventilationDisorder": exists([Condition: "Hypoventilation Disorder"])
define "HasOSA": exists([Condition: "Apnea Sleep Disorder"])

define "AHI": GetObservationValue(LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "AHI_Codes"], 9 months)), '/h')))
define "MIP": GetObservationValue(LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "MIP_Codes"], 9 months)), 'cm[H2O]')))
define "FEV1_FVC_Ratio": GetObservationValue(LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "FEV1_FVC_Ratio_Codes"], 9 months)), '%')))
define "FVC": GetObservationValue(LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "FVC_Codes"], 9 months)), '%')))

// Observation code lists
define "FEV1_predicted": { "20152-5" }
define "FEV1": GetObservationValue(LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "FEV1_predicted"], 9 months)), '%')))

define function LatestObservation(ObsList List<Observation>):
  First(ObsList O sort by FHIRHelpers."ToDateTime"(issued) desc)

define function GetObservationValue(Obs Observation):
  NullSafeToQuantityValue(cast Obs.value as Quantity)


////////////////////////////// Taken from CDS Connect Commons for FHIR, could replace with r4 version of helper library

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

define function NullSafeToQuantityValue(Qty FHIR.Quantity):
  if Qty is not null then
    Qty.value.value
  else null
