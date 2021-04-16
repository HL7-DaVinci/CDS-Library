library Hypoxemia version '1.0.0'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MCGHelpers version '1.0.0' called MCGHelpers

//codesystem "LOINC": 'http://loinc.org'

valueset "Hypoxemia Valueset": 'rc-hypoxemia'
valueset "Supplemental Oxygen Dependence Valueset": 'rc-supplementalOxygenDependence'
valueset "Oxygen Saturation Percent": 'ro-arterial-oxygen-saturation-percent'
valueset "Arterial Partial Pressure Oxygen": 'ro-arterial-partial-pressure-oxygen-mmHg'
valueset "Oxygen Delivery L per min": 'ro-oxygenDelivery-L-per-min'

//code "Arterial Partial Pressure Oxygen": '2703-7' from "LOINC"
//code "Oxygen Saturation Percent": '2708-6' from "LOINC"

context Patient

define "FHIR Context":
  [Observation]
    union [Condition]

define "Worsening of pre-existing hypoxemia that persists despite observation care treatment, with oxygen treatment needs performable only in acute inpatient setting":
  "Hypoxemia"
    or "Supplemental Oxygen Dependence"
    or "Most Recent Oxygen Delivery L per min" > 0

define "New-onset hypoxemia that persists despite observation care treatment":
  "Hypoxemia in Past 24 hours"
    or (
      ("O2 Saturation" < 90)
        and ("O2 Saturation" > 20)
        and not IsNull("Baseline O2 Saturation")
        and not ("Baseline O2 Saturation" < 90)
    )
    or (
      ("Arterial PO2" < 60)
        and ("Arterial PO2" > 20)
        and not IsNull("Baseline Arterial PO2")
        and not ("Baseline Arterial PO2" < 60)
    )
    // TODO: need to complete other O2 Saturation units
    /* or ((paO2kPa_new < 8.0) and (paO2kPa_new > 2.0))
    and not (paO2kPa_baseline < 8.0) */

define "All Conditions" : [Condition]

define "All Procedures": [Procedure]

define "Hypoxemia Conditions":
  ["Condition": "Hypoxemia Valueset"]

define "Hypoxemia":
  exists(
    MCGHelpers.FilterToActiveConditions(
      "Hypoxemia Conditions"
    )
  )

define "Hypoxemia in Past 24 hours":
  exists(
    MCGHelpers.FilterToActiveConditions(
      MCGHelpers.RecentConditions("Hypoxemia Conditions", 24 hours)
    )
  )

define "Supplemental Oxygen Dependence Conditions":
  ["Condition": "Supplemental Oxygen Dependence Valueset"]

define "Supplemental Oxygen Dependence":
  exists(
    MCGHelpers.FilterToActiveConditions(
      "Supplemental Oxygen Dependence Conditions"
    )
  )

define "Oxygen Delivery L per min Observations":
  ["Observation": "Oxygen Delivery L per min"]

define "Recent Oxygen Delivery L per min Observations":
  MCGHelpers.RecentObservations("Oxygen Delivery L per min Observations", 2 hours)

define "Most Recent Oxygen Delivery L per min":
  MCGHelpers.MostRecentObservation("Recent Oxygen Delivery L per min Observations").value.value as decimal

define "O2 Saturation Observations":
  ["Observation": "Oxygen Saturation Percent"]

define "Recent O2 Saturation Observations":
  MCGHelpers.RecentObservations("O2 Saturation Observations", 24 hours)

define "O2 Saturation":
  MCGHelpers.MinObservation("Recent O2 Saturation Observations").value.value as decimal

define "Baseline O2 Saturation Observations":
  MCGHelpers.DateRangeObservations("O2 Saturation Observations", 1 year, 7 days)

define "Baseline O2 Saturation":
  MCGHelpers.MostRecentObservation("Baseline O2 Saturation Observations").value.value as decimal

// NOTE: Assumes mmHg units, need to account for kPa units
define "Arterial PO2 Observations":
  ["Observation": "Arterial Partial Pressure Oxygen"]

define "Recent Arterial PO2 Observations":
  MCGHelpers.RecentObservations("Arterial PO2 Observations", 24 hours)

define "Arterial PO2":
  MCGHelpers.MinObservation("Recent Arterial PO2 Observations").value.value as decimal

define "Baseline Arterial PO2 Observations":
  MCGHelpers.DateRangeObservations("Arterial PO2 Observations", 1 year, 7 days)

define "Baseline Arterial PO2":
  MCGHelpers.MostRecentObservation("Baseline Arterial PO2 Observations").value.value as decimal
