
public with sharing class DataFactory {

    public static List<Case> createTestCases(Integer count, String type, String status) {
        List<Case> listCasesObj = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            Case aCase = new Case(
                    Status = status,
                    Type = type,
                    Subject = randomString(24)
            );
            listCasesObj.add(aCase);
        }
        return listCasesObj;
    }

    public static List<Product2> createTestProducts(Integer count) {
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < count; ++i) {
            products.add(new Product2(
                    Name = randomString(16),
                    Maintenance_Cycle__c = randomMaintenanceCycle(),
                    Replacement_Part__c = true
            ));
        }
        return products;
    }

    private static String randomString(Integer len) {
        Blob blobKey = Crypto.generateAesKey(192);
        String key = EncodingUtil.base64Encode(blobKey);
        return key.substring(0, len);
    }

    private static Integer randomMaintenanceCycle() {
        return Math.round(Math.random() * 100);
    }

    public static Work_Part__c createWorkPart(Id productId, Id caseId) {
        Work_Part__c workPart = new Work_Part__c(
                Quantity__c = randomQuantity(),
                Equipment__c = productId,
                Maintenance_Request__c = caseId
        );
        return workPart;
    }

    private static Integer randomQuantity() {
        return Math.round(Math.random() * 10);
    }

}


