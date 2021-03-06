library HomeOxygenTherapyPrepopulation version '0.0.2'
using FHIR version '3.0.0'
include FHIRHelpers version '3.0.0' called FHIRHelpers


// This cql and questionnaire combo can be considered a partial implementation of these forms:
// https://www.cms.gov/Medicare/CMS-Forms/CMS-Forms/Downloads/CMS484.pdf
// https://www.cms.gov/Research-Statistics-Data-and-Systems/Computer-Data-and-Systems/Electronic-Clinical-Templates/Downloads/Home-Oxygen-Therapy-Order-Template-Draft-20170905-R40.pdf
// with guidance from https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-ICN908804.pdf


codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
codesystem "FHIRRequestIntent": 'http://hl7.org/fhir/request-intent'

//COPD_Codes
code "J44": 'J44' from "ICD-10-CM"
code "J44.0": 'J44.0' from "ICD-10-CM"
code "J44.1": 'J44.1' from "ICD-10-CM"
code "J44.9": 'J44.9' from "ICD-10-CM"

//Home Oxygen Device Codes
//Concentrators
code "E1390": 'E1390' from "HCPCS" display 'Oxygen concentrator, single delivery port'
code "E1391": 'E1391' from "HCPCS" display 'Oxygen concentrator, dual delivery port'
code "E1392": 'E1392' from "HCPCS" display 'Portable Oxygen Concentrator, Rental'

//Compressed gas
code "E0424": 'E0424' from "HCPCS" display 'Stationary gaseous oxygen system, rental (F2F required)'
code "E0431": 'E0431' from "HCPCS" display 'Portable gaseous oxygen system, rental (F2F required)'
code "K0738": 'K0738' from "HCPCS" display 'Portable gaseous oxygen system (includes compressor), rental'
code "E0441": 'E0441' from "HCPCS" display 'Stationary gaseous oxygen contents, 1 month’s supply (F2F required)'
code "E0443": 'E0443' from "HCPCS" display 'Portable gaseous oxygen contents, 1 month’s supply (F2F required)'

//Liquid Oxygen
code "E0439": 'E0439' from "HCPCS" display 'Stationary liquid oxygen system, rental (F2F required)'
code "E0434": 'E0434' from "HCPCS" display 'Portable liquid oxygen system, rental (F2F required)'
code "E0433": 'E0433' from "HCPCS" display 'Portable liquid oxygen system (including liquefier), rental (F2F required)'
code "E0442": 'E0442' from "HCPCS" display 'Stationary liquid oxygen contents, 1 month’s supply (F2F required)'
code "E0444": 'E0444' from "HCPCS" display 'Portable liquid oxygen contents, 1 month’s supply (F2F required)'

//Bronchiectasis_Codes
code "J47": 'J47' from "ICD-10-CM"
code "J47.0": 'J47.0' from "ICD-10-CM"
code "J47.1": 'J47.1' from "ICD-10-CM"
code "J47.9": 'J47.9' from "ICD-10-CM"

