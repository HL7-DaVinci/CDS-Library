library HomeOxygenTherapyPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers


// This cql and questionnaire combo can be considered a partial implementation of these forms:
// https://www.cms.gov/Medicare/CMS-Forms/CMS-Forms/Downloads/CMS484.pdf
// https://www.cms.gov/Research-Statistics-Data-and-Systems/Computer-Data-and-Systems/Electronic-Clinical-Templates/Downloads/Home-Oxygen-Therapy-Order-Template-Draft-20170905-R40.pdf
// with guidance from https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-ICN908804.pdf


codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
codesystem "FHIRRequestIntent": 'http://hl7.org/fhir/request-intent'

//COPD_Codes
valueset "COPD": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.6'

//Bronchiectasis_Codes
valueset "Bronchiectasis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.3'

//Hypoxemia_Codes
valueset "Hypoxemia Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.9'

//Diffuse_interstitial_lung_disease_Codes
valueset "Interstitial Lung Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.12'

//Cystic_fibrosis_Codes
valueset "Cystic Fibrosis Lung Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.15'

// All Devices
valueset "Home Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.74'

// Device Categories
valueset "Stationary Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.28'
valueset "Portable Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.27'
valueset "Liquid Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.71'
valueset "Compressed Gas Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.72'
valueset "Oxygen Concentrator Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.73'

//Pulmonary_hypertension_Codes
code "I27.0": 'I27.0' from "ICD-10-CM"
code "I27.2": 'I27.2' from "ICD-10-CM"

//  Loinc codes for observations
//Arterial_oxygen_saturation_Codes
code "59408-5": '59408-5' from "LOINC"
//Arterial_partial_pressure_of_oxygen_Codes
code "2703-7": '2703-7' from "LOINC"
//Arterial_oxygen_saturation_during_exercise_Codes
code "89276-0": '89276-0' from "LOINC"
//Note: cant find loinc code for partial pressure during exercise

//Hematocrit_lab_test_Codes
code "20570-8": '20570-8' from "LOINC"
code "31100-1": '31100-1' from "LOINC"
code "32354-3": '32354-3' from "LOINC"
code "41654-5": '41654-5' from "LOINC"
code "41655-2": '41655-2' from "LOINC"
code "4544-3": '4544-3' from "LOINC"
code "4545-0": '4545-0' from "LOINC"
code "71829-6": '71829-6' from "LOINC"
code "71830-4": '71830-4' from "LOINC"
code "71832-0": '71832-0' from "LOINC"
code "71833-8": '71833-8' from "LOINC"



//Immobilization_Codes
code "102491009": '102491009' from "SNOMED-CT"
code "129857008": '129857008' from "SNOMED-CT"
code "129859006": '129859006' from "SNOMED-CT"
code "160685001": '160685001' from "SNOMED-CT"
code "371632003": '371632003' from "SNOMED-CT"
code "8510008": '8510008' from "SNOMED-CT"

//Pulmonary artery Mean blood pressure
code "8414-5": '8414-5' from "LOINC"

// FHIR Request Intent Codes
code "Intent Original Order code": 'original-order' from "FHIRRequestIntent" display 'Original Order'
concept "Intent Original Order": { "Intent Original Order code" } display 'Original Order'

parameter device_request DeviceRequest

// Relevant Diagnosis Code Lists
define "Pulmonary_hypertension_Codes": { "I27.0", "I27.2" }

// Observation code lists
define "Arterial_oxygen_saturation_Codes": { "59408-5" }
define "Arterial_partial_pressure_of_oxygen_Codes": { "2703-7" }
define "Arterial_oxygen_saturation_during_exercise_Codes": { "89276-0" }

define "Hematocrit_lab_test_Codes": { "20570-8", "31100-1", "32354-3", "41654-5", "41655-2", "4544-3", "4545-0", "71829-6", "71830-4", "71832-0", "71833-8" }
define "Hematocrit_Codes": {"31100-1"}
// Other codes
define "Immobilization_Codes": { "102491009", "129857008", "129859006", "160685001", "371632003", "8510008" }

define "Pulmonary_artery_pressure_Codes": {"8414-5"}

context Patient

define Today: Today()

define "AllCOPD":
  Confirmed(ActiveOrRecurring([Condition: "COPD"]))

// coverage requirement info
define RelevantDiagnoses: {
  if exists(Confirmed(ActiveOrRecurring([Condition: "COPD"]))) then 'COPD' else 'null',
  if exists(Confirmed(ActiveOrRecurring([Condition: "Bronchiectasis"]))) then 'Bronchiectasis' else 'null',
  if exists(Confirmed(ActiveOrRecurring([Condition: "Interstitial Lung Disease"]))) then 'Interstitial Lung Disease' else 'null',
  if exists(Confirmed(ActiveOrRecurring([Condition: "Cystic Fibrosis Lung Disease"]))) then 'Cystic Fibrosis' else 'null',
  if exists(Confirmed(ActiveOrRecurring([Condition: "Pulmonary_hypertension_Codes"]))) then 'Pulmonary Hypertension' else 'null',
  if exists(Confirmed(ActiveOrRecurring([Condition: "Hypoxemia Disorder"]))) then 'Hypoxemia' else 'null'
} except { 'null' } // except 'null' is a workaround since I don't see how to remove actual nulls

