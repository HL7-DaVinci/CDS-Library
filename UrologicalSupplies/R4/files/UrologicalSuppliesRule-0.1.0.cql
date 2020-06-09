library UrologicalSuppliesRule version '0.1.0'
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

define RESULT_Summary:
  'Prior Authorization Required.'

define RESULT_Details:
  'Prior Authorization Required, follow the attached link for information.' 

define RESULT_InfoLink:
    'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/ProviderComplianceTipsforVentilators-MLN9725344Print-Friendly.pdf'

define RESULT_QuestionnaireOrderUri:
    'Questionnaire/UrologicalSuppliesOrder'

define RESULT_requestId:
  service_request