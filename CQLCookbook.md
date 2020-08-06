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

*Note: Most of the information from this section is described in futher detail within HL7's [CQL Authoring Guide](https://cql.hl7.org/02-authorsguide.html)

### 1) Header
```
library *myLibraryNamePrepopulation* version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
```
Note: myLibraryNamePrepopulation should match CQL filename.

### 2) C

