/* 
 * This class can be safely deleted from your org. 
 * It was only used to ensure 100% test coverage
 * for the managed package installation.
 */

@IsTest
private class InstallationTests {

    @TestSetup
    static void setupData() {

		Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.Type = 'Customer - Direct';
        insert testAcct;
        
        Opportunity testOpp = new Opportunity(); 
        testOpp.Name = 'Test Opportunity';
        testOpp.AccountId = testAcct.Id;
        testOpp.Type = 'New Project';
        testOpp.CloseDate = System.today();
        testOpp.StageName = 'Negotiation/Review';
        testOpp.Amount = 500000;
        insert testOpp;
    }

    @IsTest
    static void testProjectTrigger() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Project__c p = new Project__c();
        p.Opportunity__c = opp.Id;
        insert p;
    }
    
    @IsTest
	static void testProjectCalloutServiceForInstall() {
	    ProjectCalloutService.postOpportunityToPMS(new List<Id>());
	}

}