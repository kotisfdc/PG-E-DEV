({
    Orderhelper : function(component, event) {
        console.log('TEST');        
        var selectedItemVar = component.get("v.selectedValue"); 
        
        var action = component.get("c.getFieldMetaData");
        action.setParams(
            {  
                 "objectType" : selectedItemVar
            }
        );
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('TURE');
                component.set('v.ObjectFieldsMetaData', response.getReturnValue());
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
        
    }
})