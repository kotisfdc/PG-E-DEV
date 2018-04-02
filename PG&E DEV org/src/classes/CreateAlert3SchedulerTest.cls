@isTest
public class CreateAlert3SchedulerTest {
    public static testMethod void testschedule() {
        Test.StartTest();
        CreateAlert3Scheduler obj = new CreateAlert3Scheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test', sch, obj);
        Test.stopTest(); 

    }
    
}