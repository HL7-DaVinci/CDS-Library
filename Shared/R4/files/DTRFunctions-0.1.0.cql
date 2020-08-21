library DTRFunctions version '0.1.0'
using FHIR version '4.0.0'
include FHIRHelpers version '4.0.0' called FHIRHelpers

context Patient

define function LowestObservation(ObsList List<Observation>):
  Min(ObsList O return FHIRHelpers.ToQuantity(O.value as Quantity))
