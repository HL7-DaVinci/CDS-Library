library RespiratoryAssistDevicesFaceToFacePrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

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

define "AHI": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "AHI_Codes"], 9 months)), '/h')))
define "MIP": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "MIP_Codes"], 9 months)), 'cm[H2O]')))
define "FEV1_FVC_Ratio": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "FEV1_FVC_Ratio_Codes"], 9 months)), '%')))
define "FVC": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "FVC_Codes"], 9 months)), '%')))

// Observation code lists
define "FEV1_predicted": { "20152-5" }
define "FEV1": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "FEV1_predicted"], 9 months)), '%')))