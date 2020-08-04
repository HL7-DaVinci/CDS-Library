# CQL Cookbook
## Overview
As described in [Ruleset Development 101] (https://confluence.mitre.org/pages/editpage.action?pageId=200598742) (this will eventually have to have a different public link), DRLS invovles the prepopulation of clinical questionnaires from a patient's electronic health record (EHR). This prepopulation is done by means of a clinical quality language (CQL) file that fethches FHIR resources form the EHR.

## Contents
Every ruleset within the CDS-Library repo will contain at least one CQL prepopulation file. These CQL files tend to follow the same generic format. The instructions below will provide:
1) A generic template to set up your DRLS prepopulation file.
2) A list of frequently used functions that can be copied and used within your respective prepopulation file. 
3) An example of a prepopulation DRLS file.

