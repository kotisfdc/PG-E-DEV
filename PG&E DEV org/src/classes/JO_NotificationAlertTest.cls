@isTest
public class JO_NotificationAlertTest {
    @testSetup static void methodName() {
        
        //Create Notifications 
        Id notifRecordType = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('OD').getRecordTypeId();
        Notifications__c notification = new Notifications__c();
        notification.Name = 'Test Notifications';
        notification.RecordTypeId = notifRecordType;
        Insert notification;
        
        Id orderRecordType = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('E060').getRecordTypeId();
        Order__c ord = new Order__c();
        ord.Name = 'Test Order';
        ord.RecordTypeId = orderRecordType;
        ord.Notification_Order__c = notification.id;
        Insert ord; 
        
        Order__c subOrd = new Order__c();
        subOrd.Name = 'Sub Order';
        subOrd.RecordTypeId = orderRecordType;
        subOrd.Parent_Order__c = Ord.id;
        subOrd.Notification_Order__c = notification.id;
        Insert subOrd; 
        
        
        
        Alert__c alert = new Alert__c();
        alert.Name = 'Test Alert';
        alert.Notifications__c = notification.id;
        alert.Status__c = 'Close';
        alert.Orders__c = ord.id;
        Insert alert; 
        
        Id notifRecordType1 = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('OD').getRecordTypeId();
        Notifications__c notification1 = new Notifications__c();
        notification1.Name = 'NotificationswithoutOrder';
        notification1.RecordTypeId = notifRecordType1;
        Insert notification1;
        
        Alert__c alert2 = new Alert__c();
        alert2.Name = 'Test Alert2';
        alert2.Notifications__c = notification1.id;
        alert2.Status__c = 'Close';
        Insert alert2; 
        
        
        Id orderRecordType2 = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('E060').getRecordTypeId();
        Order__c ord3 = new Order__c();
        ord3.Name = 'Test Order2';
        ord3.RecordTypeId = orderRecordType2;
        Insert ord3;
        
         Alert__c alert3 = new Alert__c();
        alert3.Name = 'Test Alert2';
        alert3.Orders__c = ord3.id;
        alert3.Status__c = 'Close';
        Insert alert3; 
        
    }
    //test method for wrapper class
    testMethod static void NotifOrderAlertTest()
    {
        Alert__c alert = [Select id,name,Status__c from Alert__c where name='Test Alert'];
        DateTime alertCreatedDate = System.now().AddDays(-1);
        DateTime alertCloseDate   = System.now().AddDays(+1);
        Notifications__c notif = [Select id,RecordTypeId from Notifications__c where name='Test Notifications'];
        String RecordId = alert.id;
        String ObjectId =  notif.id; //order id or suborder id also use here
        String name = alert.name; 
        //DateTime alertCreatedDate = alertCreatedDate; 
       // DateTime alertCloseDate = alertCloseDate;
        String cycleTime = '10';
        String Status = alert.Status__c; 
        String recordTypeName = notif.RecordTypeId;
        Id rec=Id.valueof(ObjectId);
        String objctName = rec.getSObjectType().getDescribe().getLabel(); 
        Boolean IsAuto = true;
        JO_NotificationAlert.NotifOrderAlert wrap = new JO_NotificationAlert.NotifOrderAlert(RecordId,ObjectId,name,alertCreatedDate,alertCloseDate,cycleTime,Status,recordTypeName,objctName,IsAuto);
        
    }  
 
    testMethod static void AlertsTestWithNotifID(){
        
        Notifications__c notif = [Select id,Name from Notifications__c where Name = 'Test Notifications'];
        String RecId = notif.id;
        test.startTest();
        JO_NotificationAlert.getAlerts(RecId);
        test.stopTest();
        
    }  
    testMethod static void AlertsTestWithoutOrders(){
        
        Notifications__c notif = [Select id from Notifications__c where Name ='NotificationswithoutOrder'];
        system.debug('NotificationswithoutOrder===>'+notif);
        String RecId = notif.id;
        test.startTest();
        JO_NotificationAlert.getAlerts(RecId);
        test.stopTest();
        
    }     
    testMethod static void AlertsTestWithOrderId(){
        
        Order__c od = [Select id,Name from Order__c where Name = 'Test Order'];
        String RecId = od.id;
        test.startTest();
        JO_NotificationAlert.getAlerts(RecId);
        test.stopTest();

    }  
       
     testMethod static void selectedRecordsTest(){
        
        Notifications__c notif = [Select id,Name from Notifications__c where Name ='Test Notifications'];
        List<String> lststr = new  List<String>();
        List<Alert__c> lstAlert = [Select id from Alert__c where Notifications__c =:notif.id];
        for(Alert__c a:lstAlert)
        {
            lststr.add(a.Id);   
        }
        
        test.startTest();
        JO_NotificationAlert.getSelectedRecords(lststr);
        test.stopTest();
     }
    
   
}