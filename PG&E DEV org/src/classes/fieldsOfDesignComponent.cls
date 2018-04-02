global class fieldsOfDesignComponent extends VisualEditor.DynamicPickList{
       
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('--None--','--None--');
        return defaultValue;
    }
    
    global override VisualEditor.DynamicPickListRows getValues(){
     //   System.debug(' Object : '+context.entityName);
        VisualEditor.DataRow defaultValue = getDefaultValue();
        VisualEditor.DynamicPickListRows recordTypes = new VisualEditor.DynamicPickListRows();
        recordTypes.addRow(defaultValue);
        string objectName = 'Alert__c';
        SObjectType sObjectName = Schema.getGlobalDescribe().get(objectName);        
        schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult describe = targetType.getDescribe();
        Map<String,Schema.SObjectField> mfields = sObjectName.getDescribe().fields.getMap();
        system.debug('mfields---->'+mfields);
        For(Schema.SObjectField field : mfields.values())
        {
            VisualEditor.DataRow value = new VisualEditor.DataRow(field.getDescribe().getName(),field.getDescribe().getlabel() );
                   recordTypes.addRow(value);
               }
            return recordTypes;
        }
}