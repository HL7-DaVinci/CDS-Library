# CDS-Library: Clinical Decision Support File Library
The CDS-Library stores common files necessary to make the [Coverage Requirements Discovery (CRD)](https://github.com/HL7-DaVinci/CRD), [Documentation Templates and Rules (DTR)](https://github.com/HL7-DaVinci/dtr) and [Prior Authorization Support (PAS)](https://github.com/HL7-DaVinci/prior-auth) use cases work. These use cases are being developed as part of the [Da Vinci Project](http://www.hl7.org/about/davinci/index.cfm?ref=common) within the [HL7 Standards Organization](http://www.hl7.org/).

## Foundry
Explore it yourself with [HL7 FHIR Foundry](https://foundry.hl7.org/products/6745a338-b5af-45a1-8f75-636414859059).

## CRD-DTR
The "rule" files necessary to make the [Coverage Requirements Discovery (CRD)](https://github.com/HL7-DaVinci/CRD) and [Documentation Templates and Rules (DTR)](https://github.com/HL7-DaVinci/dtr) use cases work. For more documentation on the file structure, click [here](https://github.com/HL7-DaVinci/CDS-Library/CRD-DTR#file-layout]).

## Examples
The "rule" files for CRD and DTR that were not created as part of the reference implementation. For more documentation on the file structure, click [here](https://github.com/HL7-DaVinci/CDS-Library/CRD-DTR#file-layout]).

To run the rule sets under the Examples folder with the test-ehr, you need to load the data for the rule sets from test-ehr repo by running the following command:
>gradle loadBundleResource 

## PriorAuth
Rules the [Prior Authorization Support (PAS)](https://github.com/HL7-DaVinci/prior-auth) reference implementation uses for deciding on the approval of a Claim.

## RuleUtils
A java library for helping to process CQL as well as converting CQL to ELM for execution.


## Questions and Contributions
Questions about the project can be asked in the [Da Vinci DTR stream on the FHIR Zulip Chat](https://chat.fhir.org/#narrow/stream/197320-Da-Vinci-DTR).

This project welcomes Pull Requests. Any issues identified with the RI should be submitted via the [GitHub issue tracker](https://github.com/HL7-DaVinci/CDS-Library/issues).

As of October 1, 2022, The Lantana Consulting Group is responsible for the management and maintenance of this Reference Implementation.
In addition to posting on FHIR Zulip Chat channel mentioned above you can contact [Corey Spears](mailto:corey.spears@lantanagroup.com) for questions or requests.
