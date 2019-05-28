public class MaintenanceRequestHelper {

//    private static final String TYPE_REPAIR = 'Repair';
    private static final String TYPE_ROUTINE_MAINTENANCE = 'Routine Maintenance';
    private static final String STATUS_CLOSED = 'Closed';
    private static final String STATUS_WORKING = 'Working';
    private static final String SUBJECT = 'Routine Maintenance';

    public static void updateWorkOrders(Map<Id, Case> maintenanceRequestsOld, Map<Id, Case> maintenanceRequestsNew) {
        List<Case> casesWithChangedStatus =  filterByStatus(maintenanceRequestsNew.values(), maintenanceRequestsOld, STATUS_CLOSED);

        // filter all cases that are of type TYPE_REPAIR or TYPE_ROUTINE_MAINTENANCE
        //Set<String> types = new Set<String>{TYPE_REPAIR, TYPE_ROUTINE_MAINTENANCE};
        //List<Case> filteredCases = filterByType(casesWithChangedStatus, types);

        List<Case> newCasesToInsert = createNewCases(casesWithChangedStatus);

        insert newCasesToInsert;
    }

    private static Date calculateDate(List<Work_Part__c> incomingDetailList) {
        if (incomingDetailList.isEmpty()) {
            return Date.today();
        }
        Decimal minCycle = incomingDetailList[0].Equipment__r.Maintenance_Cycle__c;
        for (Work_Part__c workPart : incomingDetailList) {
            minCycle = Math.min(minCycle, workPart.Equipment__r.Maintenance_Cycle__c);
        }
        return Date.today().addDays(Integer.valueOf(minCycle));
    }

    private static List<Case> createNewCases(List<Case> incomingCases) {
        List<Case> resultCases = new List<Case>();
        Map<Id, List<Work_Part__c>> mapWorkPartsByCaseIds = getWorkPartsByCaseId(new Map<Id, Case>(incomingCases).keySet() );
        for (Case aCase : incomingCases) {
            Case caseToInsert = new Case(
                    Date_Due__c = calculateDate(mapWorkPartsByCaseIds.get(aCase.Id)),
                    Vehicle__c = aCase.Vehicle__c,
                    Equipment__c = aCase.Equipment__c,
                    Subject = SUBJECT,
                    Date_Reported__c = System.today(),
                    Status = STATUS_WORKING,
                    Type = TYPE_ROUTINE_MAINTENANCE
            );
            resultCases.add(caseToInsert);
        }
        return resultCases;
    }

    private static Map<Id, List<Work_Part__c>> getWorkPartsByCaseId (Set<Id> casesIds){
        Map<Id, List<Work_Part__c>> result = new Map<Id, List<Work_Part__c>>();
        for (Case aCase : [SELECT Id,(SELECT Id,Name,Equipment__c,Equipment__r.Maintenance_Cycle__c,Maintenance_Request__c,Quantity__c FROM Work_Parts__r) FROM Case WHERE Id IN :casesIds]) {
            result.put(aCase.Id, aCase.Work_Parts__r);
        }
        return result;
    }

    private static List<Case> filterByStatus(List<Case> incomingNewCases, Map<Id, Case> oldCasesByIds, String status) {
        List<Case> resultCases = new List<Case>();
        for (Case aCase : incomingNewCases) {
            if (aCase.Status == status && oldCasesByIds.get(aCase.Id).Status != aCase.Status) {
                resultCases.add(aCase);
            }
        }
        return resultCases;
    }

//    private static List<Case> filterByType(List<Case> cases, Set<String> types) {
//        List<Case> filtered = new List<Case>();
//        for (Case c : cases) {
//            if (types.contains(c.Type)) {
//                filtered.add(c);
//            }
//        }
//        return filtered;
//    }
}