({
    doint : function(component,event,helper,getInputkeyWord){
        debugger;
        var cust= component.get("v.EmialMastId");
        var action = component.get("c.getAllJobOwners");
        action.setParams({
            "EmialMastId": component.get("v.EmialMastId") == '' ? null : component.get("v.EmialMastId"),
        });
        debugger;
        action.setCallback(this,function(response){
            if(response.getState()=== 'SUCCESS')
            {  
                debugger;
                var arr=[];                
                var joCorpRec = response.getReturnValue();
                var decidervar = component.get("v.decidervar");
                // alert('decidervar = '+decidervar);
                if(decidervar ==  false )
                {    
                    component.set("v.allJobOwnerRecords",joCorpRec);
                    var arr=[];
                    var loggedInContact = component.get("v.EmialMastId");
                    for (var key in joCorpRec)
                    {
                        arr.push(joCorpRec[key]);
                    }    
                    component.set('v.selectedRecord',arr);
                }
                else
                {
                    var attid = component.get("v.attachmentId");
                    var filterattid =[];
                    for(var i in attid )
                    {
                        for (var key in joCorpRec)
                        {
                            // alert('attid[i] = '+attid[i]+'  ---  '+'joCorpRec[key].id = '+joCorpRec[key].Id);
                            if(attid[i] == joCorpRec[key].Id)  
                                filterattid.push(joCorpRec[key]);
                        } 
                    }  
                    component.set("v.allJobOwnerRecords",filterattid);
                    component.set('v.selectedRecord',filterattid);
                }  
                var compEvent = component.getEvent("samComponentEvent"); 
                debugger;
                compEvent.setParam("Attlist",component.get("v.selectedRecord"));
                debugger;
                compEvent.fire();
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
    clear :function(component,event,heplper){
        debugger; 
        var indexvar = event.getSource().get("v.name");	
        var listVal = component.get("v.selectedRecord");      
        listVal.splice(indexvar,1);
        component.set("v.selectedRecord",listVal);
        var compEvent = component.getEvent("samComponentEvent"); 
        compEvent.setParam("Attlist",component.get("v.selectedRecord"));
        compEvent.fire();
    },
    
    fetchnewAttchement : function(component,event,heplper)
    {
        
        var action = component.get("c.getNewAttachment");
        action.setParams({
            "EmialMastId": event.getParam("attachId")
            ,
        });
        // debugger;
        action.setCallback(this,function(response)
                           {
                               
                               if(response.getState()== 'SUCCESS')
                               {  
                                   var newattlist =   response.getReturnValue();
                                   
                                   var  selectedRecord   =  component.get('v.selectedRecord');
                                   
                                   for(var i in newattlist )
                                   {
                                       selectedRecord.push(newattlist[i]);
                                   }
                                   component.set("v.allJobOwnerRecords",selectedRecord);
                                   component.set("v.selectedRecord",selectedRecord);
                                   var compEvent = component.getEvent("samComponentEvent"); 
                                   compEvent.setParam("Attlist",component.get("v.selectedRecord"));
                                   compEvent.fire();
                                   
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