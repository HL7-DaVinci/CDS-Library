library HomeBloodGlucoseMonitorLabPrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

// 	Code system definition
codesystem "LOINC": 'http://loinc.org'

// Fasting Plasma Glucose Code taken from LOINC
code "1558-6": '1558-6' from "LOINC"

parameter device_request DeviceRequest

// Set LOINC code to var
define "Fasting_Plasma_Glucose_Codes": { "1558-6" }

context Patient

// define "TestVar": 'Hello world'

// Get fasting plasma glucose level
define "Fasting_Plasma_Glucose_Quantity": FHIRHelpers.ToQuantity((First([Observation: "Fasting_Plasma_Glucose_Codes"]).value as Quantity))

define "Fasting_Plasma_Glucose_Level": "Fasting_Plasma_Glucose_Quantity".value

define "Fasting_Plasma_Glucose_Unit": "Fasting_Plasma_Glucose_Quantity".unit

// Get Random plasma glucose level

// Get two-hour oral glucose tolerance test results

// Get A1c level







/*
define "Has Most Recent Elevated Hba1c":
	Last(["Laboratory Test, Performed": "HbA1c Laboratory Test"] HbA1c
			where HbA1c.relevantPeriod during "Measurement Period"
				and HbA1c.result is not null
			sort by resultDatetime
	).result > 9 '%'
*/

/*
define "InitialFastingPlasmaGlucose": 
	Last("Observation").issued
*/
 // Get all observations for patient

 // Filter out obersation using LOINC code

 define function GetVal(ObsList List<Observation>):
  ObsList O return cast O.value as Quantity