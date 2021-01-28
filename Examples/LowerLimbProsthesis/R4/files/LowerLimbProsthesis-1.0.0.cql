library LowerLimbProsthesis version '1.0.0'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "ICD-9-CM": 'http://hl7.org/fhir/sid/icd-9'
codesystem "LOINC": 'http://loinc.org'
codesystem "HCPCS": 'https://hcpcs.codes/'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CPT": 'https://www.aapc.com/resources/medical-coding/cpt.aspx'
codesystem "NUCCPT":'https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NUCCPT/sourcerepresentation.html'

valueset "Musculoskeletal Assessment": '2.16.840.1.113883.3.7643.3.1031'
valueset "Findings of Neurological Assessment for Orientation or Balance": '2.16.840.1.113883.3.7643.3.1032'
valueset "Immobilization": '2.16.840.1.113883.17.4077.3.2006'
valueset "Serious or Life Threatening Illness": '2.16.840.1.113883.3.464.1003.199.12.1055'
valueset "CardioPulmonary Examination": '2.16.840.1.113883.3.6037.1001.23.95.21'
valueset "Body weight": '2.16.840.1.113762.1.4.1045.159'
valueset "Height": '2.16.840.1.113883.3.464.1003.121.12.1014'
valueset "Face to Face Encounter": '2.16.840.1.113762.1.4.1047.428'
valueset "Inpatient Encounter": '2.16.840.1.113883.3.117.1.7.1.23'
valueset "Right Modifier": '2.16.840.1.113883.3.6037.1001.23.95.24'
valueset "Left Modifier": '2.16.840.1.113883.3.6037.1001.23.95.25'
valueset "Functionality Level 0": '2.16.840.1.113883.3.6037.1001.23.95.26'
valueset "Functionality Level 1": '2.16.840.1.113883.3.6037.1001.23.95.27'
valueset "Functionality Level 2": '2.16.840.1.113883.3.6037.1001.23.95.28'
valueset "Functionality Level 3": '2.16.840.1.113883.3.6037.1001.23.95.29'
valueset "Functionality Level 4": '2.16.840.1.113883.3.6037.1001.23.95.30'
valueset "Physical Examination": '2.16.840.1.113883.3.6037.1001.23.95.31'


parameter "DeviceRequest" DeviceRequest
parameter "MeasurementPeriod" default Interval[@2020-01-03T00:00:00.0, @2021-01-01T00:00:00.0]

context Patient

define DeviceRequestHcpcsCoding:
    First(((cast "DeviceRequest".code as CodeableConcept).coding) D
                where D.system.value = 'https://hcpcs.codes/'
                    return FHIRHelpers."ToCode"(D))

define DateOfOrder:
    ToDate("DeviceRequest".authoredOn)

define DescriptionOfItem:
    'HCPCS ' + "DeviceRequestHcpcsCoding".code + ' - ' + ("DeviceRequestHcpcsCoding".display)

define DeviceOrderType:
    "DeviceRequest".intent.value

define Supplier:
	First([Organization]O where 'Organization/' + O.id.value = "DeviceRequest".performer.reference.value )

define SupplierName:
	"Supplier".name.value

define SupplierNPI:
    (First("Supplier".identifier identifier
    		where identifier.system.value = 'http://hl7.org/fhir/sid/us-npi')).value.value

define SupplierPTAN:
    (First("Supplier".identifier identifier
        where identifier.type.coding[0].system.value = 'http://terminology.hl7.org/CodeSystem/v2-0203' and identifier.type.coding[0].code.value = 'PRN')).value.value

define SupplierAddressObject:
	"Supplier".address 

define SupplierAddress:
	"Supplier".address A
	return A.line[0].value +', ' + A.city.value +', ' + A.state.value+', ' + A.postalCode.value
	
define StartDate:
    ToDate(start of "Normalize Interval"("DeviceRequest".occurrence))

define ServiceEncounter:
	First([Encounter]E where 'Encounter/' + E.id.value = "DeviceRequest".encounter.reference.value)

