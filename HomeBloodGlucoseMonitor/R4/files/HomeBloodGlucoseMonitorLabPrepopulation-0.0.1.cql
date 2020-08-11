library HomeBloodGlucoseMonitorLabPrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

// 	Code system definition
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'

// Value set definitions
valueset "Diabetes Mellitus Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.35'

// Individual code definitions
code "Fasting Plasma Glucose Lab": '14771-0' from "LOINC"
code "Random Plasma Glucose Lab": '34059-6' from "LOINC"
code "Two-hour Glucose Tolerance Lab": '72171-2' from "LOINC" 
code "A1c Lab": '41995-2' from "LOINC"

parameter device_request DeviceRequest

context Patient

// Check for qualifying diagnosis (Diabetes Mellitus)
define RelevantDiagnoses: {
	if exists(Confirmed(ActiveOrRecurring([Condition: "Diabetes Mellitus Disorder"]))) then 'Diabetes confirmed' else null
} except { null }

/*
 * *****************************************************************************
 * Lab information *************************************************************
 * *****************************************************************************
 */
// define "Laboratory": 'Quest Diagnostics'
define "Lab_Tech_NPI": '7852907749'
define "Lab_Tech_Name": 'John S Doe'



define "Plasma Lab":
  First([Observation: "Fasting Plasma Glucose Lab"]).performer

define "Tester":
  if exists("Plasma Lab") then 
    "Plasma Lab" P
    where P.type = 'Practitioner'
    return P.display.value
  else
    null  
define "TestLaboratory":
  if exists("Plasma Lab") then 
    "Plasma Lab" P
    where P.type = 'Organization'
    return P.display.value
  else
    null  

/*
define "Laboratory_Performer":
  singleton from ("Plasma Lab".performer P
    where StartsWith(FHIRHelpers.ToString(P.reference), 'Practitioner')
    return FHIRHelpers.ToString(P.display))

define "Laboratory_Org":
  Last("Plasma Lab".organization O
    where StartsWith(FHIRHelpers.ToString(O.reference), 'Organization')
    return FHIRHelpers.ToString(O.display))
    */

/*
 * *****************************************************************************
 * Initial test data ***********************************************************
 * *****************************************************************************
 */

// Get date of initial test
define "Fasting_Plasma_Glucose_Date": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers."ToDateTime"((First([Observation: "Fasting Plasma Glucose Lab"]).issued))
} except { null }


// Get initial fasting plasma glucose level
define "Fasting_Plasma_Glucose_Level": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers.ToQuantity((First([Observation: "Fasting Plasma Glucose Lab"]).value as Quantity)).value
} except { null }

// define "Fasting_Plasma_Glucose_Unit": "Fasting_Plasma_Glucose_Quantity".unit

// Get initial random plasma glucose level
define "Random_Plasma_Glucose_Level": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers.ToQuantity((First([Observation: "Random Plasma Glucose Lab"]).value as Quantity)).value
} except { null }

// Get initial two-hour oral glucose tolerance test results
define "Two_hour_Glucose_Tolerance_Level": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers.ToQuantity((First([Observation: "Two-hour Glucose Tolerance Lab"]).value as Quantity)).value
} except { null }

// Get initial A1c level 
define "A1c_Level": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers.ToQuantity((First([Observation: "A1c Lab"]).value as Quantity)).value
} except { null }

/*
 * *****************************************************************************
 * Confirmatory test data ******************************************************
 * *****************************************************************************
 */

// Get date of confirmatory test
define "Confirmed_Fasting_Plasma_Glucose_Date": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers."ToDateTime"((Last([Observation: "Fasting Plasma Glucose Lab"]).issued))
} except { null }

// Get confirmatory fasting plasma glucose level
define "Confirmed_Fasting_Plasma_Glucose_Level": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers.ToQuantity((Last([Observation: "Fasting Plasma Glucose Lab"]).value as Quantity)).value
} except { null }

// define "Fasting_Plasma_Glucose_Unit": "Fasting_Plasma_Glucose_Quantity".unit

// Get confirmatory random plasma glucose level
define "Confirmed_Random_Plasma_Glucose_Level": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers.ToQuantity((Last([Observation: "Random Plasma Glucose Lab"]).value as Quantity)).value
} except { null }

// Get confirmatory two-hour oral glucose tolerance test results
define "Confirmed_Two_hour_Glucose_Tolerance_Level": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers.ToQuantity((Last([Observation: "Two-hour Glucose Tolerance Lab"]).value as Quantity)).value
} except { null }

// Get confirmatory A1c level 
define "Confirmed_A1c_Level": {
  if exists("RelevantDiagnoses") then null else FHIRHelpers.ToQuantity((Last([Observation: "A1c Lab"]).value as Quantity)).value
} except { null }

// Helpers
define function ActiveOrRecurring(CondList List<Condition>):
  CondList C where C.clinicalStatus.coding.code in {'active', 'relapse'}

define function Confirmed(CondList List<Condition>):
  CondList C where C.verificationStatus.coding.code = 'confirmed'