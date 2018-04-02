@isTest
public class JO_UserEmailToTest {
    @testSetup static void methodName() 
    {
        
        Notifications__c notif = new Notifications__c();
        notif.Name = 'Test!2345';
        insert notif;
        
        Address__c addr = new Address__c();
        addr.AddressType__c = 'AP';
        //addr.Name = 'Test';
        addr.LastName__c = 'Test LastName';
        addr.EmailAddress__c = 'abc@xyz.com';
        addr.Notifications__c = notif.id;
        Insert addr;
    }
    testMethod static void LoogedInContactTest()
    {
        JO_UserEmailTo.getLoogedInContact();  
    }
    testMethod static void allJobOwnersTest()
    {
        
        Notifications__c addrs = [Select id from Notifications__c where Name = 'Test!2345'];
        String recId = addrs.id;
        boolean includejobcustomer = true;
        JO_UserEmailTo.getAllJobOwners(includejobcustomer, recId);  
    }
    testMethod static void loggedUserTest()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'testUsr', Email='abc@test.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='sfdc@12345.com');
        insert testUser; 
        System.runAs(testUser){
            Contact con = new Contact();
            con.lastName = 'test';
            con.OwnerId = testUser.id;
            insert con;
            
            JO_UserEmailTo.getloggedUser(); 
        }
        
        
        
    } 
}