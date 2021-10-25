library PositiveAirwayPressureDevicesRule version '0.1.0'
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
    'https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/downloads/PAP_DocCvg_Factsheet_ICN905064.pdf'

define RESULT_QuestionnaireOrderUri:
    'Questionnaire/PositiveAirwayPressureDevices'

define RESULT_QuestionnaireFaceToFaceUri:
    'Questionnaire/PositiveAirwayPressureDevicesFaceToFace'

define RESULT_requestId:
  device_request
