@isTest
public class JO_JobDBAppControllerTest {
    //This testmethod added By Challa KoteswaraRao;
    testMethod static void userInfoTest()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'testUsr', Email='abc@test.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='sfdc@12345.com');
        insert testUser; 
       
        system.runAs(testUser)
        {
            Contact con=new Contact();
            con.LastName='Test';
            //con.Related_User__c=testUser.id;
            insert con;
            
            test.startTest();
            JO_JobDBAppController.getUserInfo();
            test.stopTest();  
        }
        
    }
}