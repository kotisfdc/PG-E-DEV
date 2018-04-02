@istest
public class JO_PortfolioTest {
    @testSetup static void methodName() {
        //Retrieve the Profile 
        id id1 = userinfo.getProfileId();
        Profile p = [SELECT Id,Name FROM Profile WHERE id=:id1];
        //system.debug('Profile===>'+p);
        
        //Craete User
        User u = new User();
        u.Alias = 'stand';
        u.Email = 'test12345@abc.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Test';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = p.id;
        u.TimeZoneSidKey ='America/Los_Angeles';
        u.Username = 'abc12345@test.com';
        u.FederationIdentifier = 'Test12345';
        Insert u;  
        
        
        Notifications__c notif = new Notifications__c();
        notif.Name = 'Test12345';
        notif.NotificationType__c = 'AS';
        notif.OwnerId = u.id;
        
        Insert notif;
        
        Order__c ord = new Order__c();
        ord.Name ='Order';
        ord.Notification_Order__c = notif.id;
        ord.ownerId = u.id;
        Insert ord;
        
        
        Id UserRecordType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Admin Views').getRecordTypeId();
        
        Customer_Config__c PDb = new Customer_Config__c();
        PDb.Is_Active__c = true;
        PDb.Is_Default__c = true;
        PDb.Is_Admin__c = true;
        PDb.Sort_Order__c = 1;
        PDb.RecordTypeId = UserRecordType;
        PDb.OwnerId = u.id;
        Pdb.View_Name__c = 'Default';
        Pdb.Json_Config__c ='{"viewfields":[{"visible":true,"order":3,"fieldType":"STRING","fieldApiLabel":"Notification Name","fieldAPI":"Name","customLabel":"Notification Name"}]}';
        Insert PDb;
        
        Customer_Config__c CDb = new Customer_Config__c();
        CDb.User_Config__c = PDb.Id;
        CDb.Is_Active__c = true;
        CDb.Is_Admin__c = false;
        CDb.Is_Default__c = false;
        CDb.Sort_Order__c = 1;
        CDb.RecordTypeId = UserRecordType;
        CDb.OwnerId = u.id;
        CDb.View_Name__c = 'child1';
        CDb.Json_Config__c ='{"viewfields":[{"visible":true,"order":3,"fieldType":"STRING","fieldApiLabel":"Notification Name","fieldAPI":"Name","customLabel":"Notification Name"}]}';
        
        Insert CDb;
        
        Id viewRecordType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Portfolio').getRecordTypeId();
        
        Customer_Config__c CDb1 = new Customer_Config__c();
        CDb1.User_Config__c = PDb.Id;
        CDb1.Is_Active__c = true;
        CDb1.Is_Admin__c = false;
        CDb1.Is_Default__c = false;
        CDb1.Sort_Order__c = 1; 
        CDb1.RecordTypeId = viewRecordType;
        CDb1.OwnerId = u.id;
        CDb1.View_Name__c = 'child2';
        CDb1.Json_Config__c ='{"viewfields":[{"visible":true,"order":3,"fieldType":"STRING","fieldApiLabel":"Notification Name","fieldAPI":"Name","customLabel":"Notification Name"}]}';
        Insert CDb1;
        
    }
    //with notification Id
    testMethod static void fetchNotificationsTest(){
        Order__c od = [Select id,Name,ownerId From Order__c where Name='Order'];
        
        
        Notifications__c notif = [Select id,Name,ownerId From Notifications__c where NotificationType__c='AS'];
        String sObjectName ='Notifications__c';
        String criteriafield = notif.OwnerId;
        
        User u = [Select id,FederationIdentifier from User where LastName = 'Test' limit 1];
        List<String> conatcIds = new List<String>();
        conatcIds.add(u.id);
        
        Customer_Config__c userConfigRec = [Select id from Customer_Config__c where View_Name__c = 'Default'];
        
        string fieldNameJson='["Name","NotificationType__c","Notification_Order__r.Name","NotificationDesc__c","Owner.Name","Notification_Order__r.OrderStatus__c","Notification_Status__c","NotifPriorityType__c"]';
        JO_Wrapper.JO_IdWrapper idWrapperStr = new JO_Wrapper.JO_IdWrapper();
        idWrapperStr.notifyNo = new List<String>();
        idWrapperStr.notifyNo.add(notif.Name);
        JO_Portfolio.fetchNotifications(sObjectName, criteriafield, conatcIds, userConfigRec, fieldNameJson, Json.serialize(idWrapperStr));
        
        
        
        JO_Wrapper.JO_IdWrapper idWrapperStr1 = new JO_Wrapper.JO_IdWrapper();
        idWrapperStr1.notificationIds = new set<Id>();
        idWrapperStr1.notificationIds.add(notif.id);
        idWrapperStr1.orderIds = new set<Id>();
        idWrapperStr1.orderIds.add(od.id);
        JO_Portfolio.fetchNotifications(sObjectName, criteriafield, conatcIds, userConfigRec, fieldNameJson, Json.serialize(idWrapperStr1));
        
        
        
    }
    
