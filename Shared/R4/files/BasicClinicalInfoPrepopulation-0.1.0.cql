library BasicClinicalInfoPrepopulation version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "HL7-V2-0136": 'http://terminology.hl7.org/CodeSystem/v2-0136' 

code "Yes": 'Y' from "HL7-V2-0136" display 'Yes'

context Patient

define Today: Today()

/* This is a work around to prepopulate with Yes answer for Yes/No question.
   The blocking issue is that when LHC form control merge Questionnaire (the compiled static form)
   and QuestionnaireResponse (the CQL expression results) to create a form representation, 
   the initial value in Questionnaire are ingored. 
   So we cannot use Questionnaire initial to setup the default value. 
*/
define AnswerYes: "Yes"

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

define "AllDiagnoese": ActiveConfirmedDiagnoese([Condition])

define function ActiveConfirmedDiagnoese(CondList List<FHIR.Condition>):
  distinct(
    flatten(
      CondList C
        let DiagnosesCodings:
          (C.code.coding) CODING where CODING.system.value in {
            'http://hl7.org/fhir/sid/icd-10',
            'http://hl7.org/fhir/sid/icd-10-cm',
            'http://snomed.info/sct'
          }
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value
          }
        where C.verificationStatus.coding.code = 'confirmed'
          and C.clinicalStatus.coding.code in {'active', 'relapse'}
          and exists(DiagnosesCodings)
        return DiagnosesCodings
    )
  )  
define "AllProcedures": ProcedureCoding([Procedure])
define function ProcedureCoding(ProcedureList List<FHIR.Procedure>):
  distinct(
    flatten(
      ProcedureList P
        let ProcedureCodings:
          (P.code.coding) CODING 
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value
          }
        return ProcedureCodings
    )
  )

  define "True": true

  define "MedicationList": GetMedicationsList([MedicationStatement])
  define function GetMedicationsList(MedStatementList List<MedicationStatement>):
    distinct(
      flatten(
        MedStatementList MedStatement
          let MedicationList:
            (MedStatement.medication.coding) CODING
            return FHIRHelpers.ToCode(CODING)
          return MedicationList  
      )
    )


