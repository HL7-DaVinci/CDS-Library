library HypoxemiaRule version '1.0.0'
using FHIR version '4.0.0'

parameter Patient Patient
parameter service_request ServiceRequest

define RULE_APPLIES:
  true

define PRIORAUTH_REQUIRED:
  true 

define DOCUMENTATION_REQUIRED:
  true

define RESULT_InfoLink:
  'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/ProviderComplianceTipsforGlucoseMonitors-ICN909465.pdf'

define RESULT_QuestionnaireOrderUri:
  'Questionnaire/Hypoxemia'

define RESULT_requestId:
  service_request
