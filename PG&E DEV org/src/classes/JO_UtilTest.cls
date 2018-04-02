@isTest
public class JO_UtilTest {
    
    testMethod static void UtilTestMethods()
    {
        // Setup test data
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        System.runAs(u) {
            Contact con=new Contact();
            con.LastName='Test';
           // con.Related_User__c=userinfo.getuserid();
            insert con;
            JO_Util.getLoggedInContact(u.id); 
            
            JO_Util.getLoggedInContact();
            String sObjectName = 'Notifications__c';
            String fieldName = 'Name';
            JO_Util.retrievePicklistDescribe(sObjectName, fieldName);
            String picklistField = 'Notification_Status__c';
            JO_Util.getPickListDescribe(sObjectName, picklistField);
            JO_Util.getFieldDescribe(sObjectName, fieldName);
            
            String recordTypeName = 'AS';
            JO_Util.getRecordTypeId(sObjectName, recordTypeName);
            
            Set<String> recordTypeNames = new Set<String>();
            recordTypeNames.add('AS');
            recordTypeNames.add('EC');
            recordTypeNames.add('ER');
            
            JO_Util.fetchRecordTypeIdList(sObjectName, recordTypeNames);
            
            Id dashrecordTypeId = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();         
            Customer_Config__c dashBoardRec = new Customer_Config__c();
            dashBoardRec.View_Name__c = 'DashBoradRecTest';
            dashBoardRec.Json_Config__c = 'Test JSON';
            dashBoardRec.Is_Active__c = true;
            dashBoardRec.Is_Admin__c = true;
            dashBoardRec.Is_Default__c = true;
            dashBoardRec.RecordTypeId = dashrecordTypeId;
            //dashBoardRec.Job_Owner__c = con.id;
            Insert dashBoardRec;
            
            Customer_Config__c CustConfig = new Customer_Config__c();
            CustConfig.View_Name__c = 'Test';
            CustConfig.Json_Config__c = 'SUBM,UNSC,APPR';
            CustConfig.Is_Active__c = true;
            CustConfig.Is_Admin__c = true;
            CustConfig.Is_Default__c = true;
            CustConfig.RecordTypeId = dashrecordTypeId;
            CustConfig.User_Config__c = dashBoardRec.Id;
           // CustConfig.Job_Owner__c = con.id;
            Insert CustConfig;
            
            String dashboardId = dashBoardRec.id;
            JO_Util.getDefaultDashboardId(dashboardId);
            
            JO_Util.GetJOPartition();
            
            List<String> CacheKeyNames = new List<String>();
            CacheKeyNames.add('Ok');
            CacheKeyNames.add('Cancel');
            JO_Util.ReleaseOrgCache(CacheKeyNames);
            
        }
        
    }
}