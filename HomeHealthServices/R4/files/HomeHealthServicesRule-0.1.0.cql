library HomeHealthServicesRule version '0.1.0'
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
  'Prior Authorization required.'

define RESULT_Details:
  'Authorization is required, follow the link for more information.'

define RESULT_InfoLink:
  'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Medicare-Home-Health-Benefit-Text-Only.pdf'

define RESULT_QuestionnaireOrderUri:
  'Questionnaire/HomeHealthServices'

define RESULT_QuestionnairePlanOfCareUri:
  'Questionnaire/HomeHealthServicesPlanOfCare'

define RESULT_requestId:
  service_request
