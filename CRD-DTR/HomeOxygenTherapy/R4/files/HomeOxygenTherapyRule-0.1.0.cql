library HomeOxygenTherapyRule version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

parameter Patient Patient
parameter device_request DeviceRequest

define "Age":
    AgeInYears()

define RULE_APPLIES:
    "Age" > 0

define PRIORAUTH_REQUIRED:
  false 

define DOCUMENTATION_REQUIRED:
  true

define RESULT_InfoLink:
  'https://www.cms.gov/outreach-and-education/medicare-learning-network-mln/mlnproducts/downloads/home-oxygen-therapy-text-only.pdf'

define RESULT_QuestionnaireOrderUri:
  'Questionnaire/HomeOxygenTherapy'

define RESULT_QuestionnaireFaceToFaceUri:
  'Questionnaire/HomeOxygenTherapyFaceToFace'

define RESULT_QuestionnaireLabUri:
  'Questionnaire/HomeOxygenTherapyLab'

define RESULT_QuestionnaireAdditionalUri:
  'Questionnaire/HomeOxygenTherapyAdditional'

define RESULT_requestId:
  device_request
