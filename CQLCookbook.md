# CQL Cookbook
Reference for creating a CQL prepopulation file for a DRLS Ruleset.


## Overview
As described in the Ruleset Development 101 document, DRLS invovles the prepopulation of clinical questionnaires from a patient's electronic health record (EHR). This prepopulation is done by means of a clinical quality language (CQL) file that fetches FHIR resources form the EHR.

## Contents
Every ruleset within the CDS-Library repo will contain at least one CQL prepopulation file. These CQL files tend to follow the same generic format. The instructions below will provide:
1. [CQL Template](#1-cql-template): A generic template to set up your DRLS prepopulation file.
   - A) Header
   - B) Codesystems
   - C) Value Sets
   - D) Codes
   - E) Request Parameter
   - F) Patient Context
   - G) Define Statement
      - "Query" Statements
      - "Function" Statements
2. [DRLS Statement Templates](#2-drls-statement-templates): A list of frequently used 'define' statements that can be copied and modified to be included within your respective prepopulation file. 
   - A) [Condition Resource Statements](#a-condition-resource-statements)
      - List of All Active Conditions
      - List of All Relevant Conditions (as specified by a partiular value set)
      - List of Patient's 'Other Diagnoses'
   - B) [Observation Resource Statements](#b-observation-resource-statements)
      - Extract a Numeric Value of an Observation
      - Extract the date of an Observation
      - Highest Numerical Lab Result
      - Extract performer field of Observation (the performer field has a value of an array with references)
3. [Example Prepopulation.cql file](#3-example-prepopulationcql-file) An example of a prepopulation DRLS file.
4. [Links and Other Resources](#4-links-and-other-resources)

***

## 1) CQL Template
The structure of your CQL prepopulation file will generally follow the format below:

*Notes:*
  - Most of the information from this section is described in futher detail within HL7's [CQL Authoring Guide](https://cql.hl7.org/02-authorsguide.html).
  - The code excerpts below are taken from the [Home Oxygen Therapy Prepopulation file](https://github.com/HL7-DaVinci/CDS-Library/blob/master/HomeOxygenTherapy/R4/files/HomeOxygenTherapyPrepopulation-0.1.0.cql).

### A) Header
Name library, define FHIR version, and include any helper libraries. 

```cql
library HomeOxygenTherapyPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR
```
*Notes:*
  - Library name should match CQL filename (without the version number).
  - These three libraries should always be included within a DRLS prepopulation file:
      - `FHIRHelpers`: Contains many useful functions to fetch data within FHIR Resources
      - `CDS_Connect_Commons`: Contains many FHIR Resource-specific helper functions
      - `DTRHelpers`: Contains DRLS-specific functions that specifically help with rendering queries to the questionnaire
  - Be sure to include any additional libraries that contain functions you use in your CQL prepopulation file.

### B) Codesystems
Define the codesystems that will be used within the patient's FHIR resources.
```cql
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
codesystem "FHIRRequestIntent": 'http://hl7.org/fhir/request-intent'
```
Note:
- Above are frequently used codesystems for Conditions, Observations, and Procedures.

### C) Value Sets
Define coding value sets that can be called upon later in the library.
```cql
valueset "Home Oxygen Therapy Qualifying Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.25'
valueset "Stationary Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.80'
```
Note:
- Value set Object Identifier Codes (OIDs) can be found through the [Value Set Authority Center (VSAC)](https://vsac.nlm.nih.gov/authoring).

### D) Codes
Define codes from codesystems (defined above) that can be called upon later in the library.
```cql
code "Hematocrit [Volume Fraction] of Arterial blood": '32354-3' from "LOINC"
```

### E) Request Parameter
Define a request parameter which can be referenced anywhere in the CQL Libray.
```cql
parameter device_request DeviceRequest
```
Note:
- DRLS typically uses DeviceRequest, ServiceRequest and MedicationRequest as common parameters.

### F) Patient Context
Specify that the statements below this should be interpreted with reference to a single patient.
```cql
context Patient
```

### G) Define Statement
The basic unit of logic within a library, a define statement introduces a named expression that can be referenced within the library, or by other libraries.
This can operate like a query or like a function:
```cql
define RelevantDiagnoses: 
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition: "Home Oxygen Therapy Qualifying Conditions"])))
```
```cql
define function HighestObservation(ObsList List<Observation>):
  Max(ObsList O return NullSafeToQuantity(cast O.value as Quantity))
```

Define statements in CQL can be used to query specific information. Since most statements in DRLS prepopulation files come under the `context Patient` declaration, these statements are typically used to pull specific information from a patient's electronic health record (EHR). Declaration statements come in two forms: queries and functions.

#### 'Query' Statements
Define statements in CQL begin with the header:
```cql
define myStatement:
//  Describe logic here
```
The header is succeeded by a flow of logical arguments that describe which specific information to pull from the patient's EHR. These type of statements can be called upon by other statemetents in the library, in order to filter out more specific patient information.

#### 'Function' Statements
Sometimes the logic defined in a CQL statement can either:
1) Be quite complex
2) Need to be reused in multiple 'define' statements throughout the CQL library

In this case, it is typically advantageous to define a CQL function statement. Formatted very similarly to normal 'Define' statements, function statements have the following header:
```cql
define function myFunction(parameter1 parameter1_type, parameter2 parameter2_type, ...)
//  Describe logic here
```
The header is again succeeded by a flow of logical arguments. These arguments can then be accessed by simply calling the function elsewhere in the CQL Library.

Most DRLS functions that are not built into the CQL Specification come from either the the [FHIRHelpers](https://github.com/HL7-DaVinci/CDS-Library/blob/master/Shared/R4/files/FHIRHelpers-4.0.0.cql), [CDS_Connect_Commons_for_FHIRv400](https://github.com/HL7-DaVinci/CDS-Library/blob/master/Shared/R4/files/CDS_Connect_Commons_for_FHIRv400-1.0.2.cql), or the [DTRHelpers](https://github.com/HL7-DaVinci/CDS-Library/blob/master/Shared/R4/files/DTRFunctions-0.1.0.cql) libraries.


Notes:
  - Function headers do not necesarily need to contain parameters.
  - When calling functions that are defined in an external library (ex. FHIRHelpers), be sure to reference the library name before the function call in the following manner: `FHIRHelpers.myFunction(parameters)`.
  - See [Part 2](#2-drls-specific-statements) below for a list CQL define statements that are commonly used within DRLS.



***

## 2) DRLS Statement Templates

The statements below are used in many currently existing DRLS prepopulation files. They are generic templates instructing how to extract elements from a patient's EHR so that they can be used to prepopulate a FHIR questionnaire. Feel free to copy them and make small adjustments so that they may match the needs of any given ruleset. 

Each statement will include:
1. A short description describing the context of when the statement would be used
2. A generic CQL snippet of the statement. These can be copied and modified slightly in order to accomodate the needs of a new CQL prepopulation file (note these snippets can reference functions from helper libraries, which are not included here).
3. A list of variables that should be changed in order to tailor the CQL statement to a specific need (ex. a specific value set, condition, observation, etc.)
4. An example from CDS-Library where this type of code is implemented


### *A) Condition Resource Statements*

### List of All Active Conditions
Return a list of all Conditions that are active or occuring from a designated value set or Condition list.
```cql
// Define list of patient Conditions from a value set
define "ActiveConditions": CDS.ActiveOrRecurring([Condition: "Condition_Value_Set"])
```
Variables:
- *Condition_Value_Set:* List of Conditions or value set that the statement will search over to check whether each Condition is active or occuring.

Example Implementation: [HomeBloodGlucoseMonitorFaceToFacePrepopulation-0.0.1.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/master/HomeBloodGlucoseMonitor/R4/files/HomeBloodGlucoseMonitorFaceToFacePrepopulation-0.0.1.cql)

### List of All Relevant Conditions (as specified by a partiular value set)
Return a list of all active patient Conditions that are relevant to a specific device, service, or medication request (the specific list of Conditions is defined by the value set)
```cql
define RelevantDiagnoses: 
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition: "My_Condition_Valueset"]))) 
```
Variables:
- *My_Condition_Valueset:* A Condition value set that was previously defined in the library. This value set should include diagnoses or conditions that are relevant to the ruleset at hand.

Example Implementation: [VentilatorsPrepopulation-0.1.0.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/master/Ventilators/R4/files/VentilatorsPrepopulation-0.1.0.cql)

### List of Patient's 'Other Diagnoses'
Looking for all of a patient's Conditions excluding the Conditions defined by a previous statement
```cql
define "OtherDiagnoses": [Condition] except "Excluding_These_Diagnoses"
```
Variables:
- *Excluding_These_Diagnoses:* A statement querying a certain group of Conditions that was previously defined in the CQL Library. These are Conditions that you don't wanted to be included in 'OtherDiagnoses'.

Example Implementation: [HomeBloodGlucoseMonitorFaceToFacePrepopulation-0.0.1.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/master/HomeBloodGlucoseMonitor/R4/files/HomeBloodGlucoseMonitorFaceToFacePrepopulation-0.0.1.cql)


### *B) Observation Resource Statements*

### Extract Numeric Value of the Latest Observation
If a list of Observation resources contains numeric values (as opposed to codes or a strings), extract the numeric value from the latest resource.
```cql
define "Latest Numeric Observation": CDS.MostRecent(CDS.WithUnit(CDS.Verified("Observation_Resource_List"), 'unit'))

define "Numeric Observation Value": DTR.GetObservationValue("Latest Numeric Observation")
```
Variables:
- *Observation_Resource_List:* A list of Observation resources that has previously been defined in the CQL library.
- *unit:* Unit of measurement for the value of the Observation being queried (ex. mm[Hg], %, pH).

Example Implementation: [RespiratoryAssistDevicesPrepopulation-0.1.0.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/master/RespiratoryAssistDevices/R4/files/RespiratoryAssistDevicesPrepopulation-0.1.0.cql)

### Extract the Date of an Observation
Find the most recent date that an Observation from a value set or from a list of codes occured. This is typically useful for pulling lab information.
```cql
// Find recent Observation in health record
define "RecentObservation": CDS.ObservationLookBack([Observation: "Observation_Codes_Or_Valueset"], time_interval)

// Extract date of Observation
define "RecentObservationDate": CDS.FindDate(CDS.MostRecent("RecentObservation"))
```
Variables:
- *Observation_Codes_Or_Valueset:* Replace with the name of a value set of Observations or a defined group of Observation codes that has been established in a previous CQL statement.
- *time_interval:* How far back from today you want to look in the patient's EHR for the Observation.

Example Implementation: [HomeOxygenTherapyPrepopulation-0.1.0.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/master/HomeOxygenTherapy/R4/files/HomeOxygenTherapyPrepopulation-0.1.0.cql)

### Highest Numerical Lab Result
From a group of lab Observation codes or a value set, extract the Observation with the highest numeric value.
```cql
define "HighestObservationResult": CDS.HighestObservation(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Observation_Codes_or_Valueset"], time_interval)), 'unit'))
```
Variables:
- *Observation_Codes_Or_Valueset:* Replace with the name of a value set of Observations or a defined group of Observation codes that has been established in a previous define statement.
- *time_interval:* How far back from today you want to look in the patient's EHR for the Observation.
- *unit:* Unit of measurement for lab result (ex. mm[Hg], %, pH).

Example Implementation: [HomeOxygenTherapyPrepopulation-0.1.0.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/master/HomeOxygenTherapy/R4/files/HomeOxygenTherapyPrepopulation-0.1.0.cql)

### Extract Performer Field Information from an Observation
The 'performer' field has a value of an array with references. Extract the display name of a reference within an Observation. Examples of this can be a reference to a Practitioner who performed the observation or the Organization where the Observation was performed.
```cql
// Retrieve the 'performer' field of the first observation in the lab.
define "Lab Performer":
  First([Observation: "My_Lab"]).performer
  
// Extract the display value of the Practitioner
define "Tester":
  if exists("Lab Performer") then 
    "Lab" P
    where P.type = 'Practitioner'
    return P.display.value
  else
    null  
    
// Extract the display value of the Organization
define "TestLaboratory":
  if exists("Lab Performer") then 
    "Lab" P
    where P.type = 'Organization'
    return P.display.value
  else
    null  
```
Variables:
- *My_Lab:* Name of a list of lab Observations or an Observation value set.

Example Implementation: [RespiratoryAssistDevicesPrepopulation-0.1.0.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/master/RespiratoryAssistDevices/R4/files/RespiratoryAssistDevicesPrepopulation-0.1.0.cql)

***

## 3) Example Prepopulation.cql file
Below is a full example of a ruleset prepopulation file. This file prepopulates the questionnaire for the Positive Airway Pressure Devices ruleset, and is stored in [https://github.com/HL7-DaVinci/CDS-Library/blob/master/PositiveAirwayPressureDevices/R4/files/PositiveAirwayPressureDevicesPrepopulation-0.1.0.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/master/PositiveAirwayPressureDevices/R4/files/PositiveAirwayPressureDevicesPrepopulation-0.1.0.cql).
```cql
library PositiveAirwayPressureDevicePrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "Sleep Apnea or Breathing Related Sleep Disorder": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.31'
valueset "Apnea Hypopnea Index Rate Measurement": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.123'
valueset "Respiratory Disturbance Index": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.133'

parameter device_request DeviceRequest

context Patient

define "False": false
// coverage requirement info
define "RelevantDiagnoses": DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition: "Sleep Apnea or Breathing Related Sleep Disorder"])))

define OtherDiagnoses:
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition]))) except "RelevantDiagnoses"

define DeviceRequestHcpcsCoding: singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define DeviceRequestDescription: 'HCPCS ' + "DeviceRequestHcpcsCoding".code.value + ' - ' + "DeviceRequestHcpcsCoding".display.value
define PapDeviceRequested:
  if "DeviceRequestHcpcsCoding".code.value = 'E0470' then 'E0470'
  else if  "DeviceRequestHcpcsCoding".code.value = 'E0601' then 'E0601'
  else 'null'

define "AHI": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Apnea Hypopnea Index Rate Measurement"], 3 months)), '/h')))
define "RDI": DTR.GetObservationValue(CDS.MostRecent(CDS.WithUnit(CDS.Verified(CDS.ObservationLookBack([Observation: "Respiratory Disturbance Index"], 3 months)), '/h')))
```

***

## 4) Links and Other Resources

[CQL Spec](https://cql.hl7.org/)
: This is the most up-to-date Clinical Quality Language Specification, describing the semantics of CQL. Much of the [CQL Template](#1-cql-template) information is derived from this CQL Spec.

[CDS Library](https://github.com/HL7-DaVinci/CDS-Library/)
: The GitHub repository containing the existing DRLS rulesets
