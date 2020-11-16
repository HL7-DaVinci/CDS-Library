library HomeOxygenTherapyPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

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
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring("RelevantConditions")))

define OtherDiagnoses: DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition] except "RelevantConditions")))

// Arterial Oxygen Saturation - Definitions to display most recent observation on patient health record
define "VerifiedArterialOxygenSatuation": CDS.Verified(CDS.ObservationLookBack([Observation: "Arterial_oxygen_saturation_Codes"], 3 months))
define ArterialOxygenSaturation: DTR.LowestObservation(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Arterial_oxygen_saturation_Codes"], 3 months)), '%'))
define "VerifiedArterialPartialPressureOfOxygen": CDS.Verified(CDS.ObservationLookBack([Observation: "Arterial_partial_pressure_of_oxygen_Codes"], 3 months))
define ArterialPartialPressureOfOxygen: DTR.LowestObservation(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Arterial_partial_pressure_of_oxygen_Codes"], 3 months)), 'mm[Hg]'))
define "VerifiedArterialOxygenSaturationExercise": CDS.Verified(CDS.ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months))
define ArterialOxygenSaturationExercise: DTR.LowestObservation(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months)), '%'))

// Mobile Patient
define PatientMobile: not exists(CDS.Confirmed(CDS.ActiveOrRecurring([Condition: "Immobilization"])))

// High Hematocrit
define HematocritThatIsGreaterThanThreshold: CDS.HighestObservation(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Hematocrit_lab_test_Codes"], 3 months)), '%'))
define PatientHasHematocritThatIsGreaterThanThreshold: exists("HematocritThatIsGreaterThanThreshold")

// FACE TO FACE ENCOUNTER 
      
// Oxygen Saturation Exercise
define "OxygenSatExercise": CDS.ObservationLookBack([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months)
define "OxygenSatExerciseDate": CDS.FindDate(CDS.MostRecent("OxygenSatExercise"))
define "IsArterialOxygenSaturationExerciseTested": "ArterialOxygenSaturationExercise" is not null

// High Blood Pressure
define "PulmonaryArteryPressure": CDS.HighestObservation(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Pulmonary_artery_pressure_Codes"], 3 months)), 'mm[Hg]'))


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
define "BloodGasTestDate": CDS.FindDate(CDS.MostRecent("BloodTestObservations"))

// Test Is operator
define "TestIntegerIsOperator": "TestIsOperator"(5)
define "TestDateIsOperator": "TestIsOperator"("Today")

define function "TestIsOperator"(choice Choice<Integer, Date>):
  if choice is Integer
    then 'Parameter is Integer'
  else if choice is Date
    then 'Parameter is Date'
  else 
    'Parameter is not one of the choices'   