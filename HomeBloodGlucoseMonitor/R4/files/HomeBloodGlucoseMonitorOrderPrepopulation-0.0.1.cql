library HomeBloodGlucoseMonitorOrderPrepopulation version '0.0.1'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers


codesystem "HCPCS": 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'


valueset "Diabetes Mellitus": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.35'
valueset "Insulin Medication": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1219.85'

code "Standard Monitor": 'E0607' from "HCPCS"

parameter device_request DeviceRequest

context Patient

define "DeviceRequestHcpcsCoding": singleton from (
  ((cast device_request.code as CodeableConcept).coding) coding
    where coding.system.value = 'https://bluebutton.cms.gov/resources/codesystem/hcpcs'
    return FHIRHelpers."ToCode"(coding))

define "MonitorType":
  if "DeviceRequestHcpcsCoding" ~ "Standard Monitor"
    then Code { code: 'Standard Monitor', display: 'Standard Monitor' }
    else Code { code: 'Monitor With Special Features', display: 'Monitor With Special Features' }

define "DiabetesDiagnosed": exists( [Condition: "Diabetes Mellitus"] )     

define "InsulinTreated":
  if exists([MedicationStatement: "Insulin Medication"])
    then Code { code: 'Insulin Treated', display: 'Insulin Treated' }
    else Code { code: 'Non-insulin Treated', display: 'Non-insulin Treated' }

////////////////////////////// Taken from CDS Connect Commons for FHIR, could replace with stu3 version of helper library
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



