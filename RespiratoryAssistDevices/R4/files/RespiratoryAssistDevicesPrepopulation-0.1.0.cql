library RespiratoryAssistDevicesPrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers


// This cql and questionnaire combo can be considered a partial implementation of these forms:
//  https://www.cms.gov/Research-Statistics-Data-and-Systems/Computer-Data-and-Systems/Electronic-Clinical-Templates/Downloads/Respiratory-Assist-Device-Order-Template-Draft-20180412-R10b.pdf


codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

// Value sets
valueset "COPD": 'copd'

// value set placeholder for RADORD5a
// reference:  https://www.cms.gov/Research-Statistics-Data-and-Systems/Computer-Data-and-Systems/Electronic-Clinical-Templates/Downloads/Respiratory-Assist-Device-Appendices-A-and-B-Draft-20180412-R10b.pdf, Appendix B
// Notes in worksheet to make this into a multi open choice, but awaiting value set
valueset "RAD_THERAPY_ACCESSORIES": 'rad_therappy_accessories'
// A4604 Tubing With Integrated Heating Element for Use With Positive Airway Pressure Device
// A7027 Combination Oral / nasal Mask, Used With Continuous Positive Airway Pressure Device, Each
// A7028 Oral Cushion for Combination Oral / nasal Mask, Replacement Only, Each
// A7029 Nasal Pillows for Combination Oral / nasal Mask, Replacement Only, Pair
// A7030 Full Face Mask Used With Positive Airway Pressure Device, Each
// A7031 Face Mask Interface, Replacement for Full Face Mask, Each
// A7032 Cushion for Use on Nasal Mask Interface, Replacement Only, Each
// A7033 Pillow for Use on Nasal Cannula Type Interface, Replacement Only, Pair
// A7034 Nasal Interface(Mask or Cannula Type) Used With Positive Airway Pressure Device, With or Without Head Strap
// A7035 Headgear Used With Positive Airway Pressure Device
// A7036 Chinstrap Used With Positive Airway Pressure Device
// A7037 Tubing Used With Positive Airway Pressure Device
// A7038 Filter, Disposable, Used With Positive Airway Pressure Device
// A7039 Filter, Non Disposable, Used With Positive Airway Pressure Device
// A7044 Oral Interface Used With Positive Airway Pressure Device, Each
// A7045 Exhalation Port With or Without Swivel Used With Accessories for Positive Airway Devices, Replacement Only
// A7046 Water Chamber for Humidifier, Used With Positive Airway Pressure Device, Replacement, Each
// E0561 Humidifier, Non - heated, Used With Positive Airway Pressure Device
// E0562 Humidifier, Heated, Used With Positive Airway Pressure Device



//Hypoventilation ICD-10-CM Codes
code "G47.3": 'G47.3' from "ICD-10-CM"
code "G47.31": 'G47.31' from "ICD-10-CM"
code "G47.32": 'G47.32' from "ICD-10-CM"
code "G47.33": 'G47.33' from "ICD-10-CM"  //Obstructive Sleep Apnea (adult)
code "G47.34": 'G47.34' from "ICD-10-CM"
code "G47.35": 'G47.35' from "ICD-10-CM"
code "G47.36": 'G47.36' from "ICD-10-CM"
code "G47.37": 'G47.37' from "ICD-10-CM"
code "G47.39": 'G47.39' from "ICD-10-CM"

//Hypoventilation Disorder SNOMED-CT Codes
code "31515003" : '31515003' from "SNOMED-CT"
code "429456008": '429456008' from "SNOMED-CT"
code "426542005": '426542005' from "SNOMED-CT"
code "724509002": '724509002' from "SNOMED-CT"

//Hypoventilation Finding SNOMED-CT Codes
code "37608008": '37608008' from "SNOMED-CT"
code "15993004": '15993004' from "SNOMED-CT"
code "190966007": '190966007' from "SNOMED-CT"
code "39549008": '39549008' from "SNOMED-CT"
code "95611007": '95611007' from "SNOMED-CT"
code "405272003": '405272003' from "SNOMED-CT"



//Restrictive Lung Disease Disorder ICD-10-CM Codes
//  several related defined at https://www.icd10data.com/search?s=%22Restrictive%20Lung%20Disease%22
//  using this as placeholder for value set
code "G12.21": 'G12.21' from "ICD-10-CM"

