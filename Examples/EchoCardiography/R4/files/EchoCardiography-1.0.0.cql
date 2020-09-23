library EchoCardiography version '1.0.0'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include StressEchoCommon version '1.0.0' called StressEchoCommon


codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'

code "8867-4" : '8867-4' from "LOINC"
code "9279-1" : '9279-1' from "LOINC"
code "8480-6" : '8480-6' from "LOINC"
code "8462-4" : '8462-4' from "LOINC"
code "8310-5" : '8310-5' from "LOINC"
code "Chest pain, unspecified" : 'R07.9' from "ICD-10-CM" display 'Chest pain, unspecified'
code "Pain in arm, unspecified" : 'M79.603' from "ICD-10-CM" display 'Pain in arm, unspecified'
code "Jaw pain" : 'R68.84' from "ICD-10-CM" display 'Jaw pain'
code "Shortness of breath" : 'R06.02' from "ICD-10-CM" display 'Shortness of breath'
code "Other forms of dyspnea": 'R06.09' from "ICD-10-CM" display 'Other forms of dyspnea'
code "Right heart failure, unspecified": 'I50.810' from "ICD-10-CM" display 'Right heart failure, unspecified'
code "Nonrheumatic mitral (valve) insufficiency": 'I34.0' from "ICD-10-CM" display 'Nonrheumatic mitral (valve) insufficiency'
code "Nonrheumatic mitral (valve) prolapse": 'I34.1' from "ICD-10-CM" display 'Nonrheumatic mitral (valve) prolapse'
code "Nonrheumatic mitral (valve) stenosis": 'I34.2' from "ICD-10-CM" display 'Nonrheumatic mitral (valve) stenosis'
code "Other nonrheumatic mitral valve disorders": 'I34.8' from "ICD-10-CM" display 'Other nonrheumatic mitral valve disorders'
code "Nonrheumatic mitral valve disorder, unspecified": 'I34.9' from "ICD-10-CM" display 'Nonrheumatic mitral valve disorder, unspecified'
code "Pulmonary hypertension, unspecified": 'I27.20' from "ICD-10-CM" display 'Pulmonary hypertension, unspecified'
code "Other hypertrophic cardiomyopathy": 'I42.2' from "ICD-10-CM" display 'Other hypertrophic cardiomyopathy'
code "Hypotension, unspecified" : 'I95.9' from "ICD-10-CM" display 'Hypotension, unspecified'
code "Angina pectoris, unspecified" : 'I20.9' from "ICD-10-CM" display 'Angina pectoris, unspecified'
code "Chronic ischemic heart disease, unspecified" : 'I25.9' from "ICD-10-CM" display 'Chronic ischemic heart disease, unspecified'
code "Cardiac arrhythmia, unspecified" : 'I49.9' from "ICD-10-CM" display 'Cardiac arrhythmia, unspecified'
code "Atherosclerotic heart disease of native coronary artery without angina pectoris" : 'I25.10' from "ICD-10-CM" display 'Atherosclerotic heart disease of native coronary artery without angina pectoris'
code "Ventricular tachycardia" : 'I47.2' from "ICD-10-CM" display 'Ventricular tachycardia'
code "Essential (primary) hypertension" : 'I10' from "ICD-10-CM" display 'Essential (primary) hypertension'
code "Pre-excitation syndrome" : 'I45.6' from "ICD-10-CM" display 'Pre-excitation syndrome'
code "Creatinine [Mass/volume] in Serum or Plasma" : '2160-0' from "LOINC" display 'Creatinine [Mass/volume] in Serum or Plasma'
code "2D echocardiogram panel" : '34552-0' from "LOINC" display '2D echocardiogram panel'
code "ECG NEMSIS": '71575-5' from "LOINC" display 'ECG NEMSIS'
code "XR Chest Single view" : '36554-4' from "LOINC" display 'XR Chest Single view'
code "Ultrasound.M-mode.calculated" : 'LP6730-8' from "LOINC" display 'Ultrasound.M-mode.calculated'
code "Exercise stress test study" : '18752-6' from "LOINC" display 'Exercise stress test study'
code "EKG 12 channel panel": '34534-8' from "LOINC" display 'EKG 12 channel panel'
code "Encounter for preprocedural cardiovascular examination": 'Z01.810' from "ICD-10-CM" display 'Encounter for preprocedural cardiovascular examination'
code "Heart failure, unspecified": 'I50.9'from "ICD-10-CM" display 'Heart failure, unspecified'
code "Cardiomyopathy, unspecified": 'I42.9' from "ICD-10-CM" display 'Cardiomyopathy, unspecified'
code "Chronic ischemic heart disease": 'I25.9' from "ICD-10-CM" display 'Chronic ischemic heart disease'
code "Endocarditis, valve unspecified": 'I38' from "ICD-10-CM" display 'Endocarditis, valve unspecified'

