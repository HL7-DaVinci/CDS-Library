package org.hl7.davinci.ruleutils;

import org.junit.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.opencds.cqf.cql.data.DataProvider;
import org.opencds.cqf.cql.execution.Context;

import ca.uhn.fhir.context.FhirContext;

import org.cqframework.cql.elm.execution.Library;
import org.hl7.fhir.r4.model.Bundle;

public class CqlUtilsTest {

    private static String cql;
    private static String elm;
    private static Bundle bundle;
    private static FhirContext fhirContext;
    private static ModelResolver modelResolver;

    @BeforeClass
    public static void setup() throws IOException {
        fhirContext = FhirContext.forR4();
        modelResolver = new ModelResolver(fhirContext);

        Path modulesFolder = Paths.get("src/test/resources");
        Path fixture = modulesFolder.resolve("RuleUtilsTest.cql");
        cql = new String(Files.readAllBytes(fixture));

        fixture = modulesFolder.resolve("RuleUtilsTest.elm.xml");
        elm = new String(Files.readAllBytes(fixture));

        fixture = modulesFolder.resolve("bundle.json");
        String bundleStr = new String(Files.readAllBytes(fixture));
        bundle = (Bundle) fhirContext.newJsonParser().parseResource(bundleStr);
    }

    @Test
    public void cqlToElmTest() {
        String convertedElm = CqlUtils.cqlToElm(cql, CqlUtils.RequestType.XML);
        Assert.assertNotNull(convertedElm);
        Assert.assertTrue(convertedElm.equals(elm));
    }

    @Test
    public void readFileTest() {
        String fileName = "../HospitalBeds/R4/files/HospitalBedsRule-0.1.0.cql";
        String content = CqlUtils.readFile(fileName);
        Assert.assertNotNull(content);
    }

    @Test
    public void createLibraryTest() {
        Library library = CqlUtils.createLibrary(elm);
        Assert.assertNotNull(library);
        Assert.assertNotNull(library.getStatements());
    }

    @Test
    public void createDataProviderTest() {
        DataProvider dataProvider = CqlUtils.createDataProvider(bundle, fhirContext, modelResolver);
        Assert.assertNotNull(dataProvider);
    }

    @Test
    public void executeTest() {
        Context context = CqlUtils.createBundleContextFromCql(cql, bundle, fhirContext, modelResolver);
        Object value = CqlUtils.executeExpression(context, "BUNDLE_TEST");
        Assert.assertNotNull(value);
        Assert.assertTrue((boolean) value);
    }

    @Test
    public void executeTestPreconverted() {
        Context context = CqlUtils.createBundleContextFromElm(elm, bundle, fhirContext, modelResolver);
        Object value = CqlUtils.executeExpression(context, "BUNDLE_TEST");
        Assert.assertNotNull(value);
        Assert.assertTrue((boolean) value);
    }
}