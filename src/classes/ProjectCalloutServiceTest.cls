@IsTest
private class ProjectCalloutServiceTest {
    //Implement mock callout tests here

    @TestSetup static void setupData() {
        List<Opportunity> listOpportunitiesToInsert = new List<Opportunity>();
        for (Integer i = 0; i < 2; i++) {
            Opportunity opportunity = new Opportunity(
                    Name = 'Corporation ' + i,
                    Type = 'New Project',
                    Amount = 1000,
                    CloseDate = System.today(),
                    StageName = 'Prospecting'
            );
            listOpportunitiesToInsert.add(opportunity);
        }
        insert listOpportunitiesToInsert;

        ServiceTokens__c token = new ServiceTokens__c();
        token.Name = 'ProjectServiceToken';
        token.Token__c = 'b4bb566d-846d-0266ee4b7732';
        insert token;
    }

    @IsTest static void postOpportunityToPMSSuccess() {
        List<Opportunity> opportunitiesBefore = [SELECT Id,Name,StageName,Account.Name,Amount,CloseDate FROM Opportunity];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new ProjectCalloutServiceMock());
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{opportunitiesBefore[0].Id});
        ProjectCalloutService.postToPMS(opportunitiesBefore[0].Id);
        Test.stopTest();
        List<Opportunity> opportunitiesAfter = [SELECT Id, StageName,Name,Account.Name,Amount,CloseDate FROM Opportunity];
        System.assertEquals('Submitted Project', opportunitiesAfter.get(0).StageName);
    }

    @IsTest static void postOpportunityToPMSFail() {
        List<Opportunity> opportunitiesBefore = [SELECT Id,Name,StageName,Account.Name,Amount,CloseDate FROM Opportunity];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new ProjectCalloutServiceMockFailure());
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{opportunitiesBefore[1].Id});
        ProjectCalloutService.postToPMS(opportunitiesBefore[1].Id);
        Test.stopTest();
        List<Opportunity> opportunitiesAfter = [SELECT Id,StageName,Name,Account.Name,Amount,CloseDate FROM Opportunity];
        System.assertEquals('Resubmit Project', opportunitiesAfter.get(1).StageName);
    }
}