    testMethod static void notificationRecTest(){
        
        Notifications__c notif = [Select id,Name,ownerId From Notifications__c where NotificationType__c='AS'];
        String sObjectName ='Notifications__c';
        String criteriafield = notif.OwnerId;
        
        User u = [Select id,FederationIdentifier from User where LastName = 'Test' limit 1];
        List<String> conatcIds = new List<String>();
        conatcIds.add(u.id);
        
        Customer_Config__c userConfigRec = [Select id from Customer_Config__c where View_Name__c = 'Default'];
        
        string fieldNameJson='["Name","NotificationType__c","Notification_Order__r.Name","NotificationDesc__c","Owner.Name","Notification_Order__r.OrderStatus__c","Notification_Status__c","NotifPriorityType__c"]';
        list<String> notificationIds = new list<String>(); 
        notificationIds.add(notif.id);
        
        JO_Portfolio.getNotificationRec(sObjectName, criteriafield, conatcIds, userConfigRec, fieldNameJson, notificationIds);
        
        
    }
    
    testMethod static void getnotificationRecTest(){
        User u = [Select id,FederationIdentifier from User where LastName = 'Test' limit 1];
        list<String> jobOwners = new list<String>();
        jobOwners.add(u.id);
        
        Customer_Config__c userConfigRec = [Select id from Customer_Config__c where View_Name__c = 'Default'];
        
        JO_Wrapper.PortfolioFields pff = new JO_Wrapper.PortfolioFields('name', 'Notification Name', 'Notification Name', FALSE, 1.0);
        List<JO_Wrapper.PortfolioFields> pffl = new List<JO_Wrapper.PortfolioFields>();
        pffl.add(pff);
        JO_Wrapper.PortfolioFieldsList flist = new JO_Wrapper.PortfolioFieldsList(pffl);
        
        system.debug('pffl===>'+pffl);
        List<Notifications__c> lstNotif = JO_Portfolio.getNotificationRec(jobOwners, userConfigRec, flist);
        system.debug('lstNotifications=====>'+lstNotif);
    }
    
    
    testMethod static void portfolioTableTest()
    {
        string queryStr = 'Select id,name From Notifications__c'; 
        User u = [Select id,FederationIdentifier from User where LastName = 'Test' limit 1];
        List<String> conatcIds  = new  List<String>();
        conatcIds.add(u.id);
        JO_Portfolio.getPortfolioTable(queryStr, conatcIds);
        JO_Portfolio.GetALLTabConfig();
    }
    
    
    