//Restrictive Lung Disease Disorder SNOMED-CT Codes
//  several children defined at https://browser.ihtsdotools.org/?perspective=full&conceptId1=36485005&edition=MAIN/SNOMEDCT-US/2020-03-01&release=&languages=en
//  using this as placeholder for value set
code "36485005": '36485005' from "SNOMED-CT"



//Motor neuron disease ICD-10-CM Codes
//  several related defined at https://www.icd10data.com/ICD10CM/Codes/G00-G99/G10-G14/G12-/G12.20
//  using this as placeholder for value set
code "G12.20": 'G12.20' from "ICD-10-CM"

//Motor neuron disease SNOMED-CT Codes
//  several children defined at https://browser.ihtsdotools.org/?perspective=full&conceptId1=37340000&edition=MAIN/SNOMEDCT-US/2020-03-01&release=&languages=en
//  using this as placeholder for value set
code "37340000": '37340000' from "SNOMED-CT"



//Spinal muscular atrophy ICD-10-CM Codes
//  several related defined at https://www.icd10data.com/ICD10CM/Codes/G00-G99/G10-G14/G12-/G12.9
//  using this as placeholder for value set
code "G12.9": 'G12.9' from "ICD-10-CM"

//Spinal muscular atrophy SNOMED-CT Codes
//  several children defined at https://browser.ihtsdotools.org/?perspective=full&conceptId1=5262007&edition=MAIN/SNOMEDCT-US/2020-03-01&release=&languages=en
//  using this as placeholder for value set
code "5262007": '5262007' from "SNOMED-CT"



parameter device_request DeviceRequest


define "OSA_Codes": { "G47.33" }


context Patient

define Today: Today()


// coverage requirement info
define OsaDiagnosis:
  if exists(Confirmed(ActiveOrRecurring([Condition: "OSA_Codes"]))) then 'OSA' else 'null'


define OtherDiagnoses:
  distinct(flatten(
    [Condition] C
      let ICD10Codings:
        ((C.code.coding) CODING where CODING.system.value in {
          'http://hl7.org/fhir/sid/icd-10',
          'http://hl7.org/fhir/sid/icd-10-cm'
        }
        return CODING.code.value + ' - ' + CODING.display.value)
      where C.clinicalStatus.coding.code = 'active'
      and exists(ICD10Codings)
      return ICD10Codings
  ))



define DeviceRequestHcpcsCoding: singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define DeviceRequestDescription: 'HCPCS ' + "DeviceRequestHcpcsCoding".code.value + ' - ' + "DeviceRequestHcpcsCoding".display.value
define RadDeviceRequested:
  if "DeviceRequestHcpcsCoding".code.value = 'E0470' then 'E0470'
  else if  "DeviceRequestHcpcsCoding".code.value = 'E0471' then 'E0471'
  else 'null'

////////////////////////////// Taken from CDS Connect Commons for FHIR, could replace with r4 version of helper library
define function ActiveOrRecurring(CondList List<Condition>):
  CondList C where C.clinicalStatus.coding.code in {'active', 'relapse'}

define function ObservationLookBack(ObsList List<Observation>, LookBack System.Quantity):
  ObsList O
    let LookBackInterval: Interval[Now() - LookBack, Now()]
    where (cast O.effective as dateTime).value in LookBackInterval
      or NullSafeToInterval(cast O.effective as Period) overlaps LookBackInterval
      or FHIRHelpers."ToDateTime"(O.issued) in LookBackInterval

define function NullSafeToInterval(Pd FHIR.Period):
  if Pd is not null then Interval[Pd."start".value, Pd."end".value] else null

define function Verified(ObsList List<Observation>):
  ObsList O where O.status.value in {'final', 'amended'}

define function WithUnit(ObsList List<Observation>, Unit String):
  ObsList O where (cast O.value as Quantity).unit.value = Unit or (cast O.value as Quantity).code.value = Unit

define function HighestObservation(ObsList List<Observation>):
  Max(ObsList O return NullSafeToQuantity(cast O.value as Quantity))

define function Confirmed(CondList List<Condition>):
  CondList C where C.verificationStatus.coding.code = 'confirmed'

define function NullSafeToQuantity(Qty FHIR.Quantity):
  if Qty is not null then
    System.Quantity {
      value: Qty.value.value,
      unit: Coalesce(Qty.unit.value, Qty.code.value)
    }
  else null

define function LowestObservation(ObsList List<Observation>):
  Min(ObsList O return NullSafeToQuantity(cast O.value as Quantity))
