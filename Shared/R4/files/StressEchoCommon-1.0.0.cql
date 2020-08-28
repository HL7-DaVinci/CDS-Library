library StressEchoCommon version '1.0.0'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers


codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'

valueset "CABG, PCI Procedure": '2.16.840.1.113762.1.4.1138.566'

code "Chest pain, unspecified" : 'R07.9' from "ICD-10-CM" display 'Chest pain, unspecified'
code "Bilateral primary osteoarthritis of knee" : 'M17.0' from "ICD-10-CM" display 'Bilateral primary osteoarthritis of knee'
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
code "Vital signs, weight, height, head circumference, oxygen saturation and BMI panel" : '85353-1' from "LOINC" display 'Vital signs, weight, height, head circumference, oxygen saturation and BMI panel'
code "Electrocardiogram, routine ECG with at least 12 leads; with interpretation and report" : '93000' from "CPT" display 'Electrocardiogram, routine ECG with at least 12 leads; with interpretation and report'
code "Electrocardiogram, routine ECG with at least 12 leads; interpretation and report only": '93010' from "CPT" display 'Electrocardiogram, routine ECG with at least 12 leads; interpretation and report only'
code "Rhythm ECG, 1-3 leads; with interpretation and report": '93040' from "CPT" display 'Rhythm ECG, 1-3 leads; with interpretation and report'
code "Rhythm ECG, 1-3 leads; interpretation and report only": '93042' from "CPT" display 'Rhythm ECG, 1-3 leads; interpretation and report only'
code "Left bundle-branch block, unspecified": 'I44.7' from "ICD-10-CM" display 'Left bundle-branch block, unspecified'
code "Ventricular premature depolarization" :'I49.3' from "ICD-10-CM" display 'Ventricular premature depolarization'
code "Cardiomegaly": 'I51.7' from "ICD-10-CM" display 'Cardiomegaly'
code "Pre-excitation syndrome" : 'I45.6' from "ICD-10-CM" display 'Pre-excitation syndrome'
code "Diabetes mellitus due to underlying condition": 'E08' from "ICD-10-CM" display 'Diabetes mellitus due to underlying condition'
code "Drug or chemical induced diabetes mellitus": 'E09' from "ICD-10-CM" display 'Drug or chemical induced diabetes mellitus'
code "Type 1 diabetes mellitus": 'E10' from "ICD-10-CM" display 'Type 1 diabetes mellitus'
code "Type 2 diabetes mellitus": 'E11' from "ICD-10-CM" display 'Type 2 diabetes mellitus'
code "Other specified diabetes mellitus": 'E13' from "ICD-10-CM" display 'Other specified diabetes mellitus'
code "Computed tomography, heart, without contrast material, with quantitative evaluation of coronary calcium": '75571' from "CPT" display 'Computed tomography, heart, without contrast material, with quantitative evaluation of coronary calcium'
code "Systolic blood pressure": '8480-6' from "ICD-10-CM" display 'Systolic blood pressure'
code "Silent myocardial ischemia": 'I25.6' from "ICD-10-CM" display 'Silent myocardial ischemia'
code "Syncope and Collapse": 'R55' from "ICD-10-CM" display  'Syncope and Collapse'
code "Acute myocardial infarction, unspecified": 'I21.9' from "ICD-10-CM" display 'Acute myocardial infarction, unspecified'
code "ST elevation (STEMI) myocardial infarction of unspecified site": 'I21.3' from "ICD-10-CM" display 'ST elevation (STEMI) myocardial infarction of unspecified site'
code "Routine EKG using at least 12 leads including interpretation and report": '93000' from "HCPCS" display 'Routine EKG using at least 12 leads including interpretation and report'
code "Routine electrocardiogram (EKG) using at least 12 leads with interpretation and report": '93010' from "HCPCS" display 'Routine electrocardiogram (EKG) using at least 12 leads with interpretation and report'
code "Tracing of electrical activity of heart using 1-3 leads with interpretation and report": '93040' from "HCPCS" display 'Tracing of electrical activity of heart using 1-3 leads with interpretation and report'
code "Interpretation and report of electrical activity of heart using 1-3 leads": '93042' from "HCPCS" display 'Interpretation and report of electrical activity of heart using 1-3 leads'
code "Heart rhythm tracing, analysis, and interpretation of 48-hour EKG": '93224' from "HCPCS" display 'Heart rhythm tracing, analysis, and interpretation of 48-hour EKG'
code "Heart rhythm tracing, analysis, and interpretation of 48-hour EKG A": '93227' from "HCPCS" display 'Heart rhythm tracing, analysis, and interpretation of 48-hour EKG'
code "Exercise or drug-induced heart and blood vessel stress test with EKG monitoring, physician supervision, interpretation, and report": '93015' from "HCPCS" display 'Exercise or drug-induced heart and blood vessel stress test with EKG monitoring, physician supervision, interpretation, and report'
code "Exercise or drug-induced heart and blood vessel stress test with EKG monitoring and physician supervision": '93016' from "HCPCS" display 'Exercise or drug-induced heart and blood vessel stress test with EKG monitoring and physician supervision'
code "Exercise or drug-induced heart and blood vessel stress test with EKG tracing and monitoring": '93017' from "HCPCS" display 'Exercise or drug-induced heart and blood vessel stress test with EKG tracing and monitoring'
code "Exercise or drug-induced heart and blood vessel stress test with EKG monitoring, physician interpretation and report": '93018' from "HCPCS" display 'Exercise or drug-induced heart and blood vessel stress test with EKG monitoring, physician interpretation and report'

