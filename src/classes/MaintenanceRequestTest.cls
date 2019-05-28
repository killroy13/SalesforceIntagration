@IsTest
public with sharing class MaintenanceRequestTest {

    private static final Integer COUNT = 3;

    @IsTest
    public static void updateWorkOrdersSuccessTest() {
        insert DataFactory.createTestCases(COUNT, 'Working', 'Electrical');
        insert DataFactory.createTestProducts(COUNT);
        List<Product2> selectedProduct2s = [SELECT Id FROM Product2];
        List<Case> selectedCasesList = [SELECT Id,Type,Status,IsClosed FROM Case];
        List<Work_Part__c> listWorkPartsToInsert = new List<Work_Part__c>();
        for (Integer i = 0; i < selectedCasesList.size(); i++) {
            listWorkPartsToInsert.add(DataFactory.createWorkPart(selectedProduct2s[i].Id, selectedCasesList[i].Id));
        }
        insert listWorkPartsToInsert;
        selectedCasesList[0].Status = 'Closed';
        update selectedCasesList;

        List<Case> selectedCasesAfterUpdate = [SELECT Id,Type,Status,IsClosed FROM Case];
        System.assertEquals(COUNT + 1, selectedCasesAfterUpdate.size());
    }

    @IsTest
    public static void updateWorkOrdersWithoutWorkPartsSuccessTest() {
        insert DataFactory.createTestCases(COUNT, 'Working', 'Electrical');
        List<Case> selectedCasesList = [SELECT Id,Type,Status,IsClosed FROM Case];

        selectedCasesList[0].Status = 'Closed';
        update selectedCasesList;

        List<Case> selectedCasesAfterUpdate = [SELECT Id,Type,Status,IsClosed FROM Case];
        System.assertEquals(COUNT + 1, selectedCasesAfterUpdate.size());
    }
}