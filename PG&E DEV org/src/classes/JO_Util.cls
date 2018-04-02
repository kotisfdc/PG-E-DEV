global class JO_Util
{
    
    public static List<User> getJOUsers()
    {
        List<User> ul = new List<User>();
        
        Cache.OrgPartition orgPart = JO_Util.GetJOPartition();        
        system.debug('List of users==>'+ul);
        if(orgPart != null)
        {
            ul = (List<User>)orgPart.get('DBUSERS');
        }
        system.debug('List of users==>'+ul);

        // Check the cache value that the get() call returned.
        
        if (ul == null) 
        {
            ul = new List<User>();
            for(User jUser :[SELECT Id, Name, FederationIdentifier, FirstName,LastName,Email  FROM User
                             WHERE Id In(SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN('JO_Admin','JO_User'))])
            {
                system.debug('List of users==>'+ul);
                ul.add(jUser);
            }
            orgPart.put('DBUSERS', ul);
        }
        system.debug('user List==>>'+ul.size());
        return ul;
    }
    
    
    public static String getLoggedInContact(Id UserId)
    {       
        String logUserContact;
        system.debug('@@@: ctr:'+UserId);
        Contact con = [Select Id From Contact Where OwnerId=:UserId];
        logUserContact = con.Id;
        return logUserContact;
    }
    @AuraEnabled
    public static String getLoggedInContact(){
        return UserInfo.getUserId();
    }
    public static List<Schema.PicklistEntry> retrievePicklistDescribe(String sObjectName,String fieldName){
        List<Schema.PicklistEntry> pickListValues = new List<Schema.PicklistEntry>();
        Map<String, Schema.SObjectField>  selectedObject = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();   
        Schema.DescribeFieldResult fieldResult = selectedObject.get(fieldName).getDescribe();  
        pickListValues = fieldResult.getPicklistValues();       
        return pickListValues;
    }
    public static List<String> getPickListDescribe(String sObjectName,String picklistField){
        List<String> options = new List<String>();
        Map<String, Schema.SObjectField>  sobjf = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();    
        Schema.DescribeFieldResult fieldResult = sobjf.get( picklistField ).getDescribe();           
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            options.add(f.getValue());
        }  
        return options;     
    }
    public static Schema.DescribeFieldResult getFieldDescribe(String sObjectName,String fieldName){
        List<String> options = new List<String>(); 
        system.debug(sObjectName+'Anydatatype_msg'+fieldName)  ;     
        Map<String, Schema.SObjectField>  sobjf = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        Schema.DescribeFieldResult fieldResult = sobjf.get( fieldName ).getDescribe(); 
        return fieldResult;
        
    }
    public static Id getRecordTypeId(String sObjectName,String recordTypeName){     
        
        Map<String, Schema.SObjectType> globalSchemaDesc = Schema.getGlobalDescribe();      //Generate a map of tokens for the sObjects in your organization        
        DescribeSObjectResult result = globalSchemaDesc.get(sObjectName).getDescribe();     //Retrieve the describe result for the desired object       
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = result.getRecordTypeInfosByName();//Generate a map of tokens for all the Record Types for the desired object     
        
        //List<RecordType> ls = [SELECT Id FROM RecordType where SobjectType =: sObjectName and Name =: recordTypeName];
        
        Id recordTypeId = recordTypeInfo.get(recordTypeName).getRecordTypeId();     //Retrieve the record type id by name
        //return ls[0].id;
        return recordTypeId;
    }
    public static List<String> fetchRecordTypeIdList(String sObjectName,Set<String> recordTypeNames){
        List<String> recordTypeList = new List<String>();        

        if(recordTypeNames.size()>0){
           for(String s: recordTypeNames){
                recordTypeList.add('\''+String.valueOf(JO_Util.getRecordTypeId(sObjectName,s))+'\'');
            } 
        }                      
        return recordTypeList;
    }
    @AuraEnabled
    public static Customer_Config__c getDefaultDashboardId(String dashboardId){
        
        return [SELECT Id FROM Customer_Config__c WHERE RecordType.DeveloperName = 'JO_Dashboard' AND Is_Admin__c = true AND Is_Default__c = true AND Id  = :dashboardId];
    }
    
    public static Cache.OrgPartition  GetJOPartition()
    {
        CachePartition__mdt rec = [Select MasterLabel, DeveloperName from CachePartition__mdt where DeveloperName = 'JODASHBOARD' LIMIT 1];
        Cache.OrgPartition orgPart = Cache.Org.getPartition(rec.MasterLabel);
        return orgPart;
   }

    public static void removeJOPartition()
    {
        CachePartition__mdt rec = [Select MasterLabel, DeveloperName from CachePartition__mdt where DeveloperName = 'JODASHBOARD' LIMIT 1];
        GetJOPartition().remove(rec.DeveloperName);
   }
    
    @InvocableMethod(label='Release Platform Cache By Key' description='Releases Platform Cache For JO Org Partition')
    global static List<string> ReleaseOrgCache(List<string> CacheKeyNames)
    {
            Cache.OrgPartition c = GetJOPartition();
            List<String> ret = new List<string>();
            if (c != null)
            {
                for(string s : CacheKeyNames)
                {
                    c.remove(s);
                    ret.add('OK');
                }
            }
        return ret;        
        return ret;        
    }
    
}