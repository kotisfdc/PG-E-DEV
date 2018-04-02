@IsTest
public class JO_AlertControllerTest {
    @testSetup static void setupMethod()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'testUsr', Email='test123@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='sfdc23@gmail.com');
        insert u;
        
        
    }
    
    testMethod static void jobAlertsTest()
    {
        User u = [Select id from user where LastName='Testing'];
        system.runAs(u){
            Id configDashBoardRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
            Customer_Config__c cust1 = new Customer_Config__c();
            cust1.View_Name__c = 'Default';
            cust1.RecordTypeId = configDashBoardRecType;
            cust1.OwnerId = u.id;
            Insert cust1;
            
            Id configAlertRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Alert').getRecordTypeId();
            Customer_Config__c cust2 = new Customer_Config__c();
            cust2.View_Name__c = 'Alert';
            cust2.RecordTypeId = configAlertRecType;
            cust2.Json_Config__c = '{"viewfields":[{"alertType":"External","Id":"a2O2F0000006I2OUAU","isEnabled":true,"isHidden":true,"joAlertName":"New Application Call Customer","selectedUserPriority":"High","sortOrder":2,"sysPriority":"High"},{"alertType":"External","Id":"a2O2F0000006I3WUAU","isEnabled":true,"isHidden":true,"joAlertName":"Send Request for Additional Email","selectedUserPriority":"High","sortOrder":3,"sysPriority":"High"}]}'; 
            cust2.OwnerId = u.id;
            cust2.User_Config__c = cust1.id;
            Insert cust2;
            
            String queryString ='SELECT ID,Name,Notification_Order__r.Name, NotificationDesc__c,CreatedBy.Name,NotificationType__c,Customer__r.Name,NotifPriority__c,NotifPriorityType__c,NotifDate__c,Notification_Status__c FROM Notifications__c WHERE Id IN (SELECT Notifications__c FROM Alert__c ) ';
            String groupQueryString = 'SELECT Count (Name) recs FROM Notifications__c WHERE Id IN (SELECT Notifications__c FROM Alert__c ) ';
            Jo_Alert__c jOAlert = New Jo_Alert__c();
            jOAlert.Name = 'Inactive order start ZIOCF';
            jOAlert.Alert_Number__c = '1';
            joAlert.Alert_Type__c = 'External';
            joAlert.Alert_Is_Enabled__c =true;
            joAlert.Sort__c = 26;
            joAlert.Query_String__c =queryString;
            joAlert.Group_by_query__c = groupQueryString;
            Insert joAlert;
            
            List<String> contIds = new List<String>();
            contIds.add(u.id);
            String loggedInContact = u.id;
            
            JO_AlertController.getjobAlerts(contIds, loggedInContact, cust1);
            
            
            Customer_Config__c cust3 = new Customer_Config__c();
            cust3.View_Name__c = 'Default1';
            cust3.RecordTypeId = configDashBoardRecType;
            cust3.Json_Config__c = '{"viewfields":[{"alertType":"External","Id":"a2O2F0000006I2OUAU","isEnabled":true,"isHidden":true,"joAlertName":"New Application Call Customer","selectedUserPriority":"High","sortOrder":2,"sysPriority":"High"},{"alertType":"External","Id":"a2O2F0000006I3WUAU","isEnabled":true,"isHidden":true,"joAlertName":"Send Request for Additional Email","selectedUserPriority":"High","sortOrder":3,"sysPriority":"High"}]}'; 
            cust3.OwnerId = u.id;
            Insert cust3;
            
            JO_AlertController.getjobAlerts(contIds, loggedInContact, cust3); 
            
            Id notiRecType = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('AS').getRecordTypeId();        
            List<Notifications__c> notList = new List<Notifications__c>();
            Notifications__c not1 = new Notifications__c();
            not1.RecordTypeId = notiRecType;
            not1.Name = 'Test12345';
            not1.Notification_Status__c = 'SUBM';
            not1.OwnerId = u.id;
            notList.add(not1);
            Notifications__c not2 = new Notifications__c();
            not2.RecordTypeId = notiRecType;
            not2.Name = 'Notification two';
            not2.Notification_Status__c = 'SUBM';
            not2.OwnerId = u.id;
            notList.add(not2);
            insert notList;
            
            List<Order__c> orList = new List<Order__c>();
            Order__c ord = new Order__c();        
            ord.Name = 'Order one';
            ord.Notification_Order__c = not1.id;
            ord.OrderStatus__c = 'SUBM';
            orList.add(ord);
            Insert orList;
            
            List<Alert__c> lstAlerts = new  List<Alert__c>();
            Alert__c AlertwithNotif = New Alert__c();
            AlertwithNotif.Name = 'AlertWithNotification';
            AlertwithNotif.OwnerId = u.id; 
            AlertwithNotif.Alert_Close_Date__c = system.now();
            AlertwithNotif.Alert_Numbers__c = '1';
            AlertwithNotif.Is_Auto__c = true;
            AlertwithNotif.Notifications__c = not1.Id;
            lstAlerts.add(AlertwithNotif);
            
            Insert lstAlerts;
            
            String str = 'Open';
            String strQuery ='SELECT ID,Name,Status__c,Orders__c,orders__r.Name,Notifications__c,Notifications__r.Name FROM Alert__c where Status__c =:str';
            List<String> jbOwneIds = new List<String>();
            jbOwneIds.add(u.id);
            JO_AlertController.notificationQuery(strQuery,jbOwneIds);
            
        }
    }
}