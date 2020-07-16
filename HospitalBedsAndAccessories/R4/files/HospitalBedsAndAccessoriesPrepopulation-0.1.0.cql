library HospitalBedsAndAccessoriesPrepopulation  version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ICD-10-CM": 'http://hl7.org/fhir/sid/icd-10-cm'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "FixedHeightBedsCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.50'
valueset "VariableHeightBedsCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.51'
valueset "SemiElectricBedsCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.52'
valueset "TrapezeCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.55'
valueset "BedcradleCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.56'
valueset "SafetyrailCodes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.57'

//Body Weight code
code "29463-7": '29463-7' from "LOINC"

parameter device_request DeviceRequest

context Patient

define "BodyWeight_Codes": { "29463-7" }

define "BodyWeight": HighestObservation(WithUnit(Verified(ObservationLookBack([Observation: "BodyWeight_Codes"], 6 months)), '[lb_av]'))

define "RecentEncounters": EncounterLookBack([Encounter], 6 months)
define "EncounterList": ConvertEncounterDetails("RecentEncounters")
define function ConvertEncounterDetails(EncounterList List<Encounter>):
  distinct(
    flatten(
      EncounterList E
        let EncounterCodings:
          (E.type.coding) CODING
          return Tuple {
            code: CODING.code.value,
            system: CODING.system.value,
            display: CODING.display.value,
            periodStart: E.period.start.value,
            type: 'encounter'
          }
        
        return EncounterCodings
    )
  )

define "DeviceRequestHcpcsCoding": singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs')

define "DeviceRequestDescription": 'HCPCS ' + "DeviceRequestHcpcsCoding".code.value + ' - ' + "DeviceRequestHcpcsCoding".display.value
define "DeviceRequested":
  if "DeviceRequestHcpcsCoding".code.value = 'E0250' then 'E0250'
  else if "DeviceRequestHcpcsCoding".code.value = 'E0251' then 'E0251'
  else 'null'

define "FixedHeightBedsOrdered": "DeviceRequestHcpcsCoding" in "FixedHeightBedsCodes"
define "VariableHeightBedsOrdered": "DeviceRequestHcpcsCoding" in "VariableHeightBedsCodes"
define "SemiElectricBedsOrdered": "DeviceRequestHcpcsCoding" in "SemiElectricBedsCodes"
define "TrapezeOrdered": "DeviceRequestHcpcsCoding" in "TrapezeCodes"
define "BedcradleOrdered": "DeviceRequestHcpcsCoding" in "BedcradleCodes"
define "SafetyrailOrdered": "DeviceRequestHcpcsCoding" in "SafetyrailCodes"

define function EncounterLookBack(EncounterList List<Encounter>, LookBack System.Quantity):
  EncounterList E
    let LookBackInterval: Interval[Now() - LookBack, Now()]
    where (cast E.period.start as dateTime).value in LookBackInterval
      or NullSafeToInterval(cast E.period as Period) overlaps LookBackInterval

////////////////////////////// Taken from CDS Connect Commons for FHIR, could replace with r4 version of helper library
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


