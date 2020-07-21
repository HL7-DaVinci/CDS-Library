package org.hl7.davinci.ruleutils;

import java.io.IOException;
import java.io.StringReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;

import javax.xml.bind.JAXBException;

import org.opencds.cqf.cql.data.CompositeDataProvider;
import org.opencds.cqf.cql.data.DataProvider;
import org.opencds.cqf.cql.execution.Context;
import org.opencds.cqf.cql.execution.CqlLibraryReader;
import org.opencds.cqf.cql.model.ModelResolver;

import ca.uhn.fhir.context.FhirContext;

import org.cqframework.cql.cql2elm.CqlTranslator;
import org.cqframework.cql.cql2elm.CqlTranslatorException;
import org.cqframework.cql.cql2elm.FhirLibrarySourceProvider;
import org.cqframework.cql.cql2elm.LibraryManager;
import org.cqframework.cql.cql2elm.ModelManager;
import org.cqframework.cql.elm.execution.ExpressionDef;
import org.cqframework.cql.elm.execution.Library;
import org.cqframework.cql.elm.tracking.TrackBack;
import org.hl7.fhir.r4.model.Bundle;

public class CqlUtils {

    public enum RequestType {
        XML, JSON
    }

    /**
     * Create the CQL Context for a given elm file and a Bundle
     * 
     * @param elm           - the contents of the elm
     * @param bundle        - the resources to add to the context
     * @param fhirContext   - fhir context
     * @param modelResolver - model resolver
     * @return CQL context for the library and bundle
     */
    public static Context createBundleContextFromElm(String elm, Bundle bundle, FhirContext fhirContext,
            ModelResolver modelResolver) {
        Library library = createLibrary(elm);
        Context context = new Context(library);
        context.registerDataProvider("http://hl7.org/fhir",
                CqlUtils.createDataProvider(bundle, fhirContext, modelResolver));

        return context;
    }

    /**
     * Create the CQL Context for a given cql file and a Bundle
     * 
     * @param cql           - the contents of the cql
     * @param bundle        - the resources to add to the context
     * @param fhirContext   - fhir context
     * @param modelResolver - model resolver
     * @return CQL context for the library and bundle
     */
    public static Context createBundleContextFromCql(String cql, Bundle bundle, FhirContext fhirContext,
            ModelResolver modelResolver) {
        String elm = cqlToElm(cql, RequestType.XML);
        Library library = createLibrary(elm);
        Context context = new Context(library);
        context.registerDataProvider("http://hl7.org/fhir",
                CqlUtils.createDataProvider(bundle, fhirContext, modelResolver));

        return context;
    }

    /**
     * Convert CQL string into ELM string
     * 
     * @param cql         - the cql to string to translate
     * @param requestType - the format of the ELM (json or xml)
     * @return string in json or xml for the elm
     */
    public static String cqlToElm(String cql, RequestType requestType) {
        ModelManager modelManager = new ModelManager();
        LibraryManager libraryManager = new LibraryManager(modelManager);

        libraryManager.getLibrarySourceLoader().registerProvider(new FhirLibrarySourceProvider());
        CqlTranslator translator = CqlTranslator.fromText(cql, modelManager, libraryManager);
        if (translator.getErrors().size() > 0) {
            ArrayList<String> errors = new ArrayList<>();
            for (CqlTranslatorException error : translator.getErrors()) {
                TrackBack tb = error.getLocator();
                String lines = tb == null ? "[n/a]"
                        : String.format("[%d:%d, %d:%d]", tb.getStartLine(), tb.getStartChar(), tb.getEndLine(),
                                tb.getEndChar());
                errors.add(lines + error.getMessage());
            }
            throw new IllegalArgumentException(errors.toString());
        }

        return requestType == RequestType.JSON ? translator.toJson() : translator.toXml();
    }

    /**
     * Execute a CQL expression
     * 
     * @param context        - the cql context
     * @param expressionName - the name of the expression
     * @return the raw value reuturned by the execution engine
     */
    public static Object executeExpression(Context context, String expressionName) {
        ExpressionDef expression = context.resolveExpressionRef(expressionName);
        Object rawValue = null;
        synchronized (ExpressionDef.class) {
            rawValue = expression.evaluate(context);
            System.out.println("CqlUtils::executeExpression:" + expressionName + ":" + rawValue.toString());
        }

        return rawValue;
    }

    /**
     * Read in the contents of a file from the CDS Library and return the contents
     * 
     * @param path - the name of the file
     * @return string contents of the file or null if the file does not exist
     */
    public static String readFile(String path) {
        String content = null;
        try {
            content = new String(Files.readAllBytes(Paths.get(path)));
        } catch (Exception e) {
            System.out.println("CqlUtils::readFile:File does not exist:" + path);
        }
        return content;
    }

    /**
     * Helper method to create the Library for the constructor
     * 
     * @param elm - the elm to create the library from
     * @return Library or null
     */
    public static Library createLibrary(String elm) {
        Library library = null;
        try {
            synchronized (CqlLibraryReader.class) {
                library = CqlLibraryReader.read(new StringReader(elm));
            }
        } catch (IOException | JAXBException e) {
            System.out.println("PriorAuthRule::createLibrary:exception reading library\n" + e);
        }
        return library;
    }

    /**
     * Create a DataProvider from the request Bundle to execute the CQL against
     * 
     * @param bundle - the request bundle for the CQL
     * @return a FHIR DataProvider
     */
    public static DataProvider createDataProvider(Bundle bundle, FhirContext fhirContext, ModelResolver modelResolver) {
        BundleRetrieveProvider bundleRetrieveProvider = new BundleRetrieveProvider(fhirContext, bundle);
        return new CompositeDataProvider(modelResolver, bundleRetrieveProvider);
    }
}