@istest
public class CreateAlert15SchedulerTest {
    public static testMethod void testschedule() {
        Test.StartTest();
        CreateAlert15Scheduler obj = new CreateAlert15Scheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test', sch, obj);
        Test.stopTest(); 

    }
    
}