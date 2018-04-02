global class DynamicBindingDemoController {
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
   public static DynamicBindingWrapper listAllFields(String objectName, String fieldSetName, integer limitval, String sortOrder, String fieldsToDisplay, String recId)
    {        
       String childfieldname;
        Id parentId = Id.valueOf(recId);
        Schema.sObjectType parentobj = parentId.getSObjectType() ;
        SObjectType childobje = Schema.getGlobalDescribe().get(objectName); 
        List<Schema.SObjectField> fieldList = childobje.getDescribe().fields.getMap().values();
        for (Schema.SObjectField field : fieldList) 
        {
          Schema.DescribeFieldResult fieldDesc = field.getDescribe();
          if (Schema.DisplayType.REFERENCE == fieldDesc.getType() )
            {
               for(Schema.sObjectType lt : fieldDesc.getReferenceTo())
               {
                  if(parentobj  == lt)
                  {
                    childfieldname = fieldDesc.getName();
                  }
               }       
             }
        }  
        String relationshipfield;
        string relationshipfieldlabel,temstring;
       List<String> relationfields = new List<String> ();
        DynamicBindingWrapper dynamicData = new DynamicBindingWrapper();
        List<fieldDataWrapper> wrapperList =  new List<fieldDataWrapper>();
        // Create Dynamic Query Start ..
        String theQuery = 'SELECT ';
        if(objectName != null && objectName != '--None--'){
            system.debug('objectNameLabel----->'+objectName);
            SObjectType sObjectName = Schema.getGlobalDescribe().get(objectName);        
            schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
            Schema.DescribeSObjectResult describe = targetType.getDescribe();
            if(!string.isBlank(fieldsToDisplay) )
            {
                Map<String, Schema.SObjectField> fieldMap = sObjectName.getDescribe().fields.getMap();
                List<string> xlist =  fieldsToDisplay.split(',\\s*');
                for(String sr : xlist)
                {
                     fieldDataWrapper wrapper = new fieldDataWrapper();
                     theQuery += sr + ',' ;                    
                    if(sr.contains('.'))
                    {
                      relationshipfield = sr;
                       relationfields.add(sr);
                      if( sr.substringBefore('.').contains('__r'))
                      {
                        Wrapper.label = sr.substringBefore('__r') +'  '+ sr.substringAfter('.');
                          relationshipfieldlabel = Wrapper.label;
                         temstring =  sr.substringBefore('__r')+'__c';
                      }
                      else
                      {   
                         Wrapper.label = sr.substringBefore('.') +'  '+ sr.substringAfter('.');  
                         temstring =  sr.substringBefore('.')+'Id'; 
                      }
                     wrapper.apiName = temstring;   
                    }     
                   else
                   {    
                    wrapper.label = fieldMap.get(sr).getDescribe().getLabel() ;
                    wrapper.apiName = sr;
                   }    
                    wrapperList.add(wrapper);
                    system.debug('relationshipfield='+relationshipfield);
                }                
                theQuery = theQuery.subString(0, theQuery.length() - 1);
               	theQuery += ' FROM '+objectName ;                
                System.debug('theQuery object----->'+theQuery);
               System.debug('childfieldname----> ' + childfieldname);                
                if(! String.isBlank(childfieldname))
                   theQuery += ' where  ' + childfieldname  + ' = :recId ' ;                
                System.debug('theQuery object---->'+theQuery); 
                if(! String.isBlank(sortOrder))
                	theQuery +=  '  ORDER BY '+sortOrder ;
                System.debug('theQuery orderby---->'+theQuery);
                if(limitval != null)
                	theQuery += '  LIMIT '+limitval  ;
                else
                 theQuery += ' LIMIT  10'  ; 
                // Query End ..
                System.debug('theQuery limit total---->'+theQuery);
                List<sObject> objectData = Database.Query(theQuery);
                 System.debug('sObject Query result----->'+objectData);
               system.debug('relationshipfield='+relationshipfield);
            List<sObjectDataWrapper> sObjectDataRelDup =  new   List<sObjectDataWrapper>();
                for(sObject subfield : objectData)
                {					
					sObjectDataWrapper dwd = new sObjectDataWrapper();
                    dwd.sobData = subfield;
					dwd.relashipfields = new  Map<String,String> ();                   
                  if(relationfields.size() != 0)
                  {    
                  for(String fl : relationfields )
                  {    
                  sObject relObjChild = subfield.getSObject(fl.substringBefore('.'));
                    System.debug('relObjChild---->'+relObjChild);
                    if(relObjChild != null)
                    {
                         if( fl.substringBefore('.').contains('__r'))
                      {
                         temstring =  fl.substringBefore('__r')+'__c';
                      }
                      else
                      {   
                         temstring =  fl.substringBefore('.')+'Id'; 
                      }
                        System.debug('temstring =' +temstring );
                        dwd.relashipfields.put(temstring,string.ValueOf(relObjChild.get(fl.substringAfter('.'))));  
                    }
                  system.debug('subfield----->'+subfield);
                  }
                  }
                  sObjectDataRelDup.add(dwd);  
               }    
                System.debug('sObject Query result102----->'+objectData); 
                if(sObjectDataRelDup!=null && sObjectDataRelDup.size()>0)
                    dynamicData.sObjectDataRel = sObjectDataRelDup;
                else
                    dynamicData.sObjectDataRel = new List<sObjectDataWrapper>{};
                        dynamicData.fieldList = wrapperList;
                system.debug(dynamicData.sObjectDataRel);
            }
            else
            {        
            Map<String, Schema.FieldSet> fsMap = describe.fieldSets.getMap();
            system.debug('fsMap--->'+fsMap);
            if(!fsMap.isEmpty())
            {
                set<String> fskey = fsMap.keySet();
                Schema.FieldSet fs;
                if(String.isBlank(fieldSetName))
                {    
                    fs =  fsMap.get((new list<string>(fskey) )[0] );
                    system.debug('iffs--->'+fs);
                }
                else
                {
                    fs =  fsMap.get(fieldSetName);
                    system.debug('elsefs--->'+fs);
                }    
                List<Schema.FieldSetMember> fieldSet = fs.getFields();
                for(Schema.FieldSetMember f : fieldSet)
                {               
                    fieldDataWrapper wrapper = new fieldDataWrapper(); 
                    theQuery += f.FieldPath + ',' ;
                    wrapper.label = f.Label ;
                    wrapper.apiName = f.FieldPath;
                    wrapperList.add(wrapper);
                }    
                System.debug('theQuery----->'+theQuery);
				theQuery = theQuery.subString(0, theQuery.length() - 1);
               theQuery += ' FROM '+objectName ;
                System.debug('theQuery object---->'+theQuery);
                System.debug('childfieldname---->' + childfieldname);
                if(! String.isBlank(childfieldname))
                   theQuery += ' where  ' + childfieldname  + ' = :recId ' ;
                  System.debug('theQuery object---->'+theQuery);                
                if(! String.isBlank(sortOrder))
                theQuery +=  '  ORDER BY '+sortOrder ;
                System.debug('theQuery orderby---->'+theQuery);
                if(limitval != null)
                theQuery += '  LIMIT '+limitval  ;
                else
                 theQuery += ' LIMIT 10 '  ;   
                // Query End ..
                System.debug('theQuery limit total---->'+theQuery);
                List<sObject> objectData = Database.Query(theQuery);               
                List<sObjectDataWrapper> sObjectDataRelDup =  new List<sObjectDataWrapper>();                 
                for(sObject subfield : objectData)
                {
					sObjectDataWrapper dwd = new sObjectDataWrapper();
                    dwd.sobData = subfield;
					dwd.relashipfields = new  Map<String,String> ();   
                   sObjectDataRelDup.add(dwd); 
                }     
                if(sObjectDataRelDup!=null && sObjectDataRelDup.size()>0)
                    dynamicData.sObjectDataRel = sObjectDataRelDup;
                else
                    dynamicData.sObjectDataRel = new List<sObjectDataWrapper>{};
                        dynamicData.fieldList = wrapperList;
            }
            else
            {
                dynamicData.sObjectData = new List<sObject>{};
                    dynamicData.fieldList = wrapperList;
                dynamicData.sObjectDataRel = new List<sObjectDataWrapper>{};
            }
           }      
        }
        System.debug('dynamicData----->'+dynamicData);        
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{objectName}); 
        dynamicData.ObjectLabel = describeSobjectsResult[0].getLabelPlural();
        dynamicData.ActrecCount = dynamicData.sObjectDataRel.size();
        return dynamicData;
    }
  
    public class DynamicBindingWrapper{
        @AuraEnabled
        public List<sObject> sObjectData { get; set; }
        @AuraEnabled
        public List<fieldDataWrapper> fieldList { get; set; }
        @AuraEnabled
        Public List<sObjectDataWrapper> sObjectDataRel {get;set;}
        @AuraEnabled
        Public String ObjectLabel {get;set;}
        @AuraEnabled
        Public Integer ActrecCount {get;set;}
    }
    
    global class fieldDataWrapper{
        @AuraEnabled 
        public String label { get; set; }
        @AuraEnabled
        public String apiName { get; set; }
       // @AuraEnabled
       // public Id recid { get; set; }
        
        public fieldDataWrapper(String label , String apiName)
        {
            this.label = label;
            this.apiName = apiName;
          //  this.recid = recid;
        }
        public fieldDataWrapper(){}
    }
    
    global class sObjectDataWrapper
    {
        @AuraEnabled
        Public sObject sobData { get;set;}
        @AuraEnabled
        Public Map<String,String> relashipfields {get;set;}
    }    
}