({
	 getDocsList :function(component, event, helper){
        debugger;
        // alert(component.get("v.EmialMastId"));
        var action = component.get('c.getAttachment');  
        debugger;
        action.setParams({
            "recId":component.get("v.EmialMastId"),
        });
        action.setCallback(this,function(response){
            debugger;
            if(response.getState() == 'SUCCESS'){
                var attachment =[];
                var attname  = response.getReturnValue();
               // alert(attname.length);
                for(var  i  in attname )
                {
                        attname[i].attachmentName = attname[i].attachmentName.split('.')[0];
                        attachment.push(attname[i]);
                }  
                console.log(attachment);
               
                component.set('v.attachmentList',attachment);
               // alert(attachment.length);
                if( attachment.length > 0 )
                {
                     
                    component.set("v.customemail",false); 
                    component.set("v.emaildoc",true);
                         
                }
                else
                {
                    
                    component.set("v.docList",attachment);
                    component.set("v.emaildoc",false);
                    component.set("v.customemail",true);   
                }     
            }
            else if(response.getState() == 'ERROR')
            {
                console.log(response.getReturnValue());
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.getToast(component, 'Error',errors[0].message,'error');
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        $A.enqueueAction(action);
    },
})