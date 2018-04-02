public class UserConfigController {

    public class viewfields {
        @AuraEnabled
        public String visible {get;set;}
        @AuraEnabled
        public String order {get;set;}
        @AuraEnabled
        public string fieldType {get;set;}
        @AuraEnabled
        public string fieldApiLabel {get;set;}
        @AuraEnabled
        public string fieldAPI {get;set;}
        @AuraEnabled
        public string customLabel {get;set;}
        @AuraEnabled
        public string objectLable {get;set;}
    }
    public class viewFielsJsonData {
        public List<viewfields> viewfields{get;set;}
        viewFielsJsonData(List<viewfields> lsds)
        {
            this.viewfields = lsds;
        }
    }
    
    
    @auraEnabled
     public static List<viewfields> getJsonData(String recordID){        
        
        List<Customer_Config__c> userInfo = [SELECT User_Config__c, Json_Config__c
                                         FROM Customer_Config__c Where id = : recordID];
        String jsData = userInfo[0].Json_Config__c;
         
        viewFielsJsonData vfJson = (viewFielsJsonData)Json.deserialize(jsData, viewFielsJsonData.class);
       	
       	List<viewfields> vjJsonArray = vfJson.viewfields;
        system.debug('DATA '+vjJsonArray);
        if(vjJsonArray.size()>0)
        {
            for(viewfields var: vjJsonArray)
            {
                String objectType;
                if(var.fieldAPI.contains('Notification_Order__r'))
                {
                    objectType = 'Order';
                }
                else if(var.fieldAPI.contains('Customer__r.LastName__c'))
                {
                   objectType = 'Address'; 
                }
                else
                {
                   objectType = 'Notification'; 
                }
                var.objectLable = objectType;
            }
        }
        return vjJsonArray;
    }
    
    //Edit row records
         
    //delete row records
    @auraEnabled
    public static List<String> deleteRecords(String recordID){  
    //for store Error Messages  
	  List < String > oErrorMsg = new List < String > ();
        List<Customer_Config__c> isDeleteRecord = [SELECT Name,ID, User_Config__c,Json_Config__c
                                         FROM Customer_Config__c Where id = : recordID];
    	//String deleteData = isDeleteRecord[0].json__c;
        
        Database.DeleteResult[] result = Database.delete(isDeleteRecord, false);
        
        // Iterate through each returned result
        
        for(Database.DeleteResult dr: result){
            if(dr.isSuccess()){
                //successfull operation
                System.debug('Successful delete row');
            }else{
                //failed operation
                oErrorMsg.add('');
                for(Database.Error err: dr.getErrors()){
                    // add Error message to oErrorMsg list and return the list
		            oErrorMsg.add(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
        return oErrorMsg;
    }
    
        @AuraEnabled
    Public static List<viewfields> saveRecords(string jsonList,String recordId)
    {
        system.debug('jsonList'+jsonList);
 		system.debug('recordId'+recordId);
        List<viewfields> vfJson = (List<viewfields>)Json.deserialize(jsonList, List<viewfields>.class);
        viewFielsJsonData vfJsonall = new viewFielsJsonData(vfJson);
        System.debug('vfJsonall : '+vfJsonall);
        Customer_Config__c cc = new Customer_Config__c();
        cc.Json_Config__c = JSON.serialize(vfJsonall);
        cc.Id = recordId;

        update cc;  
        return vfJson;
    }

    
    //Save updated rows
    //@auraEnabled
    //public static List<String> saverows(String recordID){        }
    
    //String str = Json.serialize(<saveRecords>);
    //userInfo.Json_Config__c = str;
    //update userinfo
}