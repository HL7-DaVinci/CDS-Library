# The Ultimate Guide to developing a DRLS Ruleset

> If you'd like to get started **right away**, skip the overview and go straight to our [step by step guide](##step-by-step-guide).

## Why develop a ruleset?

Our ruleset development is driven by **dire needs** in our current heathcare system:
1. Automate onerous tasks to increase efficiency of care delivery
2. Reduce provider burden
3. Improve patient outcomes 

### Who are the facilitators of this technology?

The **Centers for Medicare and Medicaid Services (CMS)** and Center for Program Integrity (CPI) are bringing together a world-class group of engineers, dedicated providers, and passionate government advocates to develop technology to will **eliminate inefficiencies** in our health care system through automated ways of requesting coverage requirements for Clinical Data Elements (CDEs) such as Durable Medical Equipment (DME), services and drug topics. The alleviation of burden on our current paper-based healthcare system will **save lives.** 

### What will you find in this guide?

This guide will give developers and other stakeholders a concise step-by-step set of instructions to **rapidly develop** a ruleset. This guide is optimized for **speed** as we **must act quickly.** Patients and providers are **counting on us.**

## Step by step guide

### Prerequisites

Make sure you have the DRLS system up and running.

### Step 1: Getting a lay of the land

What will you find in this repository?
- Ruleset topics 
    * Each *topic* refers to a **Clinical Data Element (CDE)** such as a Durable Medical Equipment (DME), service, or drug topic. 
    * **E.g. HomeBloodGlucoseMonitor, HomeHealthServices, HomeOxygenTherapy, etc.**
    * You can choose to add to an existing topic or add your own!
- CQL Cookbook
    * **Are you new to CQL?** If so, then the cookbook will be essential for learning the **Clinical Quality Language (CQL)**. It provides a set of boilerplate "functions" that you can easily tweak/customize to fit your needs. We firmly believe that one of the **best ways to learn how to code** is through example "generic" functions/code that you can play around with and adapt. If you agree with this **developer-centric philosophy**, then the **CQL Cookbook will be your new best friend.**
- Shared
    * This is a folder that contains a **library of common functions** that the scripted components of rulesets will often need. To **preclude you from having to "re-invent the wheel"** over-and-over again, we have created this comprehensive library to make your life a lot easier!
- README.md
    * This will give you more info about our "example" rulesets and how these rulesets work within the DRLS system as a whole.  

> As you move forward, keep in mind that rulesets are complex, so we understand that this codebase might be a little overwhelming. Thus, this document is designed to guide you through the *entire* process of ruleset development, as we understand there is no room for confusion as you develop this mission-critical technology. Also, please feel free to ping us with any questions!

### Step 2: Locate the paper-based template

> This development guide doesn't make many assumptions. We're big on reducing provider burden, and we understand that it is equally important to minimize burdens on developers whenever possible. That said, we *do assume* that you **already have a paper-based template** (can be a Word doc, PDF, actual paper copy, etc.) that you are trying to **convert to a DRLS ruleset.** If this is not the case, you might want to consider locating one so you can follow along!

Paper-based templates are BIG documents that resemble questionnaires. In fact, 90% of a paper-based template is a questionnaire. The other 10% is a description of the template's "purpose" as well as some *rules* (no pun intended) around appropriate use cases for the template. As a developer, it is your job to worry about **translating the "meat" the template (the questionnaire) in to a ruleset.**

### Step 3: Build the JSON file

A ruleset consists of two parts:
1. A **static JSON file** (this is where most of the content of the computerized questionnaire will live).
2. A **Clinical Quality Language (CQL) script** that will be used to automatically pre-populate the computerized questionnaire (JSON file) with patient data.

### Step 4: Add your JSON questionnaire to the CRD "rule"

A **CRD "rule"** is a CQL script that will query a payer server to see if documentation is required for a particular DME, drug, or service. 

If you are building a ruleset for a CRD "rule" that **already exists**, then congratulations! Your life just got significantly easier!! As in this case, all you have to do is add **two lines of CQL to the pre-existing rule** (see the comment in the code block below for an example).

Otherwise, you will need to **create our yown rule**. It will have a format that is very similar to this (just be sure to change all the `NonEmergencyAmbulanceTransportation`-specific references to the name of your assigned **topic**).

> Be sure to follow our file naming conventions for your new CRD rule: 
> `<CapitalizedTopicName>Rule-<version>.cql`
>
> Example:
> `NonEmergencyAmbulanceTransportationRule-0.1.0.cql`

Here is the corresponding example Non-emergency Ambulance Transportation Rule:

```sql
library NonEmergencyAmbulanceTransportationRule version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

parameter Patient Patient
parameter service_request ServiceRequest

define RULE_APPLIES:
  true

define PRIORAUTH_REQUIRED:
  true 

define DOCUMENTATION_REQUIRED:
  true

define RESULT_InfoLink:
  'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNMattersArticles/Downloads/SE1514.pdf'

define RESULT_QuestionnaireOrderUri:
  'Questionnaire/NonEmergencyAmbulanceTransportation'

define RESULT_QuestionnairePARequestUri:
  'Questionnaire/NonEmergencyAmbulanceTransportationPARequest'

define RESULT_QuestionnaireProgressNoteUri:
  'Questionnaire/NonEmergencyAmbulanceTransportationProgressNote'

define RESULT_requestId:
  service_request
```

### Step 5: Test it out!