define ServiceCondition:
	"EncounterDiagnosis"("ServiceEncounter")

define RelevantDiagnosis:
		First("ServiceCondition".code.coding)

define EncounterResource:
	First([Encounter]E where 'Encounter/' + E.id.value = "DeviceRequest".encounter.reference.value )

define EncPractitioner:
    First([Practitioner]P
        where 'Practitioner/' + P.id.value = "DeviceRequest".requester.reference.value)

define FaceToFaceEncounter:
	"EncounterResource" F2FEncounter
	where First(First(F2FEncounter.type).coding) in "Face to Face Encounter"
	and First(F2FEncounter.participant).individual.reference.value = 'Practitioner/' + "EncPractitioner".id.value
	and (First("EncounterPractitioner"(F2FEncounter).qualification.code.coding).code.value = 'MD'
		or First("EncounterPractitioner"(F2FEncounter).qualification.code.coding).code.value = 'NP'
		or First("EncounterPractitioner"(F2FEncounter).qualification.code.coding).code.value = 'CNS'
		or First("EncounterPractitioner"(F2FEncounter).qualification.code.coding).code.value = 'PA')

define FaceToFace:
    "FaceToFaceEncounter" G
        where G.period starts before start of "MeasurementPeriod"

define FFEncounter:
    if ("FaceToFace" is not null)
        then true
        else false

define InpatientEncounter:
    "EncounterResource" ER
        where First(First(ER.type).coding) in "Inpatient Encounter"
        and ER.period ends 2 days before start of "MeasurementPeriod"

define FirstModifier:
    First("DeviceRequest".extension E
            where (First(E.extension).value as CodeableConcept) is not null)

define RightLowerLimb:
    exists("DeviceRequest".extension ext
    where exists(ext.extension E where First((E.value as CodeableConcept).coding) in "Right Modifier"))

define LeftLowerLimb:
    exists("DeviceRequest".extension ext
    where exists(ext.extension E where First((E.value as CodeableConcept).coding) in "Left Modifier"))

define FL0:
    exists("DeviceRequest".extension ext
    where exists(ext.extension E where First((E.value as CodeableConcept).coding) in "Functionality Level 0"))

define FL1:
    exists("DeviceRequest".extension ext
    where exists(ext.extension E where First((E.value as CodeableConcept).coding) in "Functionality Level 1"))

define FL2:
    exists("DeviceRequest".extension ext
    where exists(ext.extension E where First((E.value as CodeableConcept).coding) in "Functionality Level 2"))

define FL3:
    exists("DeviceRequest".extension ext
    where exists(ext.extension E where First((E.value as CodeableConcept).coding) in "Functionality Level 3"))

define FL4:
    exists("DeviceRequest".extension ext
    where exists(ext.extension E where First((E.value as CodeableConcept).coding) in "Functionality Level 4"))

define RightorLeft:
    if (("RightLowerLimb" = true) and ("LeftLowerLimb" = false))
        then 'Right'
        else
        if (("LeftLowerLimb" = true) and ("RightLowerLimb" = false))
        then 'Left' 
        else
        if (("RightLowerLimb"  = true) and ("LeftLowerLimb" = false))
        then 'Both' 
        else null

define FunctionalLevel:
    if ("FL0" = true)
        then 'Level 0'
        else
        if ("FL1" = true)
        then 'Level 1' 
        else
        if ("FL2" = true)
        then 'Level 2' 
        else
        if ("FL3" = true)
        then 'Level 3'
        else
        if ("FL4" = true)
        then 'Level 4'
        else null

define PhyExam:
    First([Procedure] P
    where exists(P.code.coding C where C in "Physical Examination")
    and P.status.value = 'completed')


define PhysicalExaminationType:
    PhyExam.code

define PhysicalExamination:
    if (exists([Procedure] P
    where exists(P.code.coding C where C in "Physical Examination")
    and P.status.value = 'completed'))
    then true
    else false

