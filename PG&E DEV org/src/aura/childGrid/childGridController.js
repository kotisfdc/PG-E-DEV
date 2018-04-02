({
    scriptsLoaded : function(component, event, helper) {
        debugger;
       
        helper.MethodfromAccounttocontact(component, event, helper);
    },
    savefilter : function(component, event, helper) {
        debugger;
        var params = event.getParam('data');
        var stage = (params.filter);
        console.log(stage);
        var filterdatas = [];
        for(var v in stage)
        {
            filterdatas.push(stage[v]);
        }
        if(filterdatas.length > 0)
            var fdata = JSON.stringify(filterdatas);
        var action = component.get("c.saveContact");
        action.setParams({
            filter : fdata
        });
        action.setCallback(this, function(a) {
            var data = a.getReturnValue();
            if(a.getState() == 'SUCCESS')
            {
                //debugger;
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'success',
                    "mode": 'dismissible',
                    "message": 'Filter has been saved successfully'
                });
                toastEvent.fire();*/
            }
        });
        $A.enqueueAction(action);
    }
})