1. Be sure your DRLS system is up and running!
2. Open the crd-request-generator, http://localhost:3000/ehr-server/reqgen and fire off a request for coverage requirements for your assigned topic.
3. After a few moments, you should get back one or more CDS cards. One should have a link to your new questionnaire. Click on that click to ensure the questionnaire loads properly. If all is well, you're all set to move on to the next step!

### Step 6: Creating a CQL pre-population script

These electronic questionnaires wouldn't get very far in reducing provider burden if providers still had to manually input all of the patient data--this is where you (the FHIR developer) come in!

To help reduce provider burden, it's **your job** to write CQL to pre-populate your newly-created JSON questionnaire with patient data that will be **programmatically extracted from an Electronic Health Record (EHR) system.** 

Here are the steps to do that:
1. If a CQL-based prepopulation file for your topic already exists, we highly recommend that you just add to it instead of creating a new one. If you fall into this category, skip to Step <n>. Otherwise, create a CQL prepopulation script 

    > For the pre-population script, use the following naming convention: 
    > `<CapitalizedTopicName>Prepopulation-<version>.cql`.
    >
    > Example: 
    > `NonEmergencyAmbulanceTransportationPrepopulation-0.1.0.cql`
2. **Add your custom CQL code to pre-populate your JSON questionnaire.** If you are unsure about what data can/cannot be pre-populated, take a look at the FHIR resources in your test EHR to get an idea about what kinds of information can be extracted about a Patient, Practioner, Condition, etc. For example, it is easy to pre-populate a "Diagnoses" field in a questionnaire with a list of a Patient's Conditions from the EHR. See CQLCookbook.md for some useful example pre-population functions.

### Step 7: Create a Library file to aggregate dependencies

1. Under `<CDS-Library>/<YourTopic>/R4/resources/`, create a Library file using the following naming convention:
`Library-R4-<CapitalizedTopicName>-prepopulation.json`
2. Now you will need to add some information to your Library file to identify your CQL, dependencies, etc. Here is an example Library file for Non-emergency Ambulance Transport:
    ```json
    {
      "resourceType": "Library",
      "id": "NonEmergencyAmbulanceTransportation-prepopulation",
      "url": "http://hl7.org/fhir/us/davinci-dtr/Library/NonEmergencyAmbulanceTransportation-prepopulation",
      "name": "NonEmergencyAmbulanceTransportation-prepopulation",
      "version": "0.0.1",
      "title": "NEAT Prepopulation",
      "status": "draft",
      "type": {
        "coding": [
          {
            "code": "logic-library"
          }
        ]
      },
      "relatedArtifact": [
        {
          "type": "depends-on",
          "resource": {
            "reference": "Library/FHIRHelpers-4.0.0"
          }
        }
      ],
      "dataRequirement": [
        {
          "type": "ServiceRequest",
          "codeFilter": [
            {
              "path": "code",
              "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.108"
            }
          ]
        },
        {
          "type": "Condition",
          "codeFilter": [
            {
              "path": "code",
              "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.188"
            }
          ]
        }
      ],  
      "content": [
        {
          "contentType": "application/elm+json",
          "url": "files/NonEmergencyAmbulanceTransportation/r4/NonEmergencyAmbulanceTransportationPrepopulation-0.1.0.cql"
        }
      ]
    } 
    ```
    Let's review what you will put for each of the fields:
    - `"resourceType"` => `"Library"`
    - `"id"`=> `"<CapitializedTopicName>-prepopulation"`
    - `"url"` => `"http://hl7.org/fhir/us/davinci-dtr/Library/<CapitializedTopicName>-prepopulation"`
    - `"name"` => Same as `id`'s value
    - `"version"` => A version number
    - `"title"` => Whatever you want
    - `"status"` => `"draft"` 
    - `"type"` => Same as example (above)
    - `"relatedArtifact"` => Array of CQL scripts that are dependencies of your pre-population script. In DRLS, this includes `FHIRHelpers-4.0.0.cql` in `Shared/R4/files/`.
    - `"dataRequirement"` => Array of identifiers (urls) of Value Sets used by your pre-population script.
    - `"content"` => An array of references to your CQL pre-population script(s). A link to your newly created pre-population script should look like this:
        ```json
        {
          "contentType": "application/elm+json",
          "url": "files/<YourCapitalizedTopic>/r4/<YourNewPrepopulationScript>"
        }
        ```

### Step 8: Link your Library file to your JSON questionnaire:

1. Locate your JSON-based questionnaire, `<Questionnaire-R4-CapitalizedTopicName>.json`.
  - Example: `Questionnaire-R4-NonEmergencyAmbulanceTransportation.json`.
2. Inside your questionnaire, add the following to the JSON. 
> This should be a "top-level" entry (i.e. on the same level as "resrouceType", "name", "id", etc.)
```json
  "extension": [
    {
      "url": "http://hl7.org/fhir/StructureDefinition/cqf-library",
      "valueCanonical": "http://hl7.org/fhir/us/davinci-dtr/Library/<ExactValueOfIDFieldInLibraryFile>"
    }
  ]
```
Example (for Non-emergency Ambulance Transportation):
```json
  "extension": [
    {
      "url": "http://hl7.org/fhir/StructureDefinition/cqf-library",
      "valueCanonical": "http://hl7.org/fhir/us/davinci-dtr/Library/NonEmergencyAmbulanceTransportation-prepopulation"
    }
  ]
```



## Appendix

FHIR
Topic

1. Coverage Requirement Discovery (CRD) rules
2. Documents Templates and Rules (DTR) rules
        For example, the DTR ruleset might include the Order, Face-To-Face Encounter, and Lab questionnaire forms and CQL scripts to pre-populate those questionnaires. 
