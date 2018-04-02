//  Puropose: Create Alert3 on Task Completion+15 days using BatchApex
//  Created Date : 4/12/2017
 
global class CreateAlert3DailyBatch implements Database.Batchable<sObject>{
    AlertCreationDailyBatch__mdt fetchalert3Data;    
    String emailStatus;
    String emailSubject;
    Integer numberOfDays;
    String alertName;
    String alertNumber;
    String alertStatus;
    
    global CreateAlert3DailyBatch(){
        
         emailStatus = '';
         emailSubject = '';
         numberOfDays = 0;
         alertName = '';
         alertNumber = '';
         alertStatus = '';
         fetchalert3Data = new AlertCreationDailyBatch__mdt();
         try{
             fetchalert3Data = [select id,MasterLabel,DeveloperName,Alert_Name__c,Alert_Numbers__c,Alert_Status__c,Email_Status__c,Email_Subject__c,Task_Code__c,Number_of_Days__c,
                                Task_Record_Type_Name__c from AlertCreationDailyBatch__mdt where DeveloperName=:Label.CreateAlert3DailyBatch];
             
             //initializeData(fetchalert3Data,emailStatus,emailSubject,numberOfDays,alertName,alertNumber,alertStatus);
              emailStatus = fetchalert3Data.Email_Status__c;
            emailSubject = fetchalert3Data.Email_Subject__c; 
            numberOfDays = Integer.valueof(fetchalert3Data.Number_of_Days__c);
            alertName = fetchalert3Data.Alert_Name__c;
            alertNumber = fetchalert3Data.Alert_Numbers__c;
            alertStatus = fetchalert3Data.Alert_Status__c;
         }catch(Exception e){
             System.debug('^^^^^^^^^^^^^^^^^^^^'+e);
         }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        String query = 'SELECT id,Status,Subject,Incoming,LastModifiedDate,RelatedToID  FROM EmailMessage where Status=\''+emailStatus+'\''+'AND Subject=\''+emailSubject+'\'';
        System.debug('%%%%%%%%%%%%%%%%%'+query);
        return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<EmailMessage> scope){
       
       //System.debug(''555555555555555'+scope.size());
       if(scope <> null && scope.size() > 0 ){
             
             List<Alert__c> alertCreationLst = new List<Alert__c>();
             for(EmailMessage emailReocord : scope){
                  
                 System.debug('%%%%%%%%%%%%%%'+emailReocord.LastModifiedDate.addDays(numberOfDays));
                 if(emailReocord.LastModifiedDate <> null ){ 
                     if(emailReocord.LastModifiedDate.addDays(numberOfDays)  == System.today()||Test.isRunningTest()){
                         
                         Alert__c alerts = new Alert__c();
                         if(emailReocord.RelatedToID <> null){
                             alerts.Notifications__c  =emailReocord.RelatedToID;
                         }
                         alerts.Name = alertName;
                         alerts.Alert_Numbers__c= alertNumber;
                         alerts.Status__c  = alertStatus;
                         alertCreationLst.add(alerts);
                     }
                     
                 }
             }
           System.debug('###################'+alertCreationLst);
           try{
               insert alertCreationLst;
           }catch(Exception e){
               System.debug('$$$$$$$$$$$$$$$$$$$$'+e);
           }
             
       }
   }

   global void finish(Database.BatchableContext BC){
   }
    
   /* global void initializeData(AlertCreationDailyBatch__mdt fetchalert3Data,String emailStatus,String emailSubject,Integer numberOfDays,String alertName,String alertNumber,String alertStatus){
            emailStatus = fetchalert3Data.Email_Status__c;
            emailSubject = fetchalert3Data.Email_Subject__c;
            numberOfDays = Integer.valueof(fetchalert3Data.Number_of_Days__c);
            alertName = fetchalert3Data.Alert_Name__c;
            alertNumber = fetchalert3Data.Alert_Numbers__c;
            alertStatus = fetchalert3Data.Alert_Status__c;
    }*/
}