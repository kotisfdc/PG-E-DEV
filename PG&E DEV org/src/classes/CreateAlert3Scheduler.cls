// Puropose: Scheduler for Creating Alert3
// Created Date : 04/12/2017
 

global class CreateAlert3Scheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      CreateAlert3DailyBatch executealert3Batch = new CreateAlert3DailyBatch(); 
       database.executeBatch(executealert3Batch);
   }
}