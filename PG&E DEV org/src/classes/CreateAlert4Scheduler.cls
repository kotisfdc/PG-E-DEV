// Puropose: Scheduler for Creating Alert4
// Created Date : 04/12/2017
 

global class CreateAlert4Scheduler implements Schedulable {
    
   global void execute(SchedulableContext SC) {
      CreateAlert4DailyBatch executealert3Batch = new CreateAlert4DailyBatch(); 
       database.executeBatch(executealert3Batch);
   }
}