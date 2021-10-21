library AbecmaRule version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers


parameter Patient Patient
parameter medication_request MedicationRequest
parameter medication_dispense MedicationDispense
parameter medication_statement MedicationStatement

define RULE_APPLIES:
    true

define PRIORAUTH_REQUIRED:
  false

define DOCUMENTATION_REQUIRED:
  true

define RESULT_QuestionnaireOrderUri:
    'Questionnaire/Abecma'

define RESULT_QuestionnaireDispenseUri:
    'Questionnaire/Abecma'

define RESULT_QuestionnaireProgressNoteUri:
    'Questionnaire/Abecma'

define RESULT_requestId:
  medication_request

define RESULT_dispense:
  medication_dispense

define DRUG_INTERACTION:
  false

define "MedicationCodingFromParameter": Coalesce(medication_request.medication.coding, medication_dispense.medication.coding)

define "MedicationStatementCodingFromParamter": medication_statement.medication.coding

define REQUESTED_DRUG_CODE:
  MedicationCodingFromParameter

define STATEMENT_DRUG_CODE:
  MedicationStatementCodingFromParamter
