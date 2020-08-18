library DTRFunctions version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

context Patient

define function LowestObservation(ObsList List<Observation>):
  Min(ObsList O return FHIRHelpers.ToQuantity(O.value as Quantity))

// TODO: Fix data in test-ehr so proper CDS Commons version can be used
define function ActiveOrRecurring(CondList List<Condition>):
  CondList C where C.clinicalStatus.coding.code in {'active', 'relapse'}

// TODO: Fix data in test-ehr so proper CDS Commons version can be used
define function Confirmed(CondList List<Condition>):
  CondList C where C.verificationStatus.coding.code = 'confirmed'
