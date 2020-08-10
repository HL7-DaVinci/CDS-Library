# CQL Cookbook
## Overview
As described in [Ruleset Development 101](https://confluence.mitre.org/pages/editpage.action?pageId=200598742) *(this will eventually have to have a different public link)*, DRLS invovles the prepopulation of clinical questionnaires from a patient's electronic health record (EHR). This prepopulation is done by means of a clinical quality language (CQL) file that fethches FHIR resources form the EHR.

### Contents
Every ruleset within the CDS-Library repo will contain at least one CQL prepopulation file. These CQL files tend to follow the same generic format. The instructions below will provide:
1. A generic template to set up your DRLS prepopulation file.
2. A list of frequently used functions that can be copied and used within your respective prepopulation file. 
3. An example of a prepopulation DRLS file.


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
Define a paramter which can be referenced anywhere in the CQL Libray.
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


## 2) DRLS-Specific Functions
The functions below are all used in many currently existing DRLS propopulation files. Feel free to copy them and make small adjustments so that they may match the needs of any given ruleset

- 
- 
- 
- 
- 


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

