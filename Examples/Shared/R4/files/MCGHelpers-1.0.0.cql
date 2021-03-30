library MCGHelpers version '1.0.0'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "ConditionClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'
codesystem "ConditionVerificationStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-verification'


// Condition Clinical Status Codes - Consider value sets for these
code "active": 'active' from "ConditionClinicalStatusCodes"
code "recurrence": 'recurrence' from "ConditionClinicalStatusCodes"
code "relapse": 'relapse' from "ConditionClinicalStatusCodes"
code "inactive": 'inactive' from "ConditionClinicalStatusCodes"
code "remission": 'remission' from "ConditionClinicalStatusCodes"
code "resolved": 'resolved' from "ConditionClinicalStatusCodes"

// Condition Verification Status Codes - Consider value sets for these
code "unconfirmed": 'unconfirmed' from ConditionVerificationStatusCodes
code "provisional": 'provisional' from ConditionVerificationStatusCodes
code "differential": 'differential' from ConditionVerificationStatusCodes
code "confirmed": 'confirmed' from ConditionVerificationStatusCodes
code "refuted": 'refuted' from ConditionVerificationStatusCodes
code "entered-in-error": 'entered-in-error' from ConditionVerificationStatusCodes

context Patient

define "Current DateTime":
  //Now()
  //@2020-04-09T11:00:00.000-07:00
  @2020-03-28T12:00:00.000-06:00

define "Encounter Start DateTime":
  // TODO: Determine how to get this value
  @2020-01-01T08:00:00.000-06:00

define function "CalendarAgeInDaysAt"(BirthDateTime DateTime, AsOf DateTime):
	days between ToDate(BirthDateTime) and ToDate(AsOf)

define function "CalendarAgeInDays"(BirthDateTime DateTime):
	CalendarAgeInDaysAt(BirthDateTime, "Current DateTime")

define function "CalendarAgeInMonthsAt"(BirthDateTime DateTime, AsOf DateTime):
	months between ToDate(BirthDateTime) and ToDate(AsOf)

define function "CalendarAgeInMonths"(BirthDateTime DateTime):
	CalendarAgeInMonthsAt(BirthDateTime, "Current DateTime")

define function "CalendarAgeInYearsAt"(BirthDateTime DateTime, AsOf DateTime):
	years between ToDate(BirthDateTime) and ToDate(AsOf)

define function "CalendarAgeInYears"(BirthDateTime DateTime):
	CalendarAgeInYearsAt(BirthDateTime, "Current DateTime")

define function "GetPositiveIndications"(value List<System.Boolean>):
  value Indication
    where Indication = true
    return all Indication

define function "FilterToActiveConditions"(value List<FHIR.Condition>):
    value Condition
        where (
            FHIRHelpers.ToConcept(Condition.clinicalStatus) ~ "active"
                or Condition.clinicalStatus = null
        )
        and (
            FHIRHelpers.ToConcept(Condition.verificationStatus) ~ "confirmed"
                or Condition.verificationStatus = null
        )

define function "RecentObservations"(value List<FHIR.Observation>, quantity System.Quantity):
    DateRangeObservations(value, quantity, 0 hours)
    /* value Observation
        where Observation.effective as dateTime in
          Interval["Current DateTime" - quantity, "Current DateTime"] */

define function "DateRangeObservations"(value List<FHIR.Observation>, lowerQuantity System.Quantity, upperQuantity System.Quantity):
    value Observation
        where Observation.effective as dateTime in
          Interval["Current DateTime" - lowerQuantity, "Current DateTime" - upperQuantity]

define function "ObservationsDuringEncounter"(value List<FHIR.Observation>):
  value Observation
    where Observation.effective as dateTime in
      Interval["Encounter Start DateTime", "Current DateTime"]

define function "MostRecentObservation"(value List<FHIR.Observation>):
  Last(
    value Observation
      sort by (ToDate(effective as dateTime))
  )

define function "LeastRecentObservation"(value List<FHIR.Observation>):
  First(
    value Observation
      sort by (ToDate(effective as dateTime))
  )

define function "MinObservation"(value List<FHIR.Observation>):
  First(
    value Observation
      sort by ((value as Quantity).value)
  )

define function "MaxObservation"(value List<FHIR.Observation>):
  Last(
    value Observation
      sort by ((value as Quantity).value)
  )

define function "MinRecentObservation"(value List<FHIR.Observation>, quantity System.Quantity):
  MinObservation(RecentObservations(value, quantity))

define function "RecentConditions"(value List<FHIR.Condition>, quantity System.Quantity):
  value Condition
    where Condition.onset as dateTime in
      Interval["Current DateTime" - quantity, "Current DateTime"]