//Diffuse_interstitial_lung_disease_Codes
code "J84": 'J84' from "ICD-10-CM"
code "J84.0": 'J84.0' from "ICD-10-CM"
code "J84.01": 'J84.01' from "ICD-10-CM"
code "J84.02": 'J84.02' from "ICD-10-CM"
code "J84.03": 'J84.03' from "ICD-10-CM"
code "J84.09": 'J84.09' from "ICD-10-CM"
code "J84.1": 'J84.1' from "ICD-10-CM"
code "J84.10": 'J84.10' from "ICD-10-CM"
code "J84.11": 'J84.11' from "ICD-10-CM"
code "J84.111": 'J84.111' from "ICD-10-CM"
code "J84.112": 'J84.112' from "ICD-10-CM"
code "J84.113": 'J84.113' from "ICD-10-CM"
code "J84.114": 'J84.114' from "ICD-10-CM"
code "J84.115": 'J84.115' from "ICD-10-CM"
code "J84.116": 'J84.116' from "ICD-10-CM"
code "J84.117": 'J84.117' from "ICD-10-CM"
code "J84.17": 'J84.17' from "ICD-10-CM"
code "J84.2": 'J84.2' from "ICD-10-CM"
code "J84.8": 'J84.8' from "ICD-10-CM"
code "J84.81": 'J84.81' from "ICD-10-CM"
code "J84.82": 'J84.82' from "ICD-10-CM"
code "J84.83": 'J84.83' from "ICD-10-CM"
code "J84.84": 'J84.84' from "ICD-10-CM"
code "J84.841": 'J84.841' from "ICD-10-CM"
code "J84.842": 'J84.842' from "ICD-10-CM"
code "J84.843": 'J84.843' from "ICD-10-CM"
code "J84.848": 'J84.848' from "ICD-10-CM"
code "J84.89": 'J84.89' from "ICD-10-CM"
code "J84.9": 'J84.9' from "ICD-10-CM"

//Cystic_fibrosis_Codes
code "E84": 'E84' from "ICD-10-CM"
code "E84.0": 'E84.0' from "ICD-10-CM"
code "E84.1": 'E84.1' from "ICD-10-CM"
code "E84.11": 'E84.11' from "ICD-10-CM"
code "E84.19": 'E84.19' from "ICD-10-CM"
code "E84.8": 'E84.8' from "ICD-10-CM"
code "E84.9": 'E84.9' from "ICD-10-CM"

//Pulmonary_hypertension_Codes
code "I27.0": 'I27.0' from "ICD-10-CM"
code "I27.2": 'I27.2' from "ICD-10-CM"

//Hypoxemia_Codes
code "R09.02": 'R09.02' from "ICD-10-CM"


//  Loinc codes for observations
//Arterial_oxygen_saturation_Codes
code "59408-5": '59408-5' from "LOINC"
//Arterial_partial_pressure_of_oxygen_Codes
code "2703-7": '2703-7' from "LOINC"
//Arterial_oxygen_saturation_during_exercise_Codes
code "89276-0": '89276-0' from "LOINC"
//Note: cant find loinc code for partial pressure during exercise

//Hematocrit_lab_test_Codes
code "20570-8": '20570-8' from "LOINC"
code "31100-1": '31100-1' from "LOINC"
code "32354-3": '32354-3' from "LOINC"
code "41654-5": '41654-5' from "LOINC"
code "41655-2": '41655-2' from "LOINC"
code "4544-3": '4544-3' from "LOINC"
code "4545-0": '4545-0' from "LOINC"
code "71829-6": '71829-6' from "LOINC"
code "71830-4": '71830-4' from "LOINC"
code "71832-0": '71832-0' from "LOINC"
code "71833-8": '71833-8' from "LOINC"



//Immobilization_Codes
code "102491009": '102491009' from "SNOMED-CT"
code "129857008": '129857008' from "SNOMED-CT"
code "129859006": '129859006' from "SNOMED-CT"
code "160685001": '160685001' from "SNOMED-CT"
code "371632003": '371632003' from "SNOMED-CT"
code "8510008": '8510008' from "SNOMED-CT"

// FHIR Request Intent Codes
code "Intent Original Order code": 'original-order' from "FHIRRequestIntent" display 'Original Order'
concept "Intent Original Order": { "Intent Original Order code" } display 'Original Order'

// Device Categories
concept "Concentrator": { "E1390", "E1391", "E1392" }
concept "Compressed Gas": { "E0424", "E0431", "K0738", "E0441", "E0443" }
concept "Liquid Oxygen": { "E0439", "E0434", "E0433", "E0442", "E0444" }

parameter device_request DeviceRequest

define "All Oxygen Device Codes": { "E1390", "E1391", "E1392", "E0424", "E0431", "K0738", "E0441", "E0443", "E0439", "E0434", "E0433", "E0442", "E0444" }

