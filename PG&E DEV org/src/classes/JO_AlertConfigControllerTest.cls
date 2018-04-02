@isTest
private class JO_AlertConfigControllerTest
{
    @testSetup static void alertConfigControllerSetup(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'testUsr', Email='test123@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='sfdc23@gmail.com');
        insert testUser;               
        
    }
    
    testMethod Static void alertConfigTest()
    {
        User u = [Select id from user where LastName='Testing'];
        system.runAs(u){
            Id configDashRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
            Customer_Config__c cust = new Customer_Config__c(); 
            cust.OwnerId = u.Id;        
            cust.View_Name__c = 'Default Dashboard';
            cust.RecordTypeId = configDashRecType;
            insert cust;        
            Id configAlertRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Alert').getRecordTypeId();
            Customer_Config__c cust1 = new Customer_Config__c(); 
            cust1.OwnerId = u.Id;        
            cust1.View_Name__c = 'Alert Configurations';
            cust1.RecordTypeId = configAlertRecType;
            cust1.Json_Config__c = '{"viewfields":[{"alertType":"External","Id":"a2O2F0000006I2OUAU","isEnabled":true,"isHidden":true,"joAlertName":"New Application Call Customer","selectedUserPriority":"High","sortOrder":2,"sysPriority":"High"},{"alertType":"External","Id":"a2O2F0000006I3WUAU","isEnabled":true,"isHidden":true,"joAlertName":"Send Request for Additional Email","selectedUserPriority":"High","sortOrder":3,"sysPriority":"High"}]}'; 
            cust1.User_Config__c= cust.Id;       
            insert cust1;
            
            Customer_Config__c cust2 = new Customer_Config__c();        
            cust2.RecordTypeId = configAlertRecType;
            cust2.Json_Config__c = '{"viewfields":[{"alertType":"External","Id":"a2O2F0000006I2OUAU","isEnabled":true,"isHidden":true,"joAlertName":"New Application Call Customer","selectedUserPriority":"High","sortOrder":2,"sysPriority":"High"},{"alertType":"External","Id":"a2O2F0000006I3WUAU","isEnabled":true,"isHidden":true,"joAlertName":"Send Request for Additional Email","selectedUserPriority":"High","sortOrder":3,"sysPriority":"High"}]}'; 
            cust2.User_Config__c= cust.Id;       
            insert cust2;
            
            
            Jo_Alert__c jOAlert = New Jo_Alert__c();
            jOAlert.Name = 'Inactive order start ZIOCF';
            joAlert.Alert_Type__c = 'External';
            joAlert.Alert_Is_Enabled__c =true;
            joAlert.Sort__c = 26;
            jOAlert.Priority__c = 'High';
            jOAlert.Alert_Number__c ='1';
            Insert joAlert;
            
            String contactId = u.id;
            List<JO_Wrapper.JO_AlertConfigWrapper> wrapList = JO_AlertConfigController.getAlertWrapper(contactId, cust1);
            system.debug('wrapList===>'+wrapList);
            String jsonData = JSON.serialize(wrapList);
            system.debug('jsonData===>'+jsonData);
            JO_AlertConfigController.saveUserConfigForAlert(jsonData,cust1,contactId);
            
            String sObjectName = 'Account';
            String picklistField = 'Rating';
            JO_AlertConfigController.getPrioritylists(sObjectName, picklistField);
            
        }
    }
    
  
    
}