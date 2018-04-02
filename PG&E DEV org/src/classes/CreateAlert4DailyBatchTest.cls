@isTest
public class CreateAlert4DailyBatchTest {
    testMethod Static void createAlert4DailyTest()
    {
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
         User user = new User(Alias = 'testUsr', Email='abc@gmail.com', 
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='testsfdc@gmail.com');
        insert user; 
        
        AlertCreationDailyBatch__mdt fetchalert4Data;    
        fetchalert4Data = [select id,MasterLabel,DeveloperName,Alert_Name__c,Alert_Numbers__c,Alert_Status__c,Email_Status__c,Email_Subject__c,Task_Code__c,Number_of_Days__c,
                           Task_Record_Type_Name__c from AlertCreationDailyBatch__mdt where DeveloperName=:Label.CreateAlert4DailyBatch];
        
        EmailMessage mail = new EmailMessage();
        mail.Status = fetchalert4Data.Email_Status__c;
        mail.Subject = fetchalert4Data.Email_Subject__c;
        mail.Incoming = true;
        //mail.RelatedToId='';
        Insert mail;
        
        Alert__c alerts = new Alert__c();
        alerts.Name = fetchalert4Data.Alert_Name__c;
        alerts.Alert_Numbers__c =fetchalert4Data.Alert_Numbers__c;
        alerts.Status__c = fetchalert4Data.Alert_Status__c;
        Insert alerts;
        
        Test.startTest();
        CreateAlert4DailyBatch obj = new CreateAlert4DailyBatch();
        DataBase.executeBatch(obj);
        Test.stopTest();
    }
    
    
    
}