library BasicClinicalInfoPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

context Patient

define Today: Today()

define AnswerYes:
  System.Code {
    code: 'Y',
    display: 'Yes'
  }

define Allergies:
  CodesFromAllergies(ConfirmedAllergies([AllergyIntolerance]))

define function CodesFromAllergies(AllergyList List<AllergyIntolerance>):
  distinct(flatten(
    AllergyList C
      let AllergyCodings:
          (C.code.coding) CODING where CODING.system.value in {
            'http://www.nlm.nih.gov/research/umls/rxnorm'
          }
          return FHIRHelpers.ToCode(CODING)
      return AllergyCodings
  ))

define function ConfirmedAllergies(AllergyList List<AllergyIntolerance>):
  AllergyList C where C.verificationStatus.coding.code = 'confirmed'