    testMethod static void deleteViewRecTest()
    {
        User u = [Select id from User where LastName = 'Test' limit 1];
        List<String> contactIds  = new  List<String>();
        contactIds.add(u.id); 
        Customer_Config__c userConfigRec = [Select id from Customer_Config__c where View_Name__c = 'Default'];
        string viewId = userConfigRec.id;
        
        JO_Portfolio.deleteViewRec(viewId);
    }
    
    
    /*  testMethod static void portfolioViewsTest(){
Customer_Config__c userConfigRec = [Select id from Customer_Config__c where View_Name__c = 'child2'];
JO_Portfolio.GetPortfolioViews(userConfigRec);

}

*/
    //getViewList
    testMethod static void getViewListTest()
    {
        User u = [Select id,FederationIdentifier from User where LastName = 'Test' limit 1];
        List<String> contactIds  = new  List<String>();
        contactIds.add(u.id); 
        Customer_Config__c userConfigRec = [Select id from Customer_Config__c where View_Name__c = 'Default'];
        string viewId = userConfigRec.id;
        
        JO_Portfolio.getViewList(contactIds, viewId, userConfigRec);
    }
    
    testMethod static void aLLTabConfigTest()
    {
        Customer_Config__c adminRec= JO_Portfolio.GetALLTabConfig();
        system.debug('adminRec====>'+adminRec);
    }
    
    
    testMethod static void generateConfigRecTest()
    {
        User u = [Select id,FederationIdentifier from User where LastName = 'Test' limit 1];
        List<String> contactIds  = new  List<String>();
        contactIds.add(u.id); 
        Customer_Config__c userConfigRec = [Select id from Customer_Config__c where View_Name__c='default'];
        
        JO_Portfolio.generateConfigRec(contactIds, userConfigRec);
        
    }
    
    testMethod static void editViewTest()
    {
        User u = [Select id,FederationIdentifier from User where LastName = 'Test' limit 1];
        String contactId = u.id;
        String jsonstr='{"viewfields":[{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"Notification Name","fieldAPI":"Name","customLabel":"Notification Name1"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"Type","fieldAPI":"NotificationType__c","customLabel":"Type"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZNotify","fieldAPI":"Name","customLabel":"ZNotification"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"Order","fieldAPI":"Notification_Order__c","customLabel":"Order"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZOrder","fieldAPI":"Notification_Order__c","customLabel":"ZOrder"},{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"NOTIFICATION DESCRIPTION","fieldAPI":"NotificationDesc__c","customLabel":"Notification Description"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"CUSTOMER","fieldAPI":"Customer__c","customLabel":"Customer"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"NOTIFICATION STATUS","fieldAPI":"Notification_Status__c","customLabel":"Notification Status"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"PRIORITY TYPE","fieldAPI":"NotifPriorityType__c","customLabel":"Priority Type"}]}';       
        
    
        JO_Portfolio.editView(contactId, jsonstr);
    }
    
    testMethod static void saveViewTest()
    {
        User u = [Select id,FederationIdentifier from User where LastName = 'Test' limit 1];
        String contactId = u.id;
        Customer_Config__c userConfigRec = [Select id,View_Name__c,Is_Admin__c,Is_Default__c,Is_Active__c,Json_Config__c,Sort_Order__c from Customer_Config__c where View_Name__c='default'];
        string viewId = string.valueOf(userConfigRec.id);
        string viewName = userConfigRec.View_Name__c;
        Decimal sortOrd = userConfigRec.Sort_Order__c;
        
        string jsons='{"count": 1,"dashboardId":"viewId","isActive": true,"isAdmin": true,"isDefault": true,"sortOrder": 1,"viewName":"viewName","viewfields":[{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"Notification Name","fieldAPI":"Name","customLabel":"Notification Name1"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"Type","fieldAPI":"NotificationType__c","customLabel":"Type"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZNotify","fieldAPI":"Name","customLabel":"ZNotification"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"Order","fieldAPI":"Notification_Order__c","customLabel":"Order"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZOrder","fieldAPI":"Notification_Order__c","customLabel":"ZOrder"},{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"NOTIFICATION DESCRIPTION","fieldAPI":"NotificationDesc__c","customLabel":"Notification Description"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"CUSTOMER","fieldAPI":"Customer__c","customLabel":"Customer"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"NOTIFICATION STATUS","fieldAPI":"Notification_Status__c","customLabel":"Notification Status"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"PRIORITY TYPE","fieldAPI":"NotifPriorityType__c","customLabel":"Priority Type"}]}';       

        JO_Portfolio.saveView(contactId, userConfigRec, jsons);
    }
    
    
}