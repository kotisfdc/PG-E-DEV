@isTest
public class CreateAlert15DailyBatchTest {
   
    @IsTest static void batchTestMethod()
    {
        AlertCreationDailyBatch__mdt fetchalert15Data = new AlertCreationDailyBatch__mdt();
        fetchalert15Data = [select id,MasterLabel,DeveloperName,Alert_Name__c,Alert_Numbers__c,Alert_Status__c,Query_Alert_Status__c,Email_Status__c,Email_Subject__c,Task_Code__c,Number_of_Days__c,
                            Task_Record_Type_Name__c from AlertCreationDailyBatch__mdt where DeveloperName=:Label.CreateAlert15DailyBatch];
        
        system.debug('fetchalert15Data===>'+fetchalert15Data);
        
        
        // String query = 'select id,Status,TaskCode__c,One_Time_Activity__c,RecordType.ID,WhatId,CompletedOn__c from task where Status=\''+queryAlertStatus+'\''+'AND TaskCode__c=\''+taskCode+'\''+'AND RecordType.ID=\''+taskRecordTypeName+'\''; 
        
        Account acc = new Account();
        acc.Name = 'Test';
        Insert acc;


        task tsk = new task();
        tsk.Status = fetchalert15Data.Query_Alert_Status__c;
        tsk.Subject = 'TestSub';
        tsk.Priority = 'High';
        tsk.TaskCode__c = fetchalert15Data.Task_Code__c;
        tsk.One_Time_Activity__c = true;
        tsk.WhatId = acc.id;
        tsk.CompletedOn__c = system.today();
        //tsk.RecordType.name = fetchalert15Data.Task_Record_Type_Name__c;

        insert tsk;
        system.debug('Tassk data===>'+tsk);
        
        test.startTest();
        CreateAlert15DailyBatch obj = new CreateAlert15DailyBatch();
        DataBase.executeBatch(obj);
        test.stopTest();
        
    }
    
}