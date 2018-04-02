@IsTest
public class JO_CommunicationHistoryTest {
    
    @testSetup Static void SetupMethod()
    {
        
        Id notifRecType = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('OD').getRecordTypeId();
        Notifications__c notif = new Notifications__c();
        notif.Name = 'Test Notification';
        notif.RecordTypeId = notifRecType;
        Insert notif;
        
        
        Id OdRecType = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('E060').getRecordTypeId();
        Order__c ord = new Order__c();
        ord.Name ='Order';
        ord.RecordTypeId = OdRecType;
        ord.Notification_Order__c = notif.id;
        Insert ord;
        
        Order__c ord1 = new Order__c();
        ord1.Name = 'Sub Order';
        ord1.Parent_Order__c = ord.id;
        ord1.RecordTypeId = OdRecType;
        Insert ord1;
        
       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'test@abc.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Test Email');
        mail.setPlainTextBody('Test Body');
        mail.whatid = ord.id; 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
        // Id notifRecType = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('OD').getRecordTypeId();
        Notifications__c notif1 = new Notifications__c();
        notif1.Name = 'Notification2';
        notif1.RecordTypeId = notifRecType;
        Insert notif1;
        
    } 
    
    //if task id is Notification without orders
    testMethod static void getTaskTestWithNotifIdWithoutOrders()
    {
        
        Notifications__c notif = [Select id,name from Notifications__c where Name = 'Notification2'];  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'test@abc2.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Test Email');
        mail.setPlainTextBody('Test Body');
        mail.whatid = notif.id; 
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        String RecordId = notif.id;
        test.startTest();
        JO_CommunicationHistory.getTask(RecordId);
        test.stopTest();   
    }
    
    
    //if task id is Notification Id
    testMethod static void getTaskTestWithNotifId()
    {
        Notifications__c notif = [Select id,name from Notifications__c where Name = 'Test Notification'];  
        String RecordId = notif.id;
        test.startTest();
        JO_CommunicationHistory.getTask(RecordId);
        test.stopTest();   
    }
    
    testMethod static void getTaskTestWithOrderId()
    {
        
        Order__c ord = [Select id,name from Order__c where Name = 'Order'];
        String RecordId = ord.id;
        test.startTest();
        JO_CommunicationHistory.getTask(RecordId);
        test.stopTest();   
    } 
  
}