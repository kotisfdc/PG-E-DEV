global class ListOfReports extends VisualEditor.DynamicPickList
{
    VisualEditor.DesignTimePageContext context;
    
    global ListOfReports(VisualEditor.DesignTimePageContext context) {
        system.debug('context=====>'+context);
        this.context = context;
    }
    
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('--None--','--None--');
        return defaultValue;
    }
    
    global override VisualEditor.DynamicPickListRows getValues()
    {
        VisualEditor.DataRow defaultValue = getDefaultValue();
        VisualEditor.DynamicPickListRows recordTypes = new VisualEditor.DynamicPickListRows();
        recordTypes.addRow(defaultValue);   
        for (Report  reportObj : [SELECT Id,Name FROM Report]) 
        {
            VisualEditor.DataRow value = new VisualEditor.DataRow('Report - '+reportObj.Name,String.valueOf(reportObj.Id));
            recordTypes.addRow(value);
        }
        for(Dashboard dashboardObj :[SELECT Id,Title FROM Dashboard])
        {
            VisualEditor.DataRow value = new VisualEditor.DataRow('Dashboard - '+dashboardObj.Title,String.valueOf(dashboardObj.Id));
            recordTypes.addRow(value);
        }    
        return recordTypes;
    }
}