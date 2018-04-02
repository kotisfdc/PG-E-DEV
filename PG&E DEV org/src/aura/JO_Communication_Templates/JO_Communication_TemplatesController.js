({
    doinit : function(component, event, helper) {
        debugger;
        var action = component.get('c.getEmailtemplate');	
        action.setParams({'RecId':component.get('v.recordId')});
        action.setCallback(this,function(a){
            if(a.getState()=='SUCCESS'){
                component.set('v.CommTemp',a.getReturnValue());
            }
            else{
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.getToast(component, 'Error',errors[0].message,'error');
                    }
                } else 
                    console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
    displaydetailpage : function(component, event, helper){        
        var emailId = event.getSource().get("v.value");
        var Url=$A.get("{!$Label.c.JO_Alert_url}");
        window.open(Url+emailId);
    },
    sendEmailInfo :  function(component, event, helper){
        debugger;
        var emailId = event.getSource().get("v.value");
        var splitdata=emailId.split("#");
        if(splitdata[1]==0)
            helper.sendHelper(component, event, helper,splitdata);   
        else if(splitdata[1]!=0)
        {
            var condata = $A.get("$Label.c.JO_Email_Checking");
            var r=confirm(condata);
            if (r == true)
                helper.sendHelper(component, event, helper,splitdata);
        }
        
    }
    
})