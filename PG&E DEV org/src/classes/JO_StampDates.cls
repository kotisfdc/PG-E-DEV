public class JO_StampDates {
    @InvocableMethod(label='JO Order StampChildFields' description='Stamps Field Values from Order Child Records')
    public static void JO_Order_StampChildFields (List<Task> lsTasks) {
        //TODO: update method return type and input parameters (they do need to be List)
        
        Map<Id,sObject> mapOrders = new Map<Id,sObject>();
        
        system.debug(' ---- BEFORE INVOKE METHOD RECORDS SIZE ---- ' + lsTasks.size());
        system.debug(' ---- BEFORE INVOKE METHOD RECORDS SIZE ---- ' + lsTasks);
        string createdDate;
        for(Task taskRec : lsTasks)
        {
            sObject rec = null;
            if(taskRec.TaskCode__c=='AVNE' || taskRec.TaskCode__c== 'AVNG' || taskRec.TaskCode__c=='AVWG' || taskRec.TaskCode__c=='AVWE' || taskRec.TaskCode__c=='AVDE' || taskRec.TaskCode__c=='AVDG')
            {
                if(mapOrders.containskey(taskRec.NOTIF__c)){
                    rec = mapOrders.get(taskRec.NOTIF__c);
                    system.debug('rec for notificaions==>'+rec);
                }
                else{
                    rec = (Notifications__c)Notifications__c.sobjectType.newsObject(null,false);
                }
                rec.put('id', taskRec.NOTIF__c);
                string str= string.valueOfGmt(taskRec.CreatedDate);
                string[] sr=str.split(' ');
                string dat=sr[0].replace('-','');
                system.debug('rec value==>'+rec);
                /*if(taskRec.TaskCode__c == 'AVNE')
rec.put('AVXX__c', taskRec.CompletedOn__c);
else*/
                rec.put(taskRec.TaskCode__c + '_CompletedDate__c', taskRec.CompletedOn__c);
                rec.put(taskRec.TaskCode__c + '_CreatedDate__c',dat);
                rec.put(taskRec.TaskCode__c + '_Status__c', taskRec.Status);
                system.debug('rec of task==>'+rec);
                
                mapOrders.put(taskRec.Order__c, rec);
            }
            else
            {
                if(mapOrders.containskey(taskRec.Order__c)){
                    rec = mapOrders.get(taskRec.Order__c);
                    system.debug('rec for order==>'+rec);
                }
                else{
                    rec = (Order__c)Order__c.sobjectType.newsObject(null,false);
                }
                rec.put('id', taskRec.Order__c);
                string str= string.valueOfGmt(taskRec.CreatedDate);
                string[] sr=str.split(' ');
                string dat=sr[0].replace('-','');
                rec.put(taskRec.TaskCode__c + '__c', taskRec.CompletedOn__c);
                rec.put(taskRec.TaskCode__c + '_CreatedDate__c',dat);
                rec.put(taskRec.TaskCode__c + '_Status__c', taskRec.Status);
                system.debug('rec of task==>'+rec);
                
                mapOrders.put(taskRec.Order__c, rec);
            }
        }
        
        system.debug(' ---- AFTER INVOKE METHOD RECORDS SIZE ---- ' + mapOrders.size());
        system.debug(' ---- BEFORE INVOKE METHOD RECORDS SIZE ---- ' + mapOrders.values());
        update mapOrders.values();
    }
}