library HomeOxygenTherapyPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

// This cql and questionnaire combo can be considered a partial implementation of these forms:
// https://www.cms.gov/Medicare/CMS-Forms/CMS-Forms/Downloads/CMS484.pdf
// https://www.cms.gov/Research-Statistics-Data-and-Systems/Computer-Data-and-Systems/Electronic-Clinical-Templates/Downloads/Home-Oxygen-Therapy-Order-Template-Draft-20170905-R40.pdf
// with guidance from https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-ICN908804.pdf

// CODE SYSTEMS
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
codesystem "FHIRRequestIntent": 'http://hl7.org/fhir/request-intent'

// VALUE SETS

// Qualifying Conditions
valueset "Home Oxygen Therapy Qualifying Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.25'

// Device Categories
valueset "Stationary Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.80'
valueset "Portable Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.79'

// Device Types
valueset "Liquid Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.77'
valueset "Compressed Gas Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.74'
valueset "Oxygen Concentrator Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.78'

// Immobilization Codes
valueset "Immobilization": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.17.4077.3.2006'

// Oxygen Saturation Lab Test
valueset "Oxygen Saturation Lab Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.132'

// OBSERVATION LOINC CODES

// Arterial Oxygen Codes
code "Oxygen saturation in Arterial blood by Pulse oximetry": '59408-5' from "LOINC"
code "Oxygen [Partial pressure] in Arterial blood": '2703-7' from "LOINC"
code "Oxygen saturation in Arterial blood by Pulse oximetry --W exercise": '89276-0' from "LOINC"
//Note: cant find loinc code for partial pressure during exercise

// Hematocrit Code
code "Hematocrit [Volume Fraction] of Arterial blood": '32354-3' from "LOINC"

// Blood Pressure Code
code "Pulmonary artery Mean blood pressure": '8414-5' from "LOINC"


// DEVICE REQUEST //
parameter device_request DeviceRequest

// OBSERVATION CODE DEFINITIONS

// Arterial Oxygen Code Definitions
define "Arterial_oxygen_saturation_Codes": { "Oxygen saturation in Arterial blood by Pulse oximetry" }
define "Arterial_partial_pressure_of_oxygen_Codes": { "Oxygen [Partial pressure] in Arterial blood" }
define "Arterial_oxygen_saturation_during_exercise_Codes": { "Oxygen saturation in Arterial blood by Pulse oximetry --W exercise" }

// Hematocrit Code Definition
define "Hematocrit_lab_test_Codes": {"Hematocrit [Volume Fraction] of Arterial blood"}

// Blood Pressure Code Definition
define "Pulmonary_artery_pressure_Codes": {"Pulmonary artery Mean blood pressure"}


// PATIENT //
context Patient

define Today: Today()

// COVERAGE REQUIREMENTS

// Relevant Diagnoses Definition
define "RelevantConditions": [Condition: "Home Oxygen Therapy Qualifying Conditions"]
define RelevantDiagnoses: 
  CodesFromConditions(Confirmed(ActiveOrRecurring("RelevantConditions")))

define OtherDiagnoses: CodesFromConditions(Confirmed(ActiveOrRecurring([Condition] except "RelevantConditions")))
// Codes From Condition Helper Function - Used to display relevant diagnoses
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

// Arterial Oxygen Saturation - Definitions to display most recent observation on patient health record
define "VerifiedArterialOxygenSatuation": Verified(ObservationLookBack([Observation: "Arterial_oxygen_saturation_Codes"], 3 months))
define ArterialOxygenSaturation: LowestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Arterial_oxygen_saturation_Codes"], 3 months)), '%'))
define "VerifiedArterialPartialPressureOfOxygen": Verified(ObservationLookBack([Observation: "Arterial_partial_pressure_of_oxygen_Codes"], 3 months))
define ArterialPartialPressureOfOxygen: LowestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Arterial_partial_pressure_of_oxygen_Codes"], 3 months)), 'mm[Hg]'))
define "VerifiedArterialOxygenSaturationExercise": Verified(ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months))
define ArterialOxygenSaturationExercise: LowestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months)), '%'))

