# CQL Cookbook
## Overview
As described in [Ruleset Development 101](https://confluence.mitre.org/pages/editpage.action?pageId=200598742) *(this will eventually have to have a different public link)*, DRLS invovles the prepopulation of clinical questionnaires from a patient's electronic health record (EHR). This prepopulation is done by means of a clinical quality language (CQL) file that fethches FHIR resources form the EHR.

### Contents
Every ruleset within the CDS-Library repo will contain at least one CQL prepopulation file. These CQL files tend to follow the same generic format. The instructions below will provide:
A) A generic template to set up your DRLS prepopulation file.
B) A list of frequently used functions that can be copied and used within your respective prepopulation file. 
C) An example of a prepopulation DRLS file.

## A) CQL Template
The structure of your CQL prepopulation file will generally follow the format below:

*Notes:
  - Most of the information from this section is described in futher detail within HL7's [CQL Authoring Guide](https://cql.hl7.org/02-authorsguide.html).
  - The code exerpts below are taken from the [Home Oxygen Therapy Prepopulation file](https://github.com/HL7-DaVinci/CDS-Library/tree/Shared_CQL_Library/HomeOxygenTherapy).*

### 1) Header
Name library, define FHIR version, and include any helper libraries
```
library *myLibraryNamePrepopulation-* version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
```
Note: myLibraryNamePrepopulation should match CQL filename (without the version number).

### 2) Codesystems
Define the codesystems that will be used within the patient's FHIR resources
```
// CODE SYSTEMS
codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
codesystem "FHIRRequestIntent": 'http://hl7.org/fhir/request-intent'
```
Note: Above are frequently used codesystems for Conditions, Observations, and Procedures.

### 3) Valuesets
Define coding valuesets that can be called upon later in the module.
```
// VALUE SETS
valueset "Home Oxygen Therapy Qualifying Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.25'
valueset "Stationary Oxygen Therapy Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.80'
```
Note: Value Set Object Identifier Codes (OIDs) can be found through the [Value Set Authority Center (VSAC)](https://vsac.nlm.nih.gov/authoring).

### 3) 

