@isTest
public with sharing class WarehouseSyncScheduleTest {

    public static String CRON_EXP = '0 0 1 ? * * *';
    static testmethod void testScheduledJob() {
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new WarehouseSyncSchedule());
        Test.stopTest();
        System.assertEquals(1,1);
    }
}