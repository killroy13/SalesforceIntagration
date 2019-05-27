public class ProjectCalloutService {

    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> opportunityId) {
        System.enqueueJob(new QueueablePMSCall(opportunityId[0]));
    }

    @Future(Callout=true)
    public static void postToPMS(Id opportunityId) {
        List <Opportunity> opportunity = [SELECT Id,Name,StageName,Account.Name,CloseDate,Amount FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ProjectService');
        OpportunityWrapper opportunityFromJSON = new OpportunityWrapper();
        opportunityFromJSON.opportunityId = opportunityId;
        opportunityFromJSON.opportunityName = opportunity[0].Name;
        opportunityFromJSON.accountName = opportunity[0].Account.Name;
        opportunityFromJSON.closeDate = opportunity[0].CloseDate.year() + '-' + opportunity[0].CloseDate.month() + '-' + opportunity[0].CloseDate.day();
        opportunityFromJSON.amount = opportunity[0].Amount.format();
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('token',ServiceTokens__c.getValues('ProjectServiceToken').Token__c);
        req.setBody(JSON.serialize(opportunityFromJSON));
        req.setMethod('POST');
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 201) {
            opportunity[0].StageName = 'Submitted Project';
        } else {
            opportunity[0].StageName = 'Resubmit Project';
        }
        update opportunity[0];
    }

    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        private String serviceToken;
        private String jsonInput;
        private String Id;
        public QueueablePMSCall(Id opportunityId) {
            this.serviceToken = serviceToken;
            this.jsonInput = jsonInput;
            this.Id = opportunityId;
        }
        public void execute(QueueableContext context) {
            postToPMS(Id);
        }
    }
}