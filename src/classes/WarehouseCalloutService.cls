public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    @Future(Callout = true)
    public static void runWarehouseEquipmentSync() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'text-xml');
        response = http.send(request);
        List<WarehouseEquipment> warehouseEquipmentList = new WarehouseEquipment().parse(response.getBody());
        List<Product2> productsToUpsert = new List<Product2>();

        for (WarehouseEquipment whrEquip : warehouseEquipmentList) {
            Product2 newProduct = new Product2(Warehouse_SKU__c = whrEquip.id,
                    Replacement_Part__c = true,
                    Cost__c = whrEquip.cost,
                    Current_Inventory__c = whrEquip.quantity,
                    Lifespan_Months__c = whrEquip.lifespan,
                    Maintenance_Cycle__c = whrEquip.maintenanceperiod,
                    Name = whrEquip.name
            );
            productsToUpsert.add(newProduct);
        }
        upsert productsToUpsert;
    }

    public class WarehouseEquipment {
        public String name;
        public Integer quantity;
        public Integer maintenanceperiod;
        public Integer lifespan;
        public Integer cost;
        public String id;
        public List<WarehouseEquipment> parse(String json) {
            json.replace('"id":', '"_id ":');
            return (List<WarehouseEquipment>) System.JSON.deserialize(json, List<WarehouseEquipment>.class);
        }
    }
}

/*
List<CronTrigger> listCronTrigger = [
    SELECT Id, CronExpression, EndTime, NextFireTime, OwnerId,PreviousFireTime, StartTime, State, TimesTriggered, TimeZoneSidKey
    from CronTrigger
    where State = 'Waiting' OR State = 'Running'
];
System.debug('No of jobs: '+listCronTrigger.size());
if (listCronTrigger.size() > 0){
    for (Integer i = 0; i < listCronTrigger.size(); i++){
        System.abortJob(listCronTrigger[i].Id);
        System.debug('Job details ::'+String.valueOf(listCronTrigger[i]));
    }
}
*/