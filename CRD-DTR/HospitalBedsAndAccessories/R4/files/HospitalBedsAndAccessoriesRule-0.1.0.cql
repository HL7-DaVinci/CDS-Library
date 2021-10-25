library HospitalBedsAndAccessoriesRule version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

parameter Patient Patient
parameter device_request DeviceRequest

define "Age":
  AgeInYears()

define RULE_APPLIES:
  true

define PRIORAUTH_REQUIRED:
  false

define DOCUMENTATION_REQUIRED:
  "Age" <= 70

define RESULT_InfoLink:
    'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/ProviderComplianceTipsforHospitalBedsandAccessories-ICN909476.pdf'

define RESULT_QuestionnaireOrderUri:
    'Questionnaire/HospitalBedsAndAccessories'

define RESULT_QuestionnaireFaceToFaceUri:
    'Questionnaire/HospitalBedsAndAccessoriesFaceToFace'

define RESULT_requestId:
  device_request
