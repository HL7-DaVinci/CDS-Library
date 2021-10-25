library LowerLimbProsthesisRule version '1.0.0'
using FHIR version '4.0.0'

parameter Patient Patient
parameter device_request DeviceRequest

define RULE_APPLIES:
  true

define PRIORAUTH_REQUIRED:
  true 

define DOCUMENTATION_REQUIRED:
  true

define RESULT_InfoLink:
  'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/ProviderComplianceTipsforGlucoseMonitors-ICN909465.pdf'

define RESULT_QuestionnaireOrderUri:
  'Questionnaire/LowerLimbProsthesis'

define RESULT_requestId:
  device_request
