library HomeHealthServicesPrepopulation  version '0.1.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

// This cql and questionnaire combo can be considered a partial implementation of these forms:
//  https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Medicare-Home-Health-Benefit-Text-Only.pdf

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'

//  ICD-10 codes from here: www.bcbsm.com/content/dam/public/Providers/Documents/help/faqs/icd10-tipsheet-home-healthcare.pdf

//  Various ICD-10 codes
code "Z47.1": 'Z47.1' from "ICD-10-CM"
code "Z51.89": 'Z51.89' from "ICD-10-CM"  // Encounter for other specified aftercare
code "Z48.812": 'Z48.812' from "ICD-10-CM"  // Encounter for surgical aftercare following surgery on the circulatory system
code "S06.890A": 'S06.890A' from "ICD-10-CM"  // Other specified intracranial injury w/o loss of consciousness, initial encounter
code "998.83": '998.83' from "ICD-10-CM"  // Non-healing surgical wound
code "T81.89XA": 'T81.89XA' from "ICD-10-CM"  // Other complications of procedures, NEC, initial encounter
code "V58.42": 'V58.42' from "ICD-10-CM"  // Aftercare following surgery for neoplasm
code "Z48.3": 'Z48.3' from "ICD-10-CM"  // Aftercare following surgery for neoplasm(use additional code for neoplasm)

//  ICD-10 codes for Congestive heart failure unspecified
code "I50.20": 'I50.20' from "ICD-10-CM"  // Unspecified systolic(congestive) heart failure
code "I50.21": 'I50.21' from "ICD-10-CM"  // Acute systolic(congestive) heart failure
code "I50.22": 'I50.22' from "ICD-10-CM"  // Chronic systolic(congestive) heart failure
code "I50.23": 'I50.23' from "ICD-10-CM"  // Acute on chronic systolic(congestive) heart failure
code "I50.30": 'I50.30' from "ICD-10-CM"  // Unspecified diastolic(congestive) heart failure
code "I50.31": 'I50.31' from "ICD-10-CM"  // Acute diastolic(congestive) heart failure
code "I50.32": 'I50.32' from "ICD-10-CM"  // Chronic diastolic(congestive) heart failure
code "I50.33": 'I50.33' from "ICD-10-CM"  // Acute on chronic diastolic(congestive) heart failure
code "I50.40": 'I50.40' from "ICD-10-CM"  // Unspecified combined systolic(congestive) and diastolic(congestive) heart failure
code "I50.41": 'I50.41' from "ICD-10-CM"  // Acute combined systolic(congestive) and diastolic(congestive) heart failure
code "I50.42": 'I50.42' from "ICD-10-CM"  // Chronic combined systolic(congestive) and diastolic(congestive) heart failure
code "I50.43": 'I50.43' from "ICD-10-CM"  // Acute on chronic combined systolic(congestive) and diastolic(congestive) heart failure
code "I50.9": 'I50.9' from "ICD-10-CM"  // Heart failure, unspecified

