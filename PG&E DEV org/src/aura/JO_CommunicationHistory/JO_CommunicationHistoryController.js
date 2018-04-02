({
    doinit : function(component, event, helper) {
        helper.showWaiting(component, event, helper);
        var action = component.get('c.getTask');		
        action.setParams({
            'RecId':component.get('v.recordId'),
        });
        action.setCallback(this,function(a){
            if(a.getState()=='SUCCESS'){
                helper.hideWaiting(component, event, helper);
                debugger;
                component.set('v.comTempltes',a.getReturnValue());
                if(a.getReturnValue().length==0)
                    component.set("v.error",true); 
            }
        });
        $A.enqueueAction(action);
    },
    displaydetailpage : function(component, event, helper){        
        var recId = event.getSource().get("v.value");
        var Url=$A.get("{!$Label.c.JO_Alert_url}");
        window.open(Url+recId);    
    },
    displayRecordDetails : function(component, event, helper){
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.recid;
        var Url=$A.get("{!$Label.c.JO_Alert_url}");
        window.open(Url+recId);         
    },
    toggle: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
})