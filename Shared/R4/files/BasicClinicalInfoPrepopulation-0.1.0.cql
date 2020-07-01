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
          return FHIRHelpers.ToCode(CODING)
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
          return FHIRHelpers.ToCode(CODING)
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


