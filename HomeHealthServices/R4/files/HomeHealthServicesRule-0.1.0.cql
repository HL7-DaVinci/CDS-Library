library HomeHealthServicesRule version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

parameter Patient Patient
parameter service_request ServiceRequest

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
  'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Medicare-Home-Health-Benefit-Text-Only.pdf'

define RESULT_QuestionnaireOrderUri:
  'Questionnaire/HomeHealthServices'

define RESULT_requestId:
  service_request
