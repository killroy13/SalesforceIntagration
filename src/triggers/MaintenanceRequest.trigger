trigger MaintenanceRequest on Case (before update, after update) {
    // call MaintenanceRequestHelper.updateWorkOrders
    if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            MaintenanceRequestHelper.updateWorkOrders(Trigger.oldMap, Trigger.newMap);
        }
    }
}