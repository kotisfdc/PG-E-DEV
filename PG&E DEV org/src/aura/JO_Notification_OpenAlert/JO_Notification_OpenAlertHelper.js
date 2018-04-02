({
    getChildRecors : function(component,event) {
        var action = component.get('c.getAlerts');
        action.setParams({
            'RecId':component.get('v.recordId'),
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            var getAllId = component.find("Checkbox");
            
            if (state === "SUCCESS") {
                component.set('v.ListOfAlerts', response.getReturnValue());
                if (response.getReturnValue() == 0) {
                    component.set("v.error",true);     
                }
                
                var val = component.get('v.ListOfAlerts');
                
                for(var v in val)
                {
                    if((val[v].status == 'Close' && val[v].IsAuto == false) || (val[v].status == 'Open' && val[v].IsAuto == true)|| (val[v].status == 'Close' && val[v].IsAuto == true))
                    {
                        component.set("v.execute",true);
                    }
                       else
                        {
                            component.set("v.execute",false);
                            break;
                        }
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    addSelectedHelper:function(component, event, selectRecordsIds){
        var action = component.get('c.getSelectedRecords');
        action.setParams({
            "lstRecordId": selectRecordsIds
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                debugger;
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message":$A.get('$Label.c.JO_Alert_SucessfulUpdation')
                    
                });
                toastEvent.fire();
                this.getChildRecors(component,event);
            }
        });
        $A.enqueueAction(action);
    },
})