// Relevant Diagnosis Code Lists
define "COPD_Codes": { "J44", "J44.0", "J44.1", "J44.9" }
define "Bronchiectasis_Codes": { "J47", "J47.0", "J47.1", "J47.9" }
define "Diffuse_interstitial_lung_disease_Codes": { "J84", "J84.0", "J84.01", "J84.02", "J84.03",
  "J84.09", "J84.1", "J84.10", "J84.11", "J84.111", "J84.112", "J84.113", "J84.114", "J84.115",
  "J84.116", "J84.117", "J84.17", "J84.2", "J84.8", "J84.81", "J84.82", "J84.83", "J84.84",
  "J84.841", "J84.842", "J84.843", "J84.848", "J84.89", "J84.9" }
define "Cystic_fibrosis_Codes": { "E84", "E84.0", "E84.1", "E84.11", "E84.19", "E84.8", "E84.9" }
define "Pulmonary_hypertension_Codes": { "I27.0", "I27.2" }
define "Hypoxemia_Codes": { "R09.02" }

// Observation code lists
define "Arterial_oxygen_saturation_Codes": { "59408-5" }
define "Arterial_partial_pressure_of_oxygen_Codes": { "2703-7" }
define "Arterial_oxygen_saturation_during_exercise_Codes": { "89276-0" }

define "Hematocrit_lab_test_Codes": { "20570-8", "31100-1", "32354-3", "41654-5", "41655-2", "4544-3", "4545-0", "71829-6", "71830-4", "71832-0", "71833-8" }

// Other codes
define "Immobilization_Codes": { "102491009", "129857008", "129859006", "160685001", "371632003", "8510008" }


context Patient

define "Today": Today()

// coverage requirement info
define "RelevantDiagnoses": {
  if exists(Confirmed(ActiveOrRecurring([Condition: "COPD_Codes"]))) then 'COPD' else 'null',
  if exists("Confirmed"("ActiveOrRecurring"([Condition: "Bronchiectasis_Codes"]))) then 'Bronchiectasis' else 'null',
  if exists("Confirmed"("ActiveOrRecurring"([Condition: "Diffuse_interstitial_lung_disease_Codes"]))) then 'Diffuse Interstitial Lung Disease' else 'null',
  if exists("Confirmed"("ActiveOrRecurring"([Condition: "Cystic_fibrosis_Codes"]))) then 'Cystic Fibrosis' else 'null',
  if exists("Confirmed"("ActiveOrRecurring"([Condition: "Pulmonary_hypertension_Codes"]))) then 'Pulmonary Hypertension' else 'null',
  if exists("Confirmed"("ActiveOrRecurring"([Condition: "Hypoxemia_Codes"]))) then 'Hypoxemia' else 'null'
} except { 'null' } // except 'null' is a workaround since I don't see how to remove actual nulls

define "ArterialOxygenSaturation": "LowestObservation"("WithUnit"("Verified"("ObservationLookBack"([Observation: "Arterial_oxygen_saturation_Codes"], 3 months)), '%'))
define "ArterialPartialPressureOfOxygen": "LowestObservation"("WithUnit"("Verified"("ObservationLookBack"([Observation: "Arterial_partial_pressure_of_oxygen_Codes"], 3 months)), 'mm[Hg]'))
define "ArterialOxygenSaturationExercise": "LowestObservation"("WithUnit"("Verified"("ObservationLookBack"([Observation: "Arterial_oxygen_saturation_during_exercise_Codes"], 3 months)), '%'))

define "PatientMobile": not exists("Confirmed"("ActiveOrRecurring"([Condition: "Immobilization_Codes"])))

define "HematocritThatIsGreaterThanThreshold": "HighestObservation"("WithUnit"("Verified"("ObservationLookBack"([Observation: "Hematocrit_lab_test_Codes"], 3 months)), '%'))
define "PatientHasHematocritThatIsGreaterThanThreshold": exists("HematocritThatIsGreaterThanThreshold")

