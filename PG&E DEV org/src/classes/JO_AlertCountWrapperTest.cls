@IsTest
public class JO_AlertCountWrapperTest {
    testMethod static void alertCountWrapperTestMethod(){
        String queryString ='SELECT ID,Name,Notification_Order__r.Name, NotificationDesc__c,CreatedBy.Name,NotificationType__c,Customer__r.Name,NotifPriority__c,NotifPriorityType__c,NotifDate__c,Notification_Status__c FROM Notifications__c WHERE Id IN (SELECT Notifications__c FROM Alert__c ) ';
        
        List<String> notifi = new List<String>();
        JO_AlertCountWrapper Obj = new JO_AlertCountWrapper();
        Obj.alertId =  'Test12345';
        Obj.alertNo = '12345';
        Obj.alertQuery = queryString;
        Obj.notificationQuery = queryString;
        Obj.nofticationId = '123456';
        Obj.lstNotifications = notifi;
        Obj.alertCount = 2;
        Obj.alertName = 'TestAlert_Name';
    }

}