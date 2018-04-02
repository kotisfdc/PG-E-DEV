// Puropose: Scheduler for Creating Alert15
//  Created Date : 04/12/2017
 

global class CreateAlert15Scheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      CreateAlert15DailyBatch executealert15Batch = new CreateAlert15DailyBatch(); 
       database.executeBatch(executealert15Batch);
   }
}