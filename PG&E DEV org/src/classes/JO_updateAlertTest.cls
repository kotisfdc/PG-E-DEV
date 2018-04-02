@istest
public class JO_updateAlertTest {
   
     @testSetup static void setup() {
       Contact Cont = new Contact();
       Cont.LastName = 'TestContact';
       Insert Cont;
       
       List<Notifications__c> lstNotif = new List<Notifications__c>();
       Notifications__c notification = new Notifications__c();
       notification.Name = 'NotificationOne';
       //notification.Customer__c = Cont.id;
       //notification.Jb_Owner__c = Cont.id;
       lstNotif.add(notification);
       
       
       Notifications__c notification1 = new Notifications__c();
       notification1.Name = 'NotificationTwo';
       //notification1.Customer__c = Cont.id;
       //notification1.Jb_Owner__c = Cont.id;
       lstNotif.add(notification1);
       Insert lstNotif;
       
       
       List<Alert__c> lstAlerts = new List<Alert__c>();
       Alert__c alerts = new Alert__c();
       alerts.Name = 'AlertOne';
       alerts.Alert_Numbers__c='1';
       alerts.Notifications__c = notification.id;
       alerts.Status__c = 'Open';
       lstAlerts.add(alerts);
              
       Alert__c alerts1 = new Alert__c();
       alerts1.Name = 'AlertTwo';
       alerts1.Alert_Numbers__c='2';
       alerts1.Notifications__c = notification1.id;
       alerts1.Status__c = 'Open';
       lstAlerts.add(alerts1);
       insert lstAlerts;
         
     }

   testMethod static void  updateAlertMethodTest()
   {

       List<Id> taskWhatId = new List<Id>();
       Contact con = [Select id from Contact where lastName='TestContact'];
       List<Notifications__c> lstNotif = [select id from Notifications__c ];
       for(Notifications__c n: lstNotif)
       {
         taskWhatId.add(n.Id);  
       }
       test.startTest();
       JO_updateAlert.updateAlert(taskWhatId);
       test.stopTest();
   
   }
  
}