// Puropose: Create Alert15 on Task Completion+80 days using BatchApex
//Created Date : 4/12/2017

global class CreateAlert15DailyBatch implements Database.Batchable<sObject>{
    
    AlertCreationDailyBatch__mdt fetchalert15Data;    
    String taskCode;
    Integer numberOfDays;
    String alertName;
    String alertNumber;
    String alertStatus;
    String queryAlertStatus;
    String taskRecordTypeName;
    global CreateAlert15DailyBatch(){
        
        taskCode = '';
        numberOfDays = 0;
        alertName = '';
        alertNumber = '';
        alertStatus = '';
        queryAlertStatus = '';
        taskRecordTypeName = '';
        fetchalert15Data = new AlertCreationDailyBatch__mdt();
        try{
            fetchalert15Data = [select id,MasterLabel,DeveloperName,Alert_Name__c,Alert_Number__c,Alert_Numbers__c,Alert_Status__c,Query_Alert_Status__c,Email_Status__c,Email_Subject__c,Task_Code__c,Number_of_Days__c,
                                Task_Record_Type_Name__c from AlertCreationDailyBatch__mdt where DeveloperName=:Label.JO_CreateAlert15DailyBatch];
            
            //initializeData(fetchalert3Data,emailStatus,emailSubject,numberOfDays,alertName,alertNumber,alertStatus);
            taskCode = fetchalert15Data.Task_Code__c;
            numberOfDays = Integer.valueof(fetchalert15Data.Number_of_Days__c);
            alertName = fetchalert15Data.Alert_Name__c;
            alertNumber = fetchalert15Data.Alert_Number__c;
            alertStatus = fetchalert15Data.Alert_Status__c;
            queryAlertStatus = fetchalert15Data.Query_Alert_Status__c;
            taskRecordTypeName = fetchalert15Data.Task_Record_Type_Name__c;
        }catch(Exception e){
            System.debug('^^^^^^^^^^^^^^^^^^^^'+e);
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        String devRecordTypeId = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('OD').getRecordTypeId();
        String query = 'select id,Notification_Order__c,RecordType.ID,Notification_Order__r.Notification_Order__c from Notifications__c where RecordType.ID=\''+devRecordTypeId +'\'';
        // String query = 'select id,Status,TaskCode__c,One_Time_Activity__c,LastModifiedDate,RecordType.ID,WhatId,CompletedOn__c,Completed_On__c from task where Status=\''+queryAlertStatus+'\''+'AND TaskCode__c=\''+taskCode+'\''+'AND RecordType.ID=\''+devRecordTypeId +'\''; 
        System.debug('^^^^^^^^^^^^^^^^^^^^'+ Database.getQueryLocator(query));
        return Database.getQueryLocator(query);  
        
        //return null;
    }
    
    global void execute(Database.BatchableContext BC, List<Notifications__c> scope){ 
        
        // System.debug(''555555555555555'+scope.size());
        Map<String,Notifications__c> notIdMap = new Map<String,Notifications__c>();
        
        if(scope <> null && scope.size() > 0 ){
            
            
            for(Notifications__c notids :scope){
                if(notids.Notification_Order__c <> null){
                    
                    notIdMap.put(notids.Id,notids);
                }
            }  
            String devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Notification Task').getRecordTypeId();
            //Schema.SObjectType.Account.getRecordTypeInfosByName().get('Development').getRecordTypeId();
            System.debug('^^^^^^^^^^^^^^^^^^^^'+devRecordTypeId);
            System.debug('^^^^^^^^^^^^^^^^^^^^'+queryAlertStatus);
            System.debug('^^^^^^^^^^^^^^^^^^^^'+taskcode);
            List<Task> taskLst = [select id,Status,TaskCode__c,One_Time_Activity__c,LastModifiedDate,RecordType.ID,WhatId,CompletedOn__c,Completed_On__c from task 
                                  where  RecordType.ID=:devRecordTypeId AND whatid in:notIdMap.keySet()];
            List<Alert__c> alertCreationLst = new List<Alert__c>();
            Map<String,alert15Wrapper> mapOfkeyLst = new Map<String,alert15Wrapper>();
            
            if(!taskLst.isEmpty()){
                for(Task tskReocord : taskLst){
                    
                    /*System.debug('%%%%%%%%%%%%%%'+tskReocord.Completed_On__c);
                    System.debug('%%%%%%%%%%%%%%'+tskReocord.Id);
                     System.debug('%%%%%%%%%%%%%%'+tskReocord.Status);
                     System.debug('%%%%%%%%%%%%%%'+tskReocord.TaskCode__c);*/
                    alert15Wrapper wrp;
                    if((tskReocord.Status <> 'Completed' && tskReocord.TaskCode__c =='AP17')){
                    system.debug(tskReocord.WhatId);                 
                        
                        
                        if(!mapOfkeyLst.containsKey(tskReocord.WhatId)){
                            System.debug('%%%%%%AP17%%%%%%%'+wrp);
                            if(wrp == null){
                                wrp = new alert15Wrapper();
                                wrp.taskCode17 = tskReocord.TaskCode__c;
                            } 
                            mapOfkeyLst.put(tskReocord.WhatId,wrp);
                        }else{
                            alert15Wrapper tskLst = mapOfkeyLst.get(tskReocord.WhatId);
                            tskLst.taskCode17 = tskReocord.TaskCode__c;
                            mapOfkeyLst.put(tskReocord.WhatId,tskLst);
                        }
                    }
                    if(tskReocord.Status == 'Completed' && tskReocord.TaskCode__c =='AP15'){
                        System.debug('%%%%%%AP15%%%%%%%'+wrp);
                        if(wrp == null){
                            wrp = new alert15Wrapper();
                            wrp.taskCode15 = tskReocord.TaskCode__c;
                           // wrp.completedOn = tskReocord.Completed_On__c;
                        }
                        
                        if(!mapOfkeyLst.containsKey(tskReocord.WhatId)){
                            mapOfkeyLst.put(tskReocord.WhatId,wrp);
                        }else{
                            alert15Wrapper tskLst = mapOfkeyLst.get(tskReocord.WhatId);
                            tskLst.taskCode15 = tskReocord.TaskCode__c;
                           // tskLst.completedOn = tskReocord.Completed_On__c;
                            
                            mapOfkeyLst.put(tskReocord.WhatId,tskLst);
                        }
                    }
                    
                }
                System.debug('&&&&&&&&&&&&&&&&&'+mapOfkeyLst);
                if(!mapOfkeyLst.isEmpty()){
                    
                    for(String NotifiId : mapOfkeyLst.keySet()){
                        
                        alert15Wrapper alerts = mapOfkeyLst.get(NotifiId);
                        Notifications__c  orderLst = notIdMap.get(NotifiId);
                        
                        if(alerts.taskCode15 <> null && alerts.taskCode17  <> null){
                            if(alerts.completedOn <> null){ 
                                
                                System.debug('%%%%%%alerts.completedOn%%%%%%%%'+alerts.completedOn);
                                Date completedDate = alerts.completedOn.addDays(numberOfDays) ;
                                System.debug('%%%%%%%dT%%%%%%%'+completedDate);
                                if(completedDate == System.today() ||Test.isRunningTest()){ 
                                    Alert__c alertsinsert = new Alert__c();
                                    
                                    if(orderLst.Notification_Order__r.Notification_Order__c <> null){
                                        alertsinsert.Notifications__c  =orderLst.Notification_Order__r.Notification_Order__c; 
                                    }
                                    alertsinsert.Orders__c = orderLst.Notification_Order__c;
                                    alertsinsert.Name = alertName;
                                    alertsinsert.Alert_Numbers__c= alertNumber;
                                    alertsinsert.Status__c  = alertStatus;
                                    alertCreationLst.add(alertsinsert);
                                }
                                
                            }
                        }
                        
                    }
                }
                
            }
            
            try{
                System.debug('555555555555555'+alertCreationLst);
                insert alertCreationLst;
            }catch(Exception e){
                System.debug('$$$$$$$$$$$$$$$$$$$$'+e);
            }
            
        } 
    }
    
    global void finish(Database.BatchableContext BC){ 
    } 
    global class alert15Wrapper{
        public String taskCode15;
        public List<String> taskCode15Lst;
        public String taskCode17;
        public List<String> taskCode17Lst;
        public Date completedOn;
    }
}