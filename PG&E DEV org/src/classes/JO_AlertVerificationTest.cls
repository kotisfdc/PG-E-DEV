@isTest
public class JO_AlertVerificationTest
{
    testMethod static void alertVerificationTestMethod()
    {
        /*JO_SAP_Sync__c JSST = new JO_SAP_Sync__c();
        JSST.Transmission_User_Id__c = UserInfo.getUserId();
        JSST.Type__c = 'ECC';
        insert JSST; 
        */
        Notifications__c notif = new Notifications__c();
        notif.Name = 'TEST-REC12345';
        notif.Notification_Status__c = 'SUBM';
        notif.NotificationType__c ='WR';
        //notif.RecordTypeId='0120t0000004Owq';
        notif.PriorityType__c = 'AS';
        notif.Source__c = 'ECC';
        Insert notif;
        system.debug('Notification======>'+notif);
        
        List<Task> tskList = New List<Task>();
        for(integer i=0; i<2; i++)
        {    
            Task tsk2  = new Task(WhatID = notif.id, RecordTypeId = '0121N000001QRCU', Priority ='Normal',  
                                  TaskCode__c = 'AVJO', Status = 'Completed',One_Time_Activity__c = false);
            tskList.add(tsk2);
        }
        Task tsk3  = new Task(WhatID = notif.id, RecordTypeId = '0121N000001QRCU',
                              TaskCode__c = 'AVCC', Status = 'Completed',One_Time_Activity__c = false);
        tskList.add(tsk3);
        insert tskList;
        system.debug('Task list======>'+tskList);
        
        
        list<Alert__c> alertLst = [SELECT Id,Name FROM Alert__c where Notifications__c=:notif.id];
        system.debug('Alert===>'+alertLst);
        
        
    }
    
}