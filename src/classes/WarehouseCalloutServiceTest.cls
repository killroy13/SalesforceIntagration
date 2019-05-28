@IsTest
private class WarehouseCalloutServiceTest {

    @IsTest
    static void warehouseServiceTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        List<Product2> productsToUpsert = [
                SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c,Maintenance_Cycle__c, Name
                FROM Product2
        ];
        System.assert(true, productsToUpsert.size() == 22);
    }
}