define ComorbiditiesType:
    First([Condition]C
        where exists(C.code.coding C where C in "Serious or Life Threatening Illness")
            and First(C.clinicalStatus.coding).code.value = 'active'
            and First(C.verificationStatus.coding).code.value = 'confirmed'
            and C.encounter.reference.value = "EncounterResource".id.value)

define ComorbiditiesDetails:
    "ComorbiditiesType".code


define Comorbidities:
    if exists([Condition]C
        where exists(C.code.coding C where C in "Serious or Life Threatening Illness")
            and First(C.clinicalStatus.coding).code.value = 'active'
            and First(C.verificationStatus.coding).code.value = 'confirmed'
            and C.encounter.reference.value = "EncounterResource".id.value)
            then true
            else false


define MobilityDiagnosis:
    First([Condition]C
        where exists(C.code.coding C where C in "Immobilization")
            and First(C.clinicalStatus.coding).code.value = 'active'
            and First(C.verificationStatus.coding).code.value = 'confirmed')


define Mobility:
    if exists([Condition]C
        where exists(C.code.coding C where C in "Immobilization")
            and First(C.clinicalStatus.coding).code.value = 'active'
            and First(C.verificationStatus.coding).code.value = 'confirmed')
    then true
    else false

define MobilityEstimation:
    "MobilityDiagnosis".code


define Musculoskeletal:
    First([Procedure] P
    where exists(P.code.coding C where C in "Musculoskeletal Assessment")
            and P.status.value = 'completed')


define MusculoskeletalAnalysis:
    if ("Musculoskeletal" is not null)
    then true
    else false

define MusculoskeletalEstimation:
    "Musculoskeletal".code


define Neurological:
    First([Procedure] P
        where exists(P.code.coding C where C in "Findings of Neurological Assessment for Orientation or Balance")
            and P.status.value = 'completed')


define NeurologicalAnalysis:
    if ("Neurological" is not null)
    then true
    else false


define NeurologicalEstimation:
    "Neurological".code


define CardioPulmonary:
    First([Procedure] P
        where exists(P.code.coding C where C in "CardioPulmonary Examination")
           and P.status.value = 'completed' )


define CardioPulmonaryAnalysis:
    if ("CardioPulmonary" is not null)
    then true
    else false


define CardioPulmonaryEstimation:
    "CardioPulmonary".code


define Weight:
    First([Observation]O
        where exists(O.code.coding O where O in "Body weight")
            and O.status.value = 'final')


define PatientHeight:
    First([Observation]O
        where exists(O.code.coding O where O in "Height")
            and O.status.value = 'final')


define function GetMiddleInitials(name FHIR.HumanName):
  Substring(Combine((name.given given return Substring(given.value,0,1)),', '),3)


define function GetProcedure(ProcedureList List<Procedure>, ProcedureCode String):
  ProcedureList P where P.code.coding[0].code.value= ProcedureCode

define function "Normalize Interval"(onset Choice<FHIR.dateTime, FHIR.Age, FHIR.Period, FHIR.Range, FHIR.string>):
  if onset is FHIR.dateTime then
	  Interval[FHIRHelpers.ToDateTime(onset as FHIR.dateTime), FHIRHelpers.ToDateTime(onset as FHIR.dateTime)]
	else if onset is FHIR.Period then
	  FHIRHelpers.ToInterval(onset as FHIR.Period)
	else if onset is FHIR.Age then
	  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(onset as FHIR.Age),
		  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(onset as FHIR.Age) + 1 year)
	else null

define function "GetId"(uri String):
	Last(Split(uri, '/'))

define function "EncounterDiagnosis"(Encounter Encounter):
	Encounter.diagnosis D
	return First([Condition]C
				where C.id.value = "GetId"(D.condition.reference.value)
					and FHIRHelpers.ToInteger(D.rank) = 2)

define function "EncounterPractitioner"(Encounter Encounter):
	Encounter.participant PR
	return First([Practitioner]P where 'Practitioner/' + P.id.value = PR.individual.reference.value)
