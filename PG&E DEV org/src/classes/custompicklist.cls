global class custompicklist extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;
    
    global custompicklist(VisualEditor.DesignTimePageContext context) {
        system.debug('context=====>'+context);
        this.context = context;
    }
    
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('--None--','--None--');
        return defaultValue;
    }
    
    global override VisualEditor.DynamicPickListRows getValues(){
        System.debug('Dynamic Object : '+context.entityName);
        VisualEditor.DataRow defaultValue = getDefaultValue();
        VisualEditor.DynamicPickListRows recordTypes = new VisualEditor.DynamicPickListRows();
        recordTypes.addRow(defaultValue);
        string objectName = context.entityName;
        system.debug('===objectName===>'+objectName);
        list<Schema.Childrelationship> relatedObjectsList = Schema.getGlobalDescribe().get(objectName).getdescribe().getChildRelationships();
        for (Schema.Childrelationship  relatedObject : relatedObjectsList) {
            VisualEditor.DataRow value = new VisualEditor.DataRow(relatedObject.getChildSObject().getDescribe().getLabel(),relatedObject.getChildSObject().getDescribe().getName());
            recordTypes.addRow(value);
        }
        return recordTypes;
    }
}