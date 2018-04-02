global class Relatedlistclass {
    
    public void fetchid()
    {
        string s = apexpages.currentPage().getParameters().get('id');
        System.debug('coming inside : '+s);
    }
    
    @AuraEnabled
    public static List<String> listAllObject(){
        List<String> objectList = new List<String>();
        For(Schema.sObjectType sobj: schema.getGlobalDescribe().values()){
            if(sobj.getDescribe().isQueryable())
                objectList.add(sobj.getDescribe().getName()+'####'+sobj.getDescribe().getLabel());
        }
        return objectList;
    }
    @AuraEnabled
    global static list<fieldDataWrapper> getrelatedListValue(string recordId){
        ID myIdPrefix = ID.valueOf(recordId);        
        String objectName = myIdPrefix.getSObjectType().getDescribe().getName();
        System.debug('objectName---->satic value '+objectName); 
        list<fieldDataWrapper> wrap = new list<fieldDataWrapper>();
        map<string,string> dynamicData = new map<string,string>();
        list<Schema.Childrelationship> relatedObjectsList = Schema.getGlobalDescribe().get(objectName).getdescribe().getChildRelationships();
        for (Schema.Childrelationship  relatedObject : relatedObjectsList) {
            if(relatedObject.getChildSObject().getDescribe().isUpdateable()
               && 
               relatedObject.getChildSObject().getDescribe().getKeyPrefix()!=null
               && 
               !relatedObject.getChildSObject().getDescribe().isCustomSetting()
               &&
               relatedObject.getChildSObject().getDescribe().isCreateable()
              )                 
                wrap.add(new fieldDataWrapper(relatedObject.getChildSObject().getDescribe().getLabel(),relatedObject.getChildSObject().getDescribe().getName()) );
        }
        return wrap;
    }
    @AuraEnabled
    public static DynamicBindingWrapper listAllFields(String objectName){
        DynamicBindingWrapper dynamicData = new DynamicBindingWrapper();
        List<fieldDataWrapper> wrapperList =  new List<fieldDataWrapper>();
        // Create Dynamic Query Start ..
        String theQuery = 'SELECT ';
        SObjectType sObjectName = Schema.getGlobalDescribe().get(objectName);        
        schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult describe = targetType.getDescribe();
       Map<String, Schema.FieldSet> fsMap = describe.fieldSets.getMap();
        
        if(!fsMap.isEmpty())
        {
            set<String> fskey = fsMap.keySet();
            
            Schema.FieldSet fs =  fsMap.get((new list<string>(fskey) )[0] );
            List<Schema.FieldSetMember> fieldSet = fs.getFields();
            for(Schema.FieldSetMember f : fieldSet)
            {    
                
                
                fieldDataWrapper wrapper = new fieldDataWrapper();
                
                theQuery += f.FieldPath + ',' ;
                
                wrapper.label = f.Label ;
                
                wrapper.apiName = f.FieldPath;
                
                wrapperList.add(wrapper);
                
            }    
            
            
            // Trim last comma
            theQuery = theQuery.subString(0, theQuery.length() - 1);
            // Finalize query string
            theQuery += ' FROM '+objectName+' LIMIT 10';
            // Query End ..
            System.debug('#### theQuery = '+theQuery);
            List<sObject> objectData = Database.Query(theQuery);
            if(objectData!=null && objectData.size()>0)
                dynamicData.sObjectData = objectData;
            else
                dynamicData.sObjectData = new List<sObject>{};
                    dynamicData.fieldList = wrapperList;
        }
        else
        {
            dynamicData.sObjectData = new List<sObject>{};
                dynamicData.fieldList = wrapperList;    
        }    
        System.debug('#### dynamicData '+dynamicData);
        return dynamicData;
    }
    
    public class DynamicBindingWrapper{
        @AuraEnabled
        public List<sObject> sObjectData { get; set; }
        @AuraEnabled
        public List<fieldDataWrapper> fieldList { get; set; }
    }
    
    global class fieldDataWrapper{
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String apiName { get; set; }
        public   fieldDataWrapper(String label , String apiName)
        {
            this.label = label;
            this.apiName = apiName;
        }
        public fieldDataWrapper(){}
    }
}