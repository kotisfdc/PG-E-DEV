({
	doInit : function(component, event, helper) {

        helper.setDualList(component,event,helper);  
        var action = component.get('c.chartConfigData');
        
        console.log(component.get('v.dashboardRec'));        
        action.setParams({
            contactId:  component.get('v.loggedInContact'),
            dashboardRec: component.get('v.dashboardRec')
        })                    
    },
    handleChange : function (component,event,helper) {
        component.set('v.defaultOptions',event.getParam("value"));
    }, 
    saveHandler: function (component,event,helper) { 
        var selectedOptionsList = component.get('v.defaultOptions');
        if(selectedOptionsList.length > 0){
            var action = component.get('c.UpdateUserConfig');
            debugger;
            action.setParams({
                filteredList: selectedOptionsList,
                loggedInUser: component.get('v.loggedInContact'),
                userConfigId: component.get('v.userConfigId'),
                dashboardRec: component.get('v.dashboardRec')
            })
            action.setCallback(this,function(res){
                var state = res.getState();
                if(state == "SUCCESS"){
                    /*alert(res.getReturnValue());*/
                    component.set('v.isStatusChanged',true);
                    var evntCmp = component.getEvent("chartEvnt");
                    evntCmp.setParams({ 
                        "jobOwnerIds" : component.get('v.jobOwnerIds'),
                        "loggedInContact" : component.get('v.loggedInContact'),
                        "dashboardId" : component.get("v.dashboardRec")
                    });   
                    evntCmp.fire();
                    component.destroy();
                }
            })
            $A.enqueueAction(action); 
        }
        else {
            $A.createComponent(
                "c:JO_Toastmsg",
                {
                    "title": 'error',
                    "body": 'please select atleast one status.'
                },
                function(msgBox){                
                    if (component.isValid()) {
                        var targetCmp = component.find('toatMsg');
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body); 
                    }
                }
            );
        }
               
    },
    closeModel: function(component, event, helper) {
		 component.destroy();
    },
})