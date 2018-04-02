@isTest
public class CreateAlert3DailyBatchTest {
    testMethod Static void createAlert3DailyTest()
    {
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
         User user = new User(Alias = 'testUsr', Email='abc@gmail.com', 
                             EmailEncodingKey='UTF-8', LastName='TestSFDC', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='abc@gmail.com');
        
        AlertCreationDailyBatch__mdt fetchalert3Data;    
        fetchalert3Data = [select id,MasterLabel,DeveloperName,Alert_Name__c,Alert_Numbers__c,Alert_Status__c,Email_Status__c,Email_Subject__c,Task_Code__c,Number_of_Days__c,
                           Task_Record_Type_Name__c from AlertCreationDailyBatch__mdt where DeveloperName=:Label.CreateAlert3DailyBatch];
        
        EmailMessage mail = new EmailMessage();
        mail.Status = fetchalert3Data.Email_Status__c;
        mail.Subject = fetchalert3Data.Email_Subject__c;
        mail.Incoming = true;
        Insert mail;
       test.isRunningTest();

        system.debug('lastmodified date::'+mail.LastModifiedDate);
        
        Alert__c alerts = new Alert__c();
        alerts.Name = fetchalert3Data.Alert_Name__c;
        alerts.Alert_Numbers__c =fetchalert3Data.Alert_Numbers__c;
        alerts.Status__c = fetchalert3Data.Alert_Status__c;
        Insert alerts;
        
        Test.startTest();
        CreateAlert3DailyBatch obj = new CreateAlert3DailyBatch();
        DataBase.executeBatch(obj);
        Test.stopTest();
    }
}