library ImmunosuppressiveDrugsRule version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers


parameter Patient Patient
parameter medication_request MedicationRequest
parameter medication_dispense MedicationDispense

define RULE_APPLIES:
    true

define PRIORAUTH_REQUIRED:
  false

define DOCUMENTATION_REQUIRED:
  true

define RESULT_Summary:
  'Documentation Required.'

define RESULT_Details:
  'Documentation Required, please complete form via Smart App link.'

define RESULT_InfoLink:
    'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/ProviderComplianceTipsforHospitalBedsandAccessories-ICN909476.pdf'

define RESULT_QuestionnaireOrderUri:
    'Questionnaire/ImmunosuppressiveDrugs'  

define RESULT_QuestionnaireDispenseUri:
    'Questionnaire/ImmunosuppressiveDrugs'  

define RESULT_QuestionnaireProgressNoteUri:
    'Questionnaire/ImmunosuppressiveDrugsProgressNote'

define RESULT_requestId:
  medication_request

define RESULT_dispense:
  medication_dispense

define "MedicationCodingFromParameter": Coalesce(medication_request.medication.coding, medication_dispense.medication.coding)
  
define ALTERNATIVE_THERAPY:
  if MedicationCodingFromParameter.code.value in { '105611', '239983' }
  then Code { code: '197388', display: 'Azathioprine 50 MG Oral', system: 'http://www.nlm.nih.gov/research/umls/rxnorm' }
  else null