parameter "ServiceRequest" ServiceRequest

context Patient
	
define PCICABGCodes:
	([Procedure]P
		where P.status.value = 'completed'
		and First(P.code.coding) in "CABG, PCI Procedure")
							
define ServiceEncounter:
	First([Encounter]E where 'Encounter/' + E.id.value = "ServiceRequest".encounter.reference.value)
	
define Evaluation:
	First([Condition]C
	where C.subject.reference.value = 'Patient/'+ Patient.id.value
	  and C.encounter.reference.value = 'Encounter/'+ "ServiceEncounter".id.value
	  and First(C.verificationStatus.coding).code.value = 'unconfirmed'
	  and  ( First(C.code.coding) = "Atherosclerotic heart disease of native coronary artery without angina pectoris"
	       or First(C.code.coding) = "Right heart failure, unspecified"
	       or First(C.code.coding) = "Nonrheumatic mitral (valve) insufficiency"
	       or First(C.code.coding) = "Nonrheumatic mitral (valve) prolapse"
	       or First(C.code.coding) = "Nonrheumatic mitral (valve) stenosis"
	       or First(C.code.coding) = "Other nonrheumatic mitral valve disorders"
	       or First(C.code.coding) = "Other hypertrophic cardiomyopathy"
	       or First(C.code.coding) = "Angina pectoris, unspecified"
	       or First(C.code.coding) = "Chronic ischemic heart disease, unspecified"
	       or First(C.code.coding) = "Endocarditis, valve unspecified"
	       or First(C.code.coding) = "Nonrheumatic mitral valve disorder, unspecified"
	       or First(C.code.coding) = "Pulmonary hypertension, unspecified"
	       or First(C.code.coding) = "Chronic ischemic heart disease, unspecified"
	       or First(C.code.coding) = "Cardiac arrhythmia, unspecified" 
	       or First(C.code.coding) = "Ventricular tachycardia"
	       or First(C.code.coding) = "Pre-excitation syndrome"))
	       
define PatientHistory:
	exists([Condition]C
	with [Observation]O
	such that C.subject.reference.value = 'Patient/'+ Patient.id.value  
		and O.subject.reference.value = 'Patient/'+ Patient.id.value)
		
define ImagingHistory:
	[DiagnosticReport]D
	where D.subject.reference.value = 'Patient/'+ Patient.id.value 
		and ("Normalize Interval Procedure"(D.effective)) starts after Today()-60 days
		
define VitalSigns:
	First([Observation]O
	where O.subject.reference.value = 'Patient/'+ Patient.id.value 
		and O.encounter.reference.value = 'Encounter/'+ "ServiceEncounter".id.value
		and First(O.code.coding) = "Vital signs, weight, height, head circumference, oxygen saturation and BMI panel")
	  		
define ECG:
	[Procedure]P
	where (First(P.code.coding) = "Routine EKG using at least 12 leads including interpretation and report"
		or First(P.code.coding) = "Routine electrocardiogram (EKG) using at least 12 leads with interpretation and report"
		or First(P.code.coding) = "Tracing of electrical activity of heart using 1-3 leads with interpretation and report"
		or First(P.code.coding) = "Interpretation and report of electrical activity of heart using 1-3 leads"
		or First(P.code.coding) = "Heart rhythm tracing, analysis, and interpretation of 48-hour EKG"
		or First(P.code.coding) = "Heart rhythm tracing, analysis, and interpretation of 48-hour EKG A"
    )
	

