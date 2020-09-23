package org.hl7.davinci.ruleutils;

import java.util.Calendar;

import org.hl7.fhir.r4.model.*;
import org.opencds.cqf.cql.model.FhirModelResolver;

import ca.uhn.fhir.context.FhirContext;
import ca.uhn.fhir.context.FhirVersionEnum;

/**
 * This file is modified from the cql-engine-fhir
 * org.opencds.cqf.cql.model.R4FhirModelResolver The R4FhirModelResolver creates
 * a new fhir context and does not allow for passing one in
 * 
 * https://github.com/DBCG/cql_engine/blob/master/cql-engine-fhir/src/main/java/org/opencds/cqf/cql/model/R4FhirModelResolver.java
 */
public class ModelResolver extends
        FhirModelResolver<Base, BaseDateTimeType, TimeType, SimpleQuantity, IdType, Resource, Enumeration<?>, EnumFactory<?>> {

    public ModelResolver(FhirContext fhirContext) {
        super(fhirContext);
        this.setPackageName("org.hl7.fhir.r4.model");
        if (fhirContext.getVersion().getVersion() != FhirVersionEnum.R4) {
            throw new IllegalArgumentException("The supplied context is not configured for R4");
        }
    }

    protected void initialize() {
        // HAPI has some bugs where it's missing annotations on certain types. This
        // patches that.
        this.fhirContext.registerCustomType(AnnotatedUuidType.class);

        // The context loads Resources on demand which can cause resolution to fail in
        // certain cases
        // This forces all Resource types to be loaded.
        for (Enumerations.ResourceType type : Enumerations.ResourceType.values()) {
            // These are abstract types that should never be resolved directly.
            switch (type) {
                case DOMAINRESOURCE:
                case RESOURCE:
                case NULL:
                    continue;
                default:
            }

            this.fhirContext.getResourceDefinition(type.toCode());
        }
    }

    @Override
    protected Object resolveProperty(Object target, String path) {
        // This is kind of a hack to get around contained resources - HAPI doesn't have
        // ResourceContainer type for STU3
        if (target instanceof Resource && ((Resource) target).fhirType().equals(path)) {
            return target;
        }

        return super.resolveProperty(target, path);
    }

    protected Boolean equalsDeep(Base left, Base right) {
        return left.equalsDeep(right);
    }

    protected SimpleQuantity castToSimpleQuantity(Base base) {
        return base.castToSimpleQuantity(base);
    }

    protected Calendar getCalendar(BaseDateTimeType dateTime) {
        return dateTime.getValueAsCalendar();
    }

    protected Integer getCalendarConstant(BaseDateTimeType dateTime) {
        return dateTime.getPrecision().getCalendarConstant();
    }

    protected String timeToString(TimeType time) {
        return time.getValue();
    }

    protected String idToString(IdType id) {
        return id.getIdPart();
    }

    protected String getResourceType(Resource resource) {
        return resource.fhirType();
    }

    protected Enumeration<?> enumConstructor(EnumFactory<?> factory) {
        return new Enumeration<>(factory);
    }

    protected Boolean enumChecker(Object object) {
        return object instanceof Enumeration;
    }

    protected Class<?> enumFactoryTypeGetter(Enumeration<?> enumeration) {
        return enumeration.getEnumFactory().getClass();
    }

    @Override
    public Class<?> resolveType(String typeName) {

        // TODO: Might be able to patch some of these by registering custom types in
        // HAPI.
        switch (typeName) {
            case "ConfidentialityClassification":
                typeName = "Composition$DocumentConfidentiality";
                break;
            case "ContractResourceStatusCodes":
                typeName = "Contract$ContractStatus";
                break;
            case "EventStatus":
                typeName = "Procedure$ProcedureStatus";
                break;
            case "FinancialResourceStatusCodes":
                typeName = "ClaimResponse$ClaimResponseStatus";
                break;
            case "SampledDataDataType":
                typeName = "StringType";
                break;
            case "ClaimProcessingCodes":
                typeName = "ClaimResponse$RemittanceOutcome";
                break;
            case "vConfidentialityClassification":
                typeName = "Composition$DocumentConfidentiality";
                break;
            case "ContractResourcePublicationStatusCodes":
                typeName = "Contract$ContractPublicationStatus";
                break;
        }

        return super.resolveType(typeName);
    }
}