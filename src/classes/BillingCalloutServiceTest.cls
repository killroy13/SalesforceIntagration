@IsTest
private class BillingCalloutServiceTest {

    @TestSetup
    public static void setupData() {
        ServiceCredentials__c newServiceCredentials = new ServiceCredentials__c();
        newServiceCredentials.Name = 'BillingServiceCredential';
        newServiceCredentials.Username__c = 'TestingPurpose';
        newServiceCredentials.Password__c = 'TestingPurpose1';
        insert newServiceCredentials;
        List<Account> accountsToInsert = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account newAccount = new Account();
            newAccount.Name = 'Test data ' + i;
            accountsToInsert.add(newAccount);
        }
        insert accountsToInsert;
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
        // Iterating over accounts, to prepare the opportunities that will be inserted
        for (Account acc : accountsToInsert) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.CloseDate = Date.today();
            newOpportunity.Name = 'Test Opportunity ' + acc.Name;
            newOpportunity.AccountId = acc.Id;
            newOpportunity.Amount = 100000;
            newOpportunity.StageName = 'Prospecting';
            opportunitiesToInsert.add(newOpportunity);
        }
        insert opportunitiesToInsert;
        List<Project__c> projectsToInsert = new List<Project__c>();
        for (Opportunity opp : opportunitiesToInsert) {
            Project__c project = new Project__c();
            project.Name = 'TestProj' + opp.Name;
            project.Billable_Amount__c = 1000;
            project.ProjectRef__c = 'TestRef ' + opp.Name;
            project.Status__c = 'Running';
            project.Opportunity__c = opp.Id;
            projectsToInsert.add(project);
        }
        insert projectsToInsert;
    }

    @IsTest static void testCalloutSuccess() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Test.startTest();
        // Holds lists of records that will be updated
        List<Project__c> projectsBefore = [SELECT Status__c, Id FROM Project__c];
        for (Project__c project : projectsBefore) {
            project.Status__c = 'Billable';
        }
        update projectsBefore;
        Test.stopTest();
        // Confirming that records were updated
        for (Project__c updatedProject : [SELECT Status__c FROM Project__c]) {
            System.assertEquals('Billed', updatedProject.Status__c);
        }
    }

    @IsTest static void testCalloutFailure() {
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        Test.startTest();
        // Holds lists of records that will be updated
        List<Project__c> projectsBefore = [SELECT Status__c, Id FROM Project__c];
        for (Project__c project : projectsBefore) {
            project.Status__c = 'Running';
        }
        update projectsBefore;
        Test.stopTest();
        // Confirming that records were updated
        for (Project__c updatedProject : [SELECT Status__c, Id FROM Project__c]) {
            System.assertEquals('Running', updatedProject.Status__c);
        }
    }
}