define Diabetic:
	[Condition]C
	where First(C.clinicalStatus.coding).code.value = 'active'
		and (First(C.code.coding) = "Diabetes mellitus due to underlying condition"
			or First(C.code.coding) = "Drug or chemical induced diabetes mellitus"
			or First(C.code.coding) = "Type 1 diabetes mellitus"
			or First(C.code.coding) = "Type 2 diabetes mellitus"
			or First(C.code.coding) = "Other specified diabetes mellitus")
			
define HighSystolicPressure:
	exists("VitalSigns".component C
		where First(C.code.coding) = "Systolic blood pressure"
			and FHIRHelpers.ToQuantity(C.value).value > 180)
	
define UninterpretableECG:
	exists([Condition]C
	where First(C.clinicalStatus.coding).code.value = 'active'
		and (First(C.code.coding) = "Left bundle-branch block, unspecified"
			or First(C.code.coding) = "Ventricular premature depolarization"
			or First(C.code.coding) = "Cardiomegaly"
			or First(C.code.coding) = "Pre-excitation syndrome"))
			
define ETTPerformed:
	exists([Procedure]P  
	where P.status.value = 'completed'
		and (First(P.code.coding) = "Exercise or drug-induced heart and blood vessel stress test with EKG monitoring, physician supervision, interpretation, and report"
			or First(P.code.coding) = "Exercise or drug-induced heart and blood vessel stress test with EKG monitoring and physician supervision"
			or First(P.code.coding) = "Exercise or drug-induced heart and blood vessel stress test with EKG tracing and monitoring"
			or First(P.code.coding) = "Exercise or drug-induced heart and blood vessel stress test with EKG monitoring, physician interpretation and report"))
			
define ImagingConditions:
	[Condition]C
	where First(C.clinicalStatus.coding).code.value = 'active'
		and (First(C.code.coding) = "Acute myocardial infarction, unspecified"
			or First(C.code.coding) = "ST elevation (STEMI) myocardial infarction of unspecified site")

define VentricularTachycardia:
	[Condition]C
		where First(C.code.coding) = "Ventricular tachycardia"
			and First(C.clinicalStatus.coding).code.value = 'active'
			
define ComputerTomography:
	[Procedure]P
		where First(P.code.coding) = "Computed tomography, heart, without contrast material, with quantitative evaluation of coronary calcium"
			and P.status.value = 'completed'
			
define function "Normalize Interval Procedure"(choice Choice<FHIR.dateTime, FHIR.Age, FHIR.Period, FHIR.Range, FHIR.string>):
 	 if (choice as FHIR.dateTime) is not null then
 		  Interval[FHIRHelpers.ToDateTime(choice as FHIR.dateTime), FHIRHelpers.ToDateTime(choice as FHIR.dateTime)]
	  else if (choice as FHIR.Period) is not null then
		  FHIRHelpers.ToInterval(choice as FHIR.Period)
		else if (choice as FHIR.string) is not null then
    Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute an interval from a String value')
	  else if (choice as FHIR.Age) is not null then
	 	  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(choice as FHIR.Age),
 		FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(choice as FHIR.Age) + 1 year)
		else if (choice as FHIR.Range) is not null then
	  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((choice as FHIR.Range).low),
		  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((choice as FHIR.Range).high) + 1 year)
	  else null
	
	
define function "Normalize Onset"(onset Choice<FHIR.dateTime, FHIR.Age, FHIR.Period, FHIR.Range, FHIR.string>):
  if (onset as FHIR.dateTime) is not null then
	  Interval[FHIRHelpers.ToDateTime(onset as FHIR.dateTime), FHIRHelpers.ToDateTime(onset as FHIR.dateTime)]
	else if (onset as FHIR.Period) is not null then
	  FHIRHelpers.ToInterval(onset as FHIR.Period)
	else if (onset as FHIR.string) is not null then
    Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute an interval from a String value')
	else if (onset as FHIR.Age) is not null then
	  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(onset as FHIR.Age),
		  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(onset as FHIR.Age) + 1 year)
	else if (onset as FHIR.Range) is not null then
	  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((onset as FHIR.Range).low),
		  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((onset as FHIR.Range).high) + 1 year)
	else null