//  ICD-10 codes for Diabetes
code "E11.618": 'E11.618' from "ICD-10-CM"  // Type 2 diabetes mellitus w/other diabetic arthropathy
code "E11.620": 'E11.620' from "ICD-10-CM"  // Type 2 diabetes mellitus w/diabetic dermatitis
code "E11.621": 'E11.621' from "ICD-10-CM"  // Type 2 diabetes mellitus w/foot ulcer
code "E11.622": 'E11.622' from "ICD-10-CM"  // Type 2 diabetes mellitus w/other skin ulcer
code "E11.628": 'E11.628' from "ICD-10-CM"  // Type 2 diabetes mellitus w/other skin complications
code "E11.630": 'E11.630' from "ICD-10-CM"  // Type 2 diabetes mellitus w/periodontal disease
code "E11.638": 'E11.638' from "ICD-10-CM"  // Type 2 diabetes mellitus w/other oral complications
code "E11.649": 'E11.649' from "ICD-10-CM"  // Type 2 diabetes mellitus w/hypoglycemia w/o coma
code "E11.65": 'E11.65' from "ICD-10-CM"  // Type 2 diabetes mellitus w/hyperglycemia
code "E11.69": 'E11.69' from "ICD-10-CM"  // Type 2 diabetes mellitus w/other specified complication(use additional code for comp.)
code "E13.618": 'E13.618' from "ICD-10-CM"  // Other specified diabetes mellitus w/other diabetic arthropathy
code "E13.620": 'E13.620' from "ICD-10-CM"  // Other specified diabetes mellitus w/diabetic dermatitis
code "E13.621": 'E13.621' from "ICD-10-CM"  // Other specified diabetes mellitus w/foot ulcer
code "E13.622": 'E13.622' from "ICD-10-CM"  // Other specified diabetes mellitus w/other skin ulcer
code "E13.628": 'E13.628' from "ICD-10-CM"  // Other specified diabetes mellitus w/other skin complications
code "E13.630": 'E13.630' from "ICD-10-CM"  // Other specified diabetes mellitus w/periodontal disease
code "E13.638": 'E13.638' from "ICD-10-CM"  // Other specified diabetes mellitus w/other oral complications
code "E13.649": 'E13.649' from "ICD-10-CM"  // Other specified diabetes mellitus w/hypoglycemia w/o coma
code "E13.65": 'E13.65' from "ICD-10-CM"  // Other specified diabetes mellitus w/hyperglycemia
code "E13.69": 'E13.69' from "ICD-10-CM"  // Other specified diabetes mellitus w/other specified complication

code "Z48.89": 'Z48.89' from "ICD-10-CM"  // Encounter for other specified surgical aftercare


parameter service_request ServiceRequest

define "All_Codes": {"Z47.1","Z51.89","Z48.812","S06.890A","998.83","T81.89XA","V58.42","Z48.3","I50.20","I50.21","I50.22","I50.23","I50.30","I50.31","I50.32","I50.33","I50.40","I50.41","I50.42","I50.43","I50.9","E11.618","E11.620","E11.621","E11.622","E11.628","E11.630","E11.638","E11.649","E11.65","E11.69","E13.618","E13.620","E13.621","E13.622","E13.628","E13.630","E13.638","E13.649","E13.65","E13.69","Z48.89"}

context Patient 

define "Today": Today()

define "True": true

define "False": false

define RelevantDiagnoses: 
  ActiveOrRecurring([Condition: "All_Codes"])

define OtherDiagnoses: 
  ActiveOrRecurring([Condition] except RelevantDiagnoses)

define function ActiveOrRecurring(CondList List<Condition>):
  CondList C where C.clinicalStatus.coding.code in {'active', 'relapse'}

define function getOnsetString(cond FHIR.Condition):
  Coalesce(cond.onset,'Unspecified')

define "RequestEncounter": singleton from (
      [Encounter] encounter
        where ('Encounter/' + encounter.id) = service_request.encounter.reference.value)

//  returns Conditions
define "Diagnosis": RequestEncounter.diagnosis

//  returns the index-th diagnosis (a Condition)
define function getCondition(index Integer) : singleton from (
    [Condition] cond
      where ('Condition/' + cond.id ) = Diagnosis[index].condition.reference.value)
    

define "DateF2F": RequestEncounter.period.start.value

// we currently only support a single condition to show up in the table, so the code below
//	is hard-coded to look into getCondition(0); when the ability to read in groups becomes
//	available, we should be able to extend this to do getCondition(index) where index is the i-th condition

define "DiagnosesCode": RelevantDiagnoses[0].code.coding[0].code.value

define "DiagnosesDescription": RelevantDiagnoses[0].code.coding[0].display.value

define "DiagnosesStartDate": getOnsetString(RelevantDiagnoses[0])

define "DiagnosesStatus": RelevantDiagnoses[0].clinicalStatus.coding[0].code.value

define "OtherPertimentDiagnosesCode": OtherDiagnoses[0].code.coding[0].code.value

define "OtherPertimentDiagnosesDescription": OtherDiagnoses[0].code.coding[0].display.value

define "OtherPertimentDiagnosesStartDate": getOnsetString(OtherDiagnoses[0])
define "OtherPertimentDiagnosesStatus": OtherDiagnoses[0].clinicalStatus.coding[0].code.value