// Mobile Patient
define PatientMobile: not exists(Confirmed(ActiveOrRecurring([Condition: "Immobilization"])))

// High Hematocrit
define HematocritThatIsGreaterThanThreshold: HighestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Hematocrit_lab_test_Codes"], 3 months)), '%'))
define PatientHasHematocritThatIsGreaterThanThreshold: exists("HematocritThatIsGreaterThanThreshold")

// FACE TO FACE ENCOUNTER

// Oxygen Saturation Exercise
define "OxygenSatExercise": ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months)
define "OxygenSatExerciseDate": ObservationLatestDate("OxygenSatExercise")
define "IsArterialOxygenSaturationExerciseTested": "ArterialOxygenSaturationExercise" is not null

// High Blood Pressure
define "PulmonaryArteryPressure": HighestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Pulmonary_artery_pressure_Codes"], 3 months)), 'mm[Hg]'))


// DEVICE REQUEST INFO

// Get Device Coding
define DeviceRequestHcpcsCoding: singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
    return FHIRHelpers."ToCode"(coding))

// Device Categories
define DeviceRequestDescription: 'HCPCS ' + "DeviceRequestHcpcsCoding".code + ' - ' + Coalesce("DeviceRequestHcpcsCoding".display)
define DeviceRequestedIsPortable: "DeviceRequestHcpcsCoding" in "Portable Oxygen Therapy Device"
define DeviceRequestedIsStationary: "DeviceRequestHcpcsCoding" in "Stationary Oxygen Therapy Device"

// Device Type
define "DeviceType":
  if DeviceRequestHcpcsCoding in "Compressed Gas Oxygen Therapy Device"
    then 'Compressed Gas'
  else if DeviceRequestHcpcsCoding in "Liquid Oxygen Therapy Device"
    then 'Liquid'
  else if DeviceRequestHcpcsCoding in "Oxygen Concentrator Therapy Device"
    then 'Concentrator'
  else
    null

// Order Intent
define "DeviceOrderType": device_request.intent.value 

// Prescribed Use Duration Bounds
define "OccurrenceTimingDuration": (device_request.occurrence as FHIR.Timing).repeat.bounds as FHIR.Duration

// Get Length of Prescribed Use Duration
define "OccurrenceTimingQuantity":
  if "OccurrenceTimingDuration" is not null
  then System.Quantity { value: "OccurrenceTimingDuration".value.value, unit: "OccurrenceTimingDuration".unit.value }
  else null

// Convert Length of Prescribed USe Duration
define "LengthOfNeed":
  ConvertQuantity("OccurrenceTimingQuantity", 'mo').value

// Get Frequency of Use 
define "FrequencyOfUseText":
  (device_request.occurrence as FHIR.Timing).code.text.value

// Split 'AND' Conjunction into a List 
define "FrequencyOfUseList":
  Split("FrequencyOfUseText", ' AND ')

// Filters out Invalid Frequencies
define "FrequencyOfUse":
  "FrequencyOfUseList" FrequencyText
    where FrequencyText in { 'During sleep', 'During exertion', 'At rest and awake' }

// Check for Arterial Oxygen Tests
define "BloodGasOrderedAndEvaluated": "ArterialOxygenSaturation" is not null or "ArterialPartialPressureOfOxygen" is not null or "ArterialOxygenSaturationExercise" is not null

// Check for Blood Test Observation
define "BloodTestObservations": "VerifiedArterialOxygenSatuation" union "VerifiedArterialPartialPressureOfOxygen" union "VerifiedArterialOxygenSaturationExercise"

/// Find the observation date for the blood gas test
define "BloodGasTestDate": ObservationLatestDate("BloodTestObservations")

// Helper function to find most recent observation from a list
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
