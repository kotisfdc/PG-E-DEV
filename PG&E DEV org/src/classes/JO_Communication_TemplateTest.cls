@istest
public class JO_Communication_TemplateTest {
    
    @testSetup static void alertConfigControllerSetup(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'testUsr', Email='test123@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='sfdc23@gmail.com');
        insert testUser; 
        Notifications__c notif=new Notifications__c();
        notif.NotificationType__c = 'AS';
        insert notif;  
        
        Task ts=new Task();
        ts.WhatId=notif.Id;
        ts.Description='New';
        insert ts;
        
        Email_Template_Master__c emp=new Email_Template_Master__c();
        emp.Email_Template__c='Template C';
        emp.Business_Name__c='Thanks';
        emp.Sort_Order__c=2;
        emp.Object_Type__c='Notification';
        emp.Is_Active__c =true;
        insert emp;
        
        EmailMessage emg=new EmailMessage();
        emg.MessageDate=datetime.newInstance(2017, 12, 11, 13, 3, 0);
        emg.Subject='Template C';
        emg.RelatedToId=notif.ID;
        emg.Status='3';
        emg.MessageIdentifier='test';
        
        insert emg;
     
        Id ordRecType = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('E070').getRecordTypeId();
        Order__c ord=new Order__c();
        ord.name='new';
        ord.Notification_Order__c=notif.Name;
        ord.RecordTypeId = ordRecType;
        insert ord;
        
     
    
    }
    testMethod static void JO_Communication_TemplateTestMethod() {
        
        Notifications__c notif = [Select id from Notifications__c where NotificationType__c = 'AS'];
        JO_Communication_Template.getEmailtemplate(notif.Id);
        
        
    }
    
    testMethod static void JO_Communication_TemplateTestMethod1() {
        Notifications__c notif = [Select id from Notifications__c where NotificationType__c = 'AS'];
        Order__c ord = [Select id from Order__c where name='new'];
        
        Task ts=new Task();
        ts.WhatId=ord.Id;
        ts.Description='New';
        insert ts;
        
        Email_Template_Master__c emp1 = [Select id from Email_Template_Master__c where Business_Name__c='Thanks'];
        emp1.Email_Template__c='Template M';
        emp1.Object_Type__c='order';
        upsert emp1;
        
        EmailMessage emg = [select id from EmailMessage where MessageIdentifier='test'];
        emg.Subject='Template C';
        upsert emg;
        JO_Communication_Template.getEmailtemplate(ord.Id);
        
    }
}