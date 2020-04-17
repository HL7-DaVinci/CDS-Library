Instance:   R4-VentilatorProgress
InstanceOf: http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-render
Title:      "Ventilator Progress Note Questionnaire"
* status = http://hl7.org/fhir/publication-status|4.0.1#draft "Draft"
* subjectType = http://hl7.org/fhir/resource-types|4.0.1#Patient "Patient"
* extension[0].url = "http://hl7.org/fhir/StructureDefinition/cqif-library"
* extension[0].valueReference.reference = "Library/Ventilators-prepopulation"
* extension[1].url = "http://hl7.org/fhir/StructureDefinition/cqif-library"
* extension[1].valueReference.reference = "Library/BasicPatientInfo-prepopulation"
* extension[2].url = "http://hl7.org/fhir/StructureDefinition/cqif-library"
* extension[2].valueReference.reference = "Library/BasicPractitionerInfo-prepopulation"

* item[0].linkId = "10"
* item[0].text = "Physical examination"
* item[0].type = http://hl7.org/fhir/item-type#group

* item[0].item[0].linkId = "10.1"
* item[0].item[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl"
* item[0].item[0].extension[0].valueCodeableConcept.coding[0] = http://hl7.org/fhir/questionnaire-item-control#gtable
* item[0].item[0].text = "Vital signs"
* item[0].item[0].type = http://hl7.org/fhir/item-type#group

* item[0].item[0].item[0].linkId = "10.1.1"
* item[0].item[0].item[0].code = http://loinc.org#8310-5
* item[0].item[0].item[0].text = "Temperature"
* item[0].item[0].item[0].type = http://hl7.org/fhir/item-type#string

* item[0].item[0].item[1].linkId = "10.1.2"
* item[0].item[0].item[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[0].item[0].item[1].extension[0].valueCoding = http://unitsofmeasure.org#{beats}/min
* item[0].item[0].item[1].code = http://loinc.org#8867-4
* item[0].item[0].item[1].text = "Pulse (beats/min)"
* item[0].item[0].item[1].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[0].item[2].linkId = "10.1.3"
* item[0].item[0].item[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[0].item[0].item[2].extension[0].valueCoding = http://unitsofmeasure.org#{Breaths}/min
* item[0].item[0].item[2].code = http://loinc.org#9279-1
* item[0].item[0].item[2].text = "Respiration (Breaths/min)"
* item[0].item[0].item[2].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[0].item[3].linkId = "10.1.4"
* item[0].item[0].item[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[0].item[0].item[3].extension[0].valueCoding = http://unitsofmeasure.org#mm[Hg]
* item[0].item[0].item[3].code = http://loinc.org#8480-6
* item[0].item[0].item[3].text = "BP sys (mm[Hg])"
* item[0].item[0].item[3].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[0].item[4].linkId = "10.1.5"
* item[0].item[0].item[4].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[0].item[0].item[4].extension[0].valueCoding = http://unitsofmeasure.org#mm[Hg]
* item[0].item[0].item[4].code = http://loinc.org#8462-4 "BP dias"
* item[0].item[0].item[4].text = "BP dias (mm[Hg])"
* item[0].item[0].item[4].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[0].item[5].linkId = "10.1.6"
* item[0].item[0].item[5].code = http://loinc.org#8302-2
* item[0].item[0].item[5].text = "Height"
* item[0].item[0].item[5].type = http://hl7.org/fhir/item-type#string

* item[0].item[0].item[6].linkId = "10.1.6"
* item[0].item[0].item[6].code = http://loinc.org#3141-9
* item[0].item[0].item[6].text = "Weight"
* item[0].item[0].item[6].type = http://hl7.org/fhir/item-type#string

* item[0].item[1].linkId = "10.2"
* item[0].item[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl"
* item[0].item[1].extension[0].valueCodeableConcept.coding[0] = http://hl7.org/fhir/questionnaire-item-control#gtable
* item[0].item[1].text = "O2 Related Measurements"
* item[0].item[1].type = http://hl7.org/fhir/item-type#group

* item[0].item[1].item[0].linkId = "10.2.1"
* item[0].item[1].item[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[0].item[1].item[0].extension[0].valueCoding = http://unitsofmeasure.org#%
* item[0].item[1].item[0].text = "O2 Sat RA at Rest (%)"
* item[0].item[1].item[0].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[1].item[1].linkId = "10.2.2"
* item[0].item[1].item[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[0].item[1].item[1].extension[0].valueCoding = http://unitsofmeasure.org#%
* item[0].item[1].item[1].text = "O2 Sat with supplemental O2 (%)"
* item[0].item[1].item[1].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[1].item[2].linkId = "10.2.3"
* item[0].item[1].item[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[0].item[1].item[2].extension[0].valueCoding = http://unitsofmeasure.org#L/min
* item[0].item[1].item[2].text = "Supplemental O2 (LPM)"
* item[0].item[1].item[2].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[1].item[3].linkId = "10.2.4"
* item[0].item[1].item[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
* item[0].item[1].item[3].extension[0].valueCoding = http://unitsofmeasure.org#cm
* item[0].item[1].item[3].text = "Neck circumference (cm)"
* item[0].item[1].item[3].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[1].item[4].linkId = "10.2.5"
* item[0].item[1].item[4].text = "Body mass index BMI"
* item[0].item[1].item[4].type = http://hl7.org/fhir/item-type#decimal

* item[0].item[2].linkId = "10.3"
* item[0].item[2].text = "General Appearance"
* item[0].item[2].type = http://hl7.org/fhir/item-type#text

* item[0].item[3].linkId = "10.4"
* item[0].item[3].text = "Had and Neck"
* item[0].item[3].type = http://hl7.org/fhir/item-type#text

* item[0].item[4].linkId = "10.5"
* item[0].item[4].text = "Chest/lungs"
* item[0].item[4].type = http://hl7.org/fhir/item-type#text

* item[0].item[5].linkId = "10.6"
* item[0].item[5].text = "Cardiovascular"
* item[0].item[5].type = http://hl7.org/fhir/item-type#text

* item[0].item[6].linkId = "10.7"
* item[0].item[6].text = "Abdominal"
* item[0].item[6].type = http://hl7.org/fhir/item-type#text

* item[0].item[7].linkId = "10.8"
* item[0].item[7].text = "Musculoskeletal/extremities (including gait exam)"
* item[0].item[7].type = http://hl7.org/fhir/item-type#text

* item[0].item[8].linkId = "10.9"
* item[0].item[8].text = "Neurological"
* item[0].item[8].type = http://hl7.org/fhir/item-type#text

* item[0].item[9].linkId = "10.10"
* item[0].item[9].text = "Psychiatric"
* item[0].item[9].type = http://hl7.org/fhir/item-type#text

* item[0].item[10].linkId = "10.11"
* item[0].item[10].text = "Visual"
* item[0].item[10].type = http://hl7.org/fhir/item-type#text

* item[0].item[11].linkId = "10.12"
* item[0].item[11].text = "Test Results (e.g. pulmonary function, pulse oximetry)"
* item[0].item[11].type = http://hl7.org/fhir/item-type#text

* item[0].item[12].linkId = "10.13"
* item[0].item[12].text = "Other"
* item[0].item[12].type = http://hl7.org/fhir/item-type#text

* item[1].linkId = "11"
* item[1].text = "Assessment and Plan"
* item[1].type = http://hl7.org/fhir/item-type#group

* item[1].item[0].linkId = "11.1"
* item[1].item[0].text = "Assessment/Status"
* item[1].item[0].type = http://hl7.org/fhir/item-type#text

* item[1].item[1].linkId = "11.2"
* item[1].item[1].text = "Treatment Plan"
* item[1].item[1].type = http://hl7.org/fhir/item-type#text

* item[1].item[2].linkId = "11.3"
* item[1].item[2].text = "Orders"
* item[1].item[2].type = http://hl7.org/fhir/item-type#group

* item[1].item[2].item[0].linkId = "11.3.1"
* item[1].item[2].item[0].text = "Medications"
* item[1].item[2].item[0].type = http://hl7.org/fhir/item-type#text

* item[1].item[2].item[1].linkId = "11.3.2"
* item[1].item[2].item[1].text = "Supplies"
* item[1].item[2].item[1].type = http://hl7.org/fhir/item-type#text

* item[1].item[2].item[2].linkId = "11.3.3"
* item[1].item[2].item[2].text = " Investigations / diagnostic testing"
* item[1].item[2].item[2].type = http://hl7.org/fhir/item-type#text

* item[1].item[2].item[3].linkId = "11.3.4"
* item[1].item[2].item[3].text = "Consults"
* item[1].item[2].item[3].type = http://hl7.org/fhir/item-type#text

* item[1].item[2].item[4].linkId = "11.3.5"
* item[1].item[2].item[4].text = "Other"
* item[1].item[2].item[4].type = http://hl7.org/fhir/item-type#text

* item[2].linkId = "12"
* item[2].text = "Provider Signature"
* item[2].type = http://hl7.org/fhir/item-type#group

* item[2].item[0].linkId = "12.1"
* item[2].item[0].text = "Signature"
* item[2].item[0].type = http://hl7.org/fhir/item-type#string
* item[2].item[0].required = true

* item[2].item[1].linkId = "12.2"
* item[2].item[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/cqf-expression"
* item[2].item[1].extension[0].valueExpression.language = http://hl7.org/fhir/expression-language#text/cql
* item[2].item[1].extension[0].valueExpression.expression = "\"BasicPractitionerInfoPrepopulation\".FullName"
* item[2].item[1].text = "Name (Printed)"
* item[2].item[1].type = http://hl7.org/fhir/item-type#string
* item[2].item[1].required = true

* item[2].item[2].linkId = "12.3"
* item[2].item[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/cqf-expression"
* item[2].item[2].extension[0].valueExpression.language = http://hl7.org/fhir/expression-language#text/cql
* item[2].item[2].extension[0].valueExpression.expression = "\"BasicPractitionerInfoPrepopulation\".Today"
* item[2].item[2].text = "Date"
* item[2].item[2].type = http://hl7.org/fhir/item-type#date
* item[2].item[2].required = true

* item[2].item[3].linkId = "12.4"
* item[2].item[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/cqf-expression"
* item[2].item[3].extension[0].valueExpression.language = http://hl7.org/fhir/expression-language#text/cql
* item[2].item[3].extension[0].valueExpression.expression = "\"BasicPractitionerInfoPrepopulation\".NPI"
* item[2].item[3].text = "NPI"
* item[2].item[3].type = http://hl7.org/fhir/item-type#string
* item[2].item[3].required = true