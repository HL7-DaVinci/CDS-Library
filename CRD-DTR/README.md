# CDS-Library/CRD-DTR
This folder stores the "rule" files necessary to make the [Coverage Requirements Discovery (CRD)](https://github.com/HL7-DaVinci/CRD) and [Documentation Templates and Rules (DTR)](https://github.com/HL7-DaVinci/dtr) use cases work. These use cases are being developed as part of the [Da Vinci Project](http://www.hl7.org/about/davinci/index.cfm?ref=common) within the [HL7 Standards Organization](http://www.hl7.org/).

## File Layout
The files must be stored in the following structure:

	topic/
		TopicMetadata.json
		fhirVersion/
			resources/
				Library-fhirVersion-topicPrepopulation.json
				Questionnaire-fhirVersion-topic.json
			files/
				topicRule-version.cql
				topicPrepopulation-version.cql
	shared/
		fhirVersion/
			resource/
				Library-fhirVersino-FHIRHelpers-version.json
			files/
				FHIRHelpers-version.cql

[example](HomeOxygenTherapy/):

	HomeOxygenTherapy/
		TopicMetadata.json
		R4/
			resources/
				Library-R4-HomeOxygenTherapyPrepopulation.json
				Questionnaire-R4-HomeOxygenTherapy.json
			files/
				HomeOxygenTherapyRule-0.1.0.cql
				HomeOxygenTherapyPrepopulation-0.0.1.cql
	shared/
		fhirVersion/
			resource/
				Library-R4-FHIRHelpers-4.0.0.json
			files/
				FHIRHelpers-4.0.0.cql

## TopicMetadata.json
The contents of the TopicMetadata.json file should look like the following:

	{
	    "topic": "Topic",
	    "mappings": [
	        {
	            "codeSystem": "CodeSystem1",
	            "codes": [
	                "code1", "code2", "code3", "code4", "code5"
	            ]
	        },
	        {
	            "codeSystem": "CodeSystem2",
	            "codes": [
	                "code1", "code2", "code3", "code4", "code5"
	            ]
	        }
	    ],
	    "payers": [
	        "Payer"
	    ],
	    "fhirVersions": [
	        "STU3", "R4"
	    ]
	}

[example](HomeOxygenTherapy/TopicMetadata.json):

	{
	    "topic": "HomeOxygenTherapy",
	    "mappings": [
	        {
	            "codeSystem": "hcpcs",
	            "codes": [
	                "E0424", "E0431", "E0433", "E0434", "E0439", "E0441", "E0442", "E0443", "E0444", "E1390", "E1391", "E1392", "K0738"
	            ]
	        }
	    ],
	    "payers": [
	        "cms"
	    ],
	    "fhirVersions": [
	        "STU3", "R4"
	    ]
	}
