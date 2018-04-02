public class JO_JSONAddRowsApex {
    
    public class fieldMetaData{
    @auraEnabled
    String fieldLabel {get;set;}
    @auraEnabled
    String fieldapi {get;set;}
    @auraEnabled
    String fieldType {get;set;}
	}
	@auraEnabled
	public static List<fieldMetaData> getFieldMetaData(String objectType ){

        String objtype= (objectType.equals('ORDERS')? 'order__c': (objectType.equals('NOTIFICATIONS')? 'notification__c': ''));
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType sobjSchema = schemaMap.get(objtype);
        
        Map<String, Schema.SObjectField> fieldMap = sobjSchema.getDescribe().fields.getMap();
        
        List<fieldMetaData> fmdList = new List<fieldMetaData>();
        
        for (String fieldName: fieldMap.keySet()) {  
            String fieldlabel;
            String fieldType;
        //It provides to get the object fields label.
        fieldlabel = fieldMap.get(fieldName).getDescribe().getLabel();
            
        Schema.DisplayType FldType = fieldMap.get(fieldName).getDescribe().getType();
        fieldType = string.valueOf(FldType);
        system.debug('fieldlabel>>'+fieldlabel);
        fieldMetaData fmd = new fieldMetaData();
        fmd.fieldLabel = fieldlabel;
        fmd.fieldapi = fieldName;
        fmd.fieldType = fieldType;
        fmdList.add(fmd);
        }
        return fmdList;
       }
}