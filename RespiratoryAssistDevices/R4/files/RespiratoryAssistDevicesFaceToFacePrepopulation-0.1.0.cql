library RespiratoryAssistDevicesFaceToFacePrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'


//Respiratory Assist Device Qualifying Condition grouping value set
valueset "RAD Qualifying Condition": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.122'

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


// LOINC codes for observations
// Circumference Neck
code "56074-8": '56074-8' from "LOINC"
// Body mass index (BMI) [Ratio]
code "39156-5": '39156-5' from "LOINC"

parameter device_request DeviceRequest


context Patient

define Today: Today()


define "EncounterDate":
  if exists([Encounter]) then First([Encounter]).period.start.value
  else "Today"

define "RADDiagnoses":  [Condition: "RAD Qualifying Condition"]
define "OtherDiagnoses": [Condition] except "RADDiagnoses"
define "RADCodings": GetConditionCodings(ActiveOrOccurringCondition("RADDiagnoses"))
define "OtherDiagnosesCodings": GetConditionCodings(ActiveOrOccurringCondition("OtherDiagnoses"))

define function GetConditionCodings(ConditionList List<FHIR.Condition>):
  distinct(
    flatten(
      ConditionList C
        let ConditionCodings:
          (C.code.coding) CODING
          return FHIRHelpers.ToCode(CODING)
        where exists(ConditionCodings)
        return ConditionCodings
    )
  )

define function ActiveOrOccurringCondition(ConditionList List<FHIR.Condition>):
  ConditionList C
  where C.clinicalStatus.coding.code in {'active', 'relapse'}

define "HasNeuromuscularDisease": exists([Condition: "Neuromuscular Disease"])
define "HasCOPD": exists([Condition: "COPD"])
define "HasCSAorCompSA": exists([Condition: "Apnea Sleep Disorder"])
define "HasHypoventilationDisorder": exists([Condition: "Hypoventilation Disorder"])
define "HasOSA": exists([Condition: "Apnea Sleep Disorder"])

define "AHI": LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "AHI_Codes"], 9 months)), '/h'))
define "MIP": LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "MIP_Codes"], 9 months)), 'cm[H2O]'))
define "FEV1_FVC_Ratio": LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "FEV1_FVC_Ratio_Codes"], 9 months)), '%'))
define "FVC": LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "FVC_Codes"], 9 months)), '%'))

// Observation code lists
define "Circumference Neck": { "56074-8" }
define "BMI Ratio": { "39156-5" }

define "NeckCircumf": LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Circumference Neck"], 9 months)), 'cm'))
define "BMI": LatestObservation(WithUnit(Verified(ObservationLookBack([Observation: "BMI Ratio"], 9 months)), 'kg/m2'))

define function LatestObservation(ObsList List<Observation>):
  First(ObsList O return NullSafeToQuantity(cast O.value as Quantity))



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

define function NullSafeToQuantity(Qty FHIR.Quantity):
  if Qty is not null then
    System.Quantity {
      value: Qty.value.value,
      unit: Coalesce(Qty.unit.value, Qty.code.value)
    }
  else null
