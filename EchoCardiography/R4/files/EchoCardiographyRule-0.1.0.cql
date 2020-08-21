library EchocardiographyRule version '0.1.0'
using FHIR version '4.0.0'

parameter Patient Patient
parameter service_request ServiceRequest

define RULE_APPLIES:
  true

define PRIORAUTH_REQUIRED:
  true 

define DOCUMENTATION_REQUIRED:
  true

define RESULT_Summary:
  'Authorization required.'

define RESULT_Details:
  'Authorization is required, follow the link for more information.'

define RESULT_InfoLink:
  'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/ProviderComplianceTipsforGlucoseMonitors-ICN909465.pdf'

define RESULT_QuestionnaireOrderUri:
  'Questionnaire/EchoCardiography'

define RESULT_requestId:
  service_request
