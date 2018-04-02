Global class GenericListViewController extends VisualEditor.DynamicPickList{
    
 @auraEnabled
    public static List<sobject> findRecords(string objectName){
        string queryString ='';
        List<sobject> returnList=new List<sobject>();
        if(objectName !=null ){
      queryString='select Id, name from '+ objectName + '  Order by lastmodifiedDate DESC Limit 10';
        }else{
            queryString='select Id, name from Contact   Order by lastmodifiedDate DESC Limit 10';  
        }
        system.debug('**queryString:'+queryString);
        returnList=database.query(queryString);
     return returnList;
    }
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('contact', 'Contact');
        return defaultValue;
    }
     public  string cachedTitle{get;set;}
    global override VisualEditor.DynamicPickListRows getValues() {
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        VisualEditor.DataRow value1 = new VisualEditor.DataRow('Contact', 'Contact');
        myValues.addRow(value1);
        VisualEditor.DataRow value2 = new VisualEditor.DataRow('Account', 'Account');
        myValues.addRow(value2);
        VisualEditor.DataRow value3 = new VisualEditor.DataRow('Lead', 'Lead');
        myValues.addRow(value3);
        //Or you use object describe ti find all object details
        //
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('JODashboard');
            if (sessionPart.contains('JODashboard')) {
                cachedTitle = (String)sessionPart.get('JODashboard');
                system.debug('sessionPart====>>'+sessionPart);
                system.debug('cachedTitle====>>'+cachedTitle);
            }
        
       /* for(String ss1: schemaMap.keyset()){
            Schema.SObjectType objToken=schemaMap.get(ss1);
            Schema.DescribeSObjectResult objDescribe=objToken.getdescribe();
            VisualEditor.DataRow value11 = new VisualEditor.DataRow(objDescribe.getLabel(), objDescribe.getName());
            
            myValues.addRow(value11);
        }*/
 
        return myValues;
    }
    
    public static fieldDataWrapper fieldsdata(fieldDataWrapper fr)
    {
        system.debug('Wrapper data===>>'+fr);

       
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.JODashboard');
    	sessionPart.put('JODashboard', fr);
        
        //getValues();
        return null;
    }
    
    public class fieldDataWrapper{
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String apiName { get; set; }
     public   fieldDataWrapper(String label , String apiName)
     {
         this.label = label;
         this.apiName = apiName;
     }
       
    }
}