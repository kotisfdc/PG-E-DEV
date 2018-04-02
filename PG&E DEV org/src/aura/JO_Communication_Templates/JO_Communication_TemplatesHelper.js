({
    sendHelper : function(component, event, helper,splitdata){
        debugger;
        if(splitdata[4] == "true")
        {
            $A.createComponent(
                "c:JO_CustomEmailDocs",
                {
                    "aura:id": "dynamicChild",
                    "title": 'Required Documents',
                    "tempId":splitdata[0],
                    "recordsendId":component.get('v.recordId'),
                    "EmialMastId":splitdata[2],
                    "cusId":splitdata[3],
                },
                 
                function(msgBox){                
                    if (component.isValid()) {
                        var targetCmp = component.find('EmailDocs');
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body); 
                    }                
                }
            ); 
        }    
        else
        {
            $A.createComponent(
                "c:JO_Custom_Email",
                {   
                    'aura:id': 'dynamicChild',
                    'title' : '',
                    "tempId":splitdata[0],
                    "recordsendId":component.get('v.recordId'),
                    "EmialMastId":splitdata[2],
                    "customerId":splitdata[3],
                    "displaydecider": "true"
                },
                function(msgBox){
                    if(component.isValid()){
                        var targetCmp = component.find('pfbody');
                        var body = targetCmp.get('v.body');
                        body.push(msgBox);
                        targetCmp.set('v.body', body);
                    }
                }
            );   
        }    
    },
    getToast : function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            type: type,
        });
        toastEvent.fire();
    }
})