define "VerifiedArterialOxygenSatuation": Verified(ObservationLookBack([Observation: "Arterial_oxygen_saturation_Codes"], 3 months))
define ArterialOxygenSaturation: LowestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Arterial_oxygen_saturation_Codes"], 3 months)), '%'))
define "VerifiedArterialPartialPressureOfOxygen": Verified(ObservationLookBack([Observation: "Arterial_partial_pressure_of_oxygen_Codes"], 3 months))
define ArterialPartialPressureOfOxygen: LowestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Arterial_partial_pressure_of_oxygen_Codes"], 3 months)), 'mm[Hg]'))
define "VerifiedArterialOxygenSaturationExercise": Verified(ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months))
define ArterialOxygenSaturationExercise: LowestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months)), '%'))

define PatientMobile: not exists(Confirmed(ActiveOrRecurring([Condition: "Immobilization_Codes"])))

define HematocritThatIsGreaterThanThreshold: HighestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Hematocrit_lab_test_Codes"], 3 months)), '%'))
define PatientHasHematocritThatIsGreaterThanThreshold: exists("HematocritThatIsGreaterThanThreshold")

define "OxygenSatExercise": ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months)
define "OxygenSatExerciseDate": ObservationLatestDate("OxygenSatExercise")
define "IsArterialOxygenSaturationExerciseTested": "ArterialOxygenSaturationExercise" is not null

define "PulmonaryArteryPressure": HighestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Pulmonary_artery_pressure_Codes"], 3 months)), 'mm[Hg]'))

// device request info
define DeviceRequestHcpcsCoding: singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
    return FHIRHelpers."ToCode"(coding))

define DeviceRequestDescription: 'HCPCS ' + "DeviceRequestHcpcsCoding".code + ' - ' + Coalesce("DeviceRequestHcpcsCoding".display)
define DeviceRequestedIsPortable: "DeviceRequestHcpcsCoding" in "Portable Oxygen Therapy Device"
define DeviceRequestedIsStationary: "DeviceRequestHcpcsCoding" in "Stationary Oxygen Therapy Device"

define "DeviceType":
  if DeviceRequestHcpcsCoding in "Compressed Gas Oxygen Therapy Device"
    then 'Compressed Gas'
  else if DeviceRequestHcpcsCoding in "Liquid Oxygen Therapy Device"
    then 'Liquid'
  else if DeviceRequestHcpcsCoding in "Oxygen Concentrator Therapy Device"
    then 'Concentrator'
  else
    null

define "DeviceOrderType":
  if device_request.intent.value = 'original-order'
    then 'Initial or original order for certification'
    else null

// prescribed use
define "OccurrenceTimingDuration": (device_request.occurrence as FHIR.Timing).repeat.bounds as FHIR.Duration

define "OccurrenceTimingQuantity":
  if "OccurrenceTimingDuration" is not null
  then System.Quantity { value: "OccurrenceTimingDuration".value.value, unit: "OccurrenceTimingDuration".unit.value }
  else null

define "LengthOfNeed":
  ConvertQuantity("OccurrenceTimingQuantity", 'mo').value

define "FrequencyOfUseText":
  (device_request.occurrence as FHIR.Timing).code.text.value

define "FrequencyOfUseList":
  Split("FrequencyOfUseText", ' AND ')

// filters out invalid frequencies
define "FrequencyOfUse":
  "FrequencyOfUseList" FrequencyText
    where FrequencyText in { 'During sleep', 'During exertion', 'At rest and awake' }

define "BloodGasOrderedAndEvaluated": "ArterialOxygenSaturation" is not null or "ArterialPartialPressureOfOxygen" is not null or "ArterialOxygenSaturationExercise" is not null

define "BloodTestObservations": "VerifiedArterialOxygenSatuation" union "VerifiedArterialPartialPressureOfOxygen" union "VerifiedArterialOxygenSaturationExercise"
/// Find the observation date for the blood gas test
define "BloodGasTestDate": ObservationLatestDate("BloodTestObservations")
define function ObservationLatestDate(ObsList List<Observation>):
  Max(ObsList O return FHIRHelpers."ToDateTime"(O.issued))

////////////////////////////// Taken from CDS Connect Commons for FHIR, could replace with stu3 version of helper library
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

define function HighestObservation(ObsList List<Observation>):
  Max(ObsList O return NullSafeToQuantity(cast O.value as Quantity))

define function Confirmed(CondList List<Condition>):
  CondList C where C.verificationStatus.coding.code = 'confirmed'

define function NullSafeToQuantity(Qty FHIR.Quantity):
  if Qty is not null then
    System.Quantity {
      value: Qty.value.value,
      unit: Coalesce(Qty.unit.value, Qty.code.value)
    }
  else null

define function LowestObservation(ObsList List<Observation>):
  Min(ObsList O return NullSafeToQuantity(cast O.value as Quantity))

