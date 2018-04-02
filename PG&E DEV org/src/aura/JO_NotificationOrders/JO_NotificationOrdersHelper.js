({
    //Fetch the Notofication Orders from the Apex controller
    getNotificationOrders : function (component, event, helper) {  
       
        var action = component.get("c.getAllNotifyOrders");
        action.setParams({
            'notifyId' : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if(state == "SUCCESS"){
                var val = response.getReturnValue();
                var arrOrders=[];
                debugger;
                for(var v in val){                                        
                    if(val[v].Parent_Order__c==undefined){
                        arrOrders.push(val[v]);                        
                    }
                }
                component.set('v.orders', arrOrders); 
                component.set('v.count',val.length);               
            }
        });
        debugger;        
        $A.enqueueAction(action);                
    },        
})