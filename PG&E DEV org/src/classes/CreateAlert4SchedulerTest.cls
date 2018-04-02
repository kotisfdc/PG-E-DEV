@isTest
public class CreateAlert4SchedulerTest {
    public static testMethod void testschedule() {
        Test.StartTest();
        CreateAlert4Scheduler obj = new CreateAlert4Scheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test', sch, obj);
        Test.stopTest(); 

    }
    
}