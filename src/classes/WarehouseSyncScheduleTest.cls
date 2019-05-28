@IsTest
public class WarehouseSyncScheduleTest {

    @IsTest static void testScheduler() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        String CRON_EXP = '0 0 0 1 1/1 ? *';
        Integer runDate = 1;

        Datetime firstRunTime = System.now();
        Datetime nextDateTime;

        if (firstRunTime.day() < runDate) {
            nextDateTime = firstRunTime;
        } else {
            nextDateTime = firstRunTime.addMonths(1);
        }

        Datetime nextRunTime = Datetime.newInstance(nextDateTime.year(), nextDateTime.month(), runDate);

        Test.startTest();
        WarehouseSyncSchedule warehouseSyncSchedule = new WarehouseSyncSchedule();
        String jobId = System.schedule('Test Scheduler', CRON_EXP, warehouseSyncSchedule);
        Test.stopTest();

        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        System.assertEquals(String.valueOf(nextRunTime), String.valueOf(ct.NextFireTime));
    }
}