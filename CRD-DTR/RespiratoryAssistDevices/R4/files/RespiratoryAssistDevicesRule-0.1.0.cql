library RespiratoryAssistDevicesRule version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

parameter Patient Patient
parameter device_request DeviceRequest

define RULE_APPLIES:
    true

define PRIORAUTH_REQUIRED:
  false

define DOCUMENTATION_REQUIRED:
  true

define RESULT_InfoLink:
    'https://www.cms.gov/Research-Statistics-Data-and-Systems/Computer-Data-and-Systems/Electronic-Clinical-Templates/Downloads/Respiratory-Assist-Device-Order-Template-Draft-20180412-R10b.pdf'

define RESULT_QuestionnaireOrderUri:
    'Questionnaire/RespiratoryAssistDevices'

define RESULT_QuestionnaireFaceToFaceUri:
  'Questionnaire/RespiratoryAssistDevicesFaceToFace'

define RESULT_QuestionnaireLabUri:
    'Questionnaire/RespiratoryAssistDevicesLab'

define RESULT_requestId:
  device_request