// prescribed use
define "OccurrenceTimingDuration": (device_request.occurrence as FHIR.Timing).repeat.bounds as FHIR.Duration
define "OccurrenceTimingQuantity":
  if "OccurrenceTimingDuration" is not null
  then System.Quantity { value: "OccurrenceTimingDuration".value.value, unit: "OccurrenceTimingDuration".unit.value }
  else null
define "LengthOfNeed": 
  ConvertQuantity("OccurrenceTimingQuantity", 'mo').value

define "FrequencyOfUseText":
  (device_request.occurrence as FHIR.Timing).code.text.value

define "FrequencyOfUseList":
  Split("FrequencyOfUseText", ' AND ')

// filters out invalid frequencies
define "FrequencyOfUse":
  "FrequencyOfUseList" FrequencyText
    where FrequencyText in { 'During sleep', 'During exertion', 'At rest and awake' }

// device request info
define "DeviceRequestHcpcsCoding": singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define "DeviceRequestCode":
  singleton from ("All Oxygen Device Codes" DeviceCode
    where DeviceCode ~ DeviceRequestHcpcsCoding)

define "DeviceRequestDescription": 'HCPCS ' + "DeviceRequestHcpcsCoding".code.value + ' - ' + Coalesce("DeviceRequestHcpcsCoding".display.value, "DeviceRequestCode".display)
define "DeviceRequestedIsPortable": "DeviceRequestHcpcsCoding".code.value in { 'E0433', 'E0434', 'E0444', 'EO431', 'K0738', 'E0443', 'E1392' }
define "DeviceRequestedIsStationary": "DeviceRequestHcpcsCoding".code.value in { 'E0439', 'E0442', 'E0424', 'E0441', 'E1390', 'E1391' }

define "DeviceType":
  if device_request.code ~ "Compressed Gas"
    then 'Compressed Gas'
  else if device_request.code ~ "Liquid Oxygen"
    then 'Liquid'
  else if device_request.code ~ "Concentrator"
    then 'Concentrator'
  else
    null

define "DeviceOrderType":
  if device_request.intent is not null
    then if device_request.intent ~ "Intent Original Order"
      then 'Initial or original order for certification'
      else null
    else null

////////////////////////////// Taken from CDS Connect Commons for FHIR, could replace with stu3 version of helper library
define function "ActiveOrRecurring"(CondList List<Condition>):
  CondList C where C.clinicalStatus.value in {'active', 'relapse'}

define function "ObservationLookBack"(ObsList List<Observation>, LookBack System.Quantity):
  ObsList O
    let LookBackInterval: Interval[Now() - LookBack, Now()]
    where (cast O.effective as dateTime).value in LookBackInterval
      or "NullSafeToInterval"(cast O.effective as Period) overlaps LookBackInterval
      or O.issued in LookBackInterval

define function "NullSafeToInterval"(Pd FHIR.Period):
  if Pd is not null then Interval[Pd."start".value, Pd."end".value] else null

define function "Verified"(ObsList List<Observation>):
  ObsList O where O.status.value in {'final', 'amended'}

define function "WithUnit"(ObsList List<Observation>, Unit String):
  ObsList O where (cast O.value as Quantity).unit.value = Unit or (cast O.value as Quantity).code.value = Unit

define function "HighestObservation"(ObsList List<Observation>):
  Max(ObsList O return "NullSafeToQuantity"(cast O.value as Quantity))

define function "Confirmed"(CondList List<Condition>):
  CondList C where C.verificationStatus.value = 'confirmed'

define function "NullSafeToQuantity"(Qty FHIR.Quantity):
  if Qty is not null then
    System.Quantity {
      value: Qty.value.value,
      unit: Coalesce(Qty.unit.value, Qty.code.value)
    }
  else null

define function "LowestObservation"(ObsList List<Observation>):
  Min(ObsList O return "NullSafeToQuantity"(cast O.value as Quantity))