parameter "ServiceRequest" ServiceRequest

context Patient
    		 
define ServiceEncounter:
	StressEchoCommon."ServiceEncounter"
	
define function "EncounterDiagnosis"(Encounter Encounter):
	Encounter.diagnosis D
	return First([Condition]C 
				where C.id.value = "GetId"(D.condition.reference.value)
					and FHIRHelpers.ToInteger(D.rank) = 2)
		
define ServiceCondition:
	"EncounterDiagnosis"("ServiceEncounter")
	
define ServiceDiagnosis:
	First("ServiceCondition" S 
			where (First(S.code.coding)= "Right heart failure, unspecified"
				or First(S.code.coding) = "Nonrheumatic mitral (valve) insufficiency"
				or First(S.code.coding) = "Nonrheumatic mitral (valve) prolapse"
				or First(S.code.coding) = "Nonrheumatic mitral (valve) stenosis"
				or First(S.code.coding) = "Other nonrheumatic mitral valve disorders"
				or First(S.code.coding) = "Nonrheumatic mitral valve disorder, unspecified"
				or First(S.code.coding) = "Pulmonary hypertension, unspecified"
				or First(S.code.coding) = "Other hypertrophic cardiomyopathy"
				or First(S.code.coding) = "Angina pectoris, unspecified"
				or First(S.code.coding) = "Chronic ischemic heart disease, unspecified"
				or First(S.code.coding) = "Cardiac arrhythmia, unspecified" 
				or First(S.code.coding) = "Atherosclerotic heart disease of native coronary artery without angina pectoris"
				or First(S.code.coding) = "Ventricular tachycardia"
				or First(S.code.coding) = "Pre-excitation syndrome"))
				
define RelevantDiagnosis:
	"ServiceDiagnosis".code.coding[0].display.value	
		
define function "GetId"(uri String):
	Last(Split(uri, '/'))
	
define ServiceDiagnosticReport:
	First([Observation]D
	where D.subject.reference.value = 'Patient/'+ Patient.id.value
		and StressEchoCommon."Normalize Interval for Observation effective"(D.effective) starts after (Today() -60 days))
		
define ImagingTest:
	"ServiceDiagnosticReport" R
		where First(R.code.coding) = "XR Chest Single view"
			or First(R.code.coding) = "Exercise stress test study"
			or First(R.code.coding) = "EKG 12 channel panel"
			or First(R.code.coding) = "2D echocardiogram panel"
			or First(R.code.coding) =  "ECG NEMSIS"
			  
define PriorImagingTest:
	First("ImagingTest".code.coding).display.value

define DateOfImaging:
	start of StressEchoCommon."Normalize Interval for Observation effective"("ImagingTest".effective)
		
define ReasonCondition:
	StressEchoCommon."Evaluation"
		 	
define Reason:
	First("ReasonCondition".code.coding).display.value	
	
define DateOfAssessment:
	start of StressEchoCommon."Normalize Onset"("ReasonCondition".onset)
	
define TreatmentPerformed:
 	First([Procedure]P
 	where P.subject.reference.value = 'Patient/'+ Patient.id.value
 		and P.status.value = 'completed'
 		and StressEchoCommon."Normalize Interval Procedure"(P.performed) starts after (Today()-1 year))
 		
define ProceduresPerformed:
	"TreatmentPerformed".code.coding[0].display.value
	
define TreatmentDate:
	start of StressEchoCommon."Normalize Interval Procedure"("TreatmentPerformed".performed)
	
define UnspecifiedChestPain:
	First([Condition]P
		where P.subject.reference.value = 'Patient/'+ Patient.id.value
		and P.code.coding[0] = "Chest pain, unspecified"
		and P.encounter.reference.value = 'Encounter/'+ "ServiceEncounter".id.value)
				
define ChestPain:
	if ("UnspecifiedChestPain" is not null) 
	then true
	else false
	
define ChestPainDate:
	start of StressEchoCommon."Normalize Onset"("UnspecifiedChestPain".onset)
	
define ChestPainSeverity:
	First("UnspecifiedChestPain".severity.coding).display.value
	
define UnspecifiedArmPain:
	singleton from([Condition]P
		where P.subject.reference.value = 'Patient/'+ Patient.id.value
		and First(P.code.coding) = "Pain in arm, unspecified"
		and P.encounter.reference.value = 'Encounter/'+ "ServiceEncounter".id.value)
			
define ArmPain: 
	if ("UnspecifiedArmPain" is not null)
	then true
	else false
	
define ArmPainDate:
	start of StressEchoCommon."Normalize Onset"("UnspecifiedArmPain".onset)
	
define ArmPainSeverity:
	First("UnspecifiedArmPain".severity.coding).display.value
		
define UnspecifiedJawPain:
	First([Condition]P
		where P.subject.reference.value = 'Patient/'+ Patient.id.value
		and First(P.code.coding) = "Jaw pain"
		and P.encounter.reference.value = 'Encounter/'+ "ServiceEncounter".id.value)
	
define JawPain:
	if ("UnspecifiedJawPain" is not null) 
	then true
	else false
define JawPainDate:
	start of StressEchoCommon."Normalize Onset"("UnspecifiedJawPain".onset)
	
define JawPainSeverity:
	First("UnspecifiedJawPain".severity.coding).display.value
	
define UnspecifiedShortnessOfBreath:
	First([Condition]P
		where P.subject.reference.value = 'Patient/'+ Patient.id.value
		and First(P.code.coding) = "Shortness of breath"
		and P.encounter.reference.value = 'Encounter/'+ "ServiceEncounter".id.value)
		
define ShortnessOfBreath:
	if ("UnspecifiedShortnessOfBreath" is not null)  
	then true
	else false
	
define ShortnessOfBreathDate:
	start of StressEchoCommon."Normalize Onset"("UnspecifiedShortnessOfBreath".onset)
	
define ShortnessOfBreathSeverity:
	First("UnspecifiedShortnessOfBreath".severity.coding).display.value
	
define PatientHistory:
	StressEchoCommon."PatientHistory"

define ImagingHistory:
	StressEchoCommon."ImagingHistory"
		
define VitalSigns:
	StressEchoCommon."VitalSigns"
	
define ECG:
	StressEchoCommon."ECG"
	
define Diabetic:
	StressEchoCommon."Diabetic"
			
define HighSystolicPressure:
	StressEchoCommon."HighSystolicPressure"
	
define UninterpretableECG:
	StressEchoCommon."UninterpretableECG"
	
define ImagingConditions:
	StressEchoCommon."ImagingConditions"
	
define VentricularTachycardia:
	StressEchoCommon."VentricularTachycardia"
	
define ComputerTomography:
	StressEchoCommon."ComputerTomography"
	
define ETTPerformed:
	StressEchoCommon."ETTPerformed"
	
define PCICABGCodes:
	StressEchoCommon."PCICABGCodes"
	
	