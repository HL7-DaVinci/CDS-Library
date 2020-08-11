# CQL Cookbook
Reference for creating a CQL prepopulation file for a DRLS Ruleset.


## Overview
As described in [Ruleset Development 101](https://confluence.mitre.org/pages/editpage.action?pageId=200598742) *(this will eventually have to have a different public link)*, DRLS invovles the prepopulation of clinical questionnaires from a patient's electronic health record (EHR). This prepopulation is done by means of a clinical quality language (CQL) file that fethches FHIR resources form the EHR.

## Contents
Every ruleset within the CDS-Library repo will contain at least one CQL prepopulation file. These CQL files tend to follow the same generic format. The instructions below will provide:
1. [CQL Template](#1-cql-template): A generic template to set up your DRLS prepopulation file.
   - A) Header
   - B) Codesystems
   - C) Valusets
   - D) Codes
   - E) Request Parameter
   - F) Patient Context
   - G) Define Statement
2. [DRLS-Specific Statements](#2-drls-specific-statements): A list of frequently used functions that can be copied and used within your respective prepopulation file. 
3. [Example Prepopulation.cql file](#3-example-prepopulationcql-file) An example of a prepopulation DRLS file.
4. [Links and Other Resources](#4-links-and-other-resources)

***

## 1) CQL Template
The structure of your CQL prepopulation file will generally follow the format below:

*Notes:
  - Most of the information from this section is described in futher detail within HL7's [CQL Authoring Guide](https://cql.hl7.org/02-authorsguide.html).
  - The code exerpts below are taken from the [Home Oxygen Therapy Prepopulation file](https://github.com/HL7-DaVinci/CDS-Library/tree/Shared_CQL_Library/HomeOxygenTherapy).*

### A) Header
Name library, define FHIR version, and include any helper libraries.
```sql
library HomeOxygenTherapyPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
```
Note: Library name should match CQL filename (without the version number).

### B) Codesystems
Define the codesystems that will be used within the patient's FHIR resources.
```sql
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
codesystem "FHIRRequestIntent": 'http://hl7.org/fhir/request-intent'
```
Note: Above are frequently used codesystems for Conditions, Observations, and Procedures.

### C) Valuesets
Define coding valuesets that can be called upon later in the library.
```sql
valueset "Home Oxygen Therapy Qualifying Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.25'
valueset "Stationary Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.80'
```
Note: Value Set Object Identifier Codes (OIDs) can be found through the [Value Set Authority Center (VSAC)](https://vsac.nlm.nih.gov/authoring).

### D) Codes
Define codes from codesystems (defined above) that can be called upon later in the library.
```sql
code "Hematocrit [Volume Fraction] of Arterial blood": '32354-3' from "LOINC"
```

### E) Request Parameter
Define a parameter which can be referenced anywhere in the CQL Libray.
```sql
parameter device_request DeviceRequest
```
Note: DRLS typically uses DeviceRequest and ServiceRequest as common parameters.

### F) Patient Context
Specify that the statements below this should be interpreted with reference to a single patient.
```sql
context Patient
```

### G) Define Statement
The basic unit of logic within a library, a define statement introduces a named expression that can be referenced within tbe library, or by other libraries.
This can operate like a variable of like a function
```sql
define RelevantDiagnoses: 
  CodesFromConditions(Confirmed(ActiveOrRecurring([Condition: "Home Oxygen Therapy Qualifying Conditions"])))
  
define function HighestObservation(ObsList List<Observation>):
  Max(ObsList O return NullSafeToQuantity(cast O.value as Quantity))
```
Note: See Part 2 below for a list CQL define statements that are commonly used within DRLS.

***

## 2) DRLS-Specific Statements

[Define statements](#g-define-statement) in CQL can be used to query specific information. Since most statements in DRLS prepopulation files come under the the `context Patient` declaration, these statements are typically used to pull specific information from a patient's electronic health record (EHR). Declaration statements

### *Headers*
#### 'Variable' Statements
Define statements in CQL begin with the header:
```sql
define myStatement:
//  Describe logic here
```
The header is succeeded by a flow of logical arguments that describe which specific information to pull from the patient's EHR. These type of statements can be called upon by other statemetents in the library, in order to filter out more specific patient information.

#### 'Function' Statements
Sometimes the logic defined in a CQL statement can either:
1) Be quite complex
2) Need to be reused in multiple 'define' statements throughout the CQL library
In this case, it is typically advantageous to define a CQL function statement. Formatted very similarly to normal 'Define' statements, function statements have the following header:
```sql
define function myFunction(parameter1 parameter1_type, parameter2 parameter2_type, ...)
//  Describe logic here
```
*Note: function headers do not necesarily need to contain parameters.*

The header is again succeeded by a flow of logical arguments. These arguments can then be accessed by simply calling the function elsewhere in the CQL Library.


### *DRLS Statement Templates*
The statements below are all used in many currently existing DRLS propopulation files. They are generic templates instructing how to extract elements from a patient's EHR so that they can be used to prepopulate a FHIR questionnaire. Feel free to copy them and make small adjustments so that they may match the needs of any given ruleset. 

Each statement will include:
1. A short description describing the context when the statement would be used
2. A generic CQL snipped of the statement along with dependant helper functions. These can be copied and modified slightly in order to accomodate the needs of a new CQL prepopulation file
3. A list of variables that should be changed in order to tailor the CQL statement to a specific need (ex. a specific valueset, condition, observation, etc.)
4. An example from CDS-Libray where this type of code is implemented

### Casting
- Extract a CodeableConcept as a Code
- Convert a FHIR Resource Timestamp into a FHIR Date Type

### Basic Queries
#### List of All of a Patient's Conditions
#### Extract a Numeric Value of an Observation
#### Extract the date of an Observation
Find the most recent date that an Observation from a value set or from a list of codes occured. This is typically useful for pulling lab information.
```sql
// Find recent Observation in health record
define "RecentObservation": ObservationLookBack([Observation: "Observation_Codes_Or_Valueset"], time_interval)

// Extract date of Observation
define "ReentObservationDate": ObservationLatestDate("RecentObservation")


// Helper Functions

// Look for any instances from a list of observations over a recent time interval
define function ObservationLookBack(ObsList List<Observation>, LookBack System.Quantity):
  ObsList O
    let LookBackInterval: Interval[Now() - LookBack, Now()]
    where (cast O.effective as dateTime).value in LookBackInterval
      or NullSafeToInterval(cast O.effective as Period) overlaps LookBackInterval
      or FHIRHelpers."ToDateTime"(O.issued) in LookBackInterval
    
define function NullSafeToInterval(Pd FHIR.Period):
  if Pd is not null then Interval[Pd."start".value, Pd."end".value] else null

// Helper function to find most recent observation from a list
define function ObservationLatestDate(ObsList List<Observation>):
  Max(ObsList O return FHIRHelpers."ToDateTime"(O.issued))
```
Variables:
- *Observation_Codes_Or_Valueset:* Replace with the name of a valueset of observations or a defined group of codes that has been established in a previoud define statement.
- *time_interval:* How far back from today you want to look in the patient's EHR for the observation.

Example Implementation: `HomeOxygenTherapyPrepopulation-0.1.0.cql`

### Advanced Queries
#### List of All Active Conditions
#### List of All Relevant Conditions (as specified by a partiular value set)
Return a list of all active patient conditions that are relevant to a specific device or service request (the specific list of conditions is defined by the value set)
```sql
define RelevantDiagnoses: 
  CodesFromConditions(Confirmed(ActiveOrRecurring([Condition: "My Condition Valueset"]))) 

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

```
Variables:
- *My Condition Valueset:* with a condition valueset previously defined in the library

Example Implementation: `VentilatorsPrepopulation-0.1.0.cql`

#### Highest Numerical Lab Result

```sql
define "HighestObservationResult": HighestObservation(WithUnit(Verified(ObservationLookBack([Observation: "Observation_Codes_or_Valueset"], time_interval)), 'unit'))


// Helper Functions

define function HighestObservation(ObsList List<Observation>):
  Max(ObsList O return NullSafeToQuantity(cast O.value as Quantity))
  
define function NullSafeToQuantity(Qty FHIR.Quantity):
  if Qty is not null then
    System.Quantity {
      value: Qty.value.value,
      unit: Coalesce(Qty.unit.value, Qty.code.value)
    }
  else null
```
Variables:
- *Observation_Codes_Or_Valueset:* Replace with the name of a valueset of observations or a defined group of codes that has been established in a previoud define statement.
- *time_interval:* How far back from today you want to look in the patient's EHR for the observation.
- *unit:* Unit of measurement for lab result (ex. mm[Hg], %, pH).

Example Implementation: `HomeOxygenTherapyPrepopulation-0.1.0.cql`

#### Extract a reference from a FHIR Resource
#### Display Name of a Reference

***

## 3) Example Prepopulation.cql file
Below is a full example of a ruleset prepopulation file. This file prepopulates the questionnaire for the Non Emergency Ambulance Transportation ruleset, and is stored in [CDS-Library/NonEmergencyAmbulanceTransportation/R4/files/NonEmergencyAmbulanceTransportationPrepopulation-0.1.0.cql](https://github.com/HL7-DaVinci/CDS-Library/blob/Shared_CQL_Library/NonEmergencyAmbulanceTransportation/R4/files/NonEmergencyAmbulanceTransportationPrepopulation-0.1.0.cql).
```sql
library NonEmergencyAmbulanceTransportationPrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

valueset "Ambulance Transport Procedure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.108'

parameter service_request ServiceRequest

context Patient

define "ServiceRequestHcpcsCoding": singleton from (
  ((cast service_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
    return FHIRHelpers.ToCode(coding))

define NeatServiceRequested: 
  if "ServiceRequestHcpcsCoding" in "Ambulance Transport Procedure" then "ServiceRequestHcpcsCoding".code
  else null

define "ServiceRequestReason": service_request.reasonCode[0].text.value

define "ServiceStartDate": FHIRHelpers.ToDateTime(
    Coalesce(
      service_request.occurrence as FHIR.dateTime, 
      (service_request.occurrence as FHIR.Period).start
    )
  )

define "ServiceEndDate": FHIRHelpers.ToDateTime(
    Coalesce(
      service_request.occurrence as FHIR.dateTime, 
      (service_request.occurrence as FHIR.Period).end
    )
  )
```

***

## 4) Links and Other Resources

[CQL Spec](https://cql.hl7.org/)
: This is the most up-to-date Clinical Quality Language Specification, describing the semantics of CQL. Much of the [CQL Template](#1-cql-template) information is derived from this CQL Spec.

[CDS Library](https://github.com/HL7-DaVinci/CDS-Library/)
: The GitGub repository containing the existing DRLS rulesets
