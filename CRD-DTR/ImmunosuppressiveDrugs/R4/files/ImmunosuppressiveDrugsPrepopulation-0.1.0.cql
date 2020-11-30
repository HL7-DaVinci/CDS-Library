library ImmunosuppressiveDrugsPrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called CDS
include DTRHelpers version '0.1.0' called DTR

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "OrganTransplantHistoryValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.81'
valueset "OrganTransplantProcedureValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.90'
valueset "ImmunosuppressiveMedicationValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.192'
valueset "ImmunosuppressiveSupportiveMedicationValueSet": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.193'


parameter medication_request MedicationRequest

context Patient

define "QualifyingTransplant": [Condition: "OrganTransplantHistoryValueSet"] 

define "QualifyingTransplantProcedures": [Procedure: "OrganTransplantProcedureValueSet"]

define "QualifyingTransplantCodings": DTR.CodesFromConditions("QualifyingTransplant") union DTR.CodesFromProcedures("QualifyingTransplantProcedures")

// get the first transplant date
define "TransplantDate": 
  if exists("QualifyingTransplant") then First("QualifyingTransplant").recordedDate.value
  else First("QualifyingTransplantProcedures").performed.value union First("QualifyingTransplantProcedures").performed.start.value

// Get all medication related information
define MedicationCoding: singleton from (
  (medication_request.medication.coding) CODING
    where CODING in "ImmunosuppressiveMedicationValueSet" 
    or CODING in "ImmunosuppressiveSupportiveMedicationValueSet")

define "MedicationName": MedicationCoding.display.value

define "MedicationCode" : MedicationCoding.code.value

define "MedicationDosage": medication_request.dosageInstruction[0]

define "MedicationDoseAndRate": MedicationDosage.doseAndRate[0]

define "MedicationDoseWithUnit": ToString(MedicationDoseAndRate.dose.value.value) + '' + MedicationDoseAndRate.dose.unit.value

define "MedicationRoute": MedicationDosage.route.coding[0].display.value

define "MedicationFrequency" : ToString(MedicationDosage.timing.repeat.frequency.value) + ' per ' + ToString(MedicationDosage.timing.repeat.period.value) + '' + MedicationDosage.timing.repeat.periodUnit.value

define CurrentDiagnoses:
  DTR.CodesFromConditions(CDS.Confirmed(CDS.ActiveOrRecurring([Condition]))) except QualifyingTransplant