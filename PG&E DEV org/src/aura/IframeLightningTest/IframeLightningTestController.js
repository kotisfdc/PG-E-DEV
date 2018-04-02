({
	myAction : function(component, event, helper) {
        debugger;
        var inp = component.find("input");
        var val = inp.get("v.value");
        //alert(val);
        var action = component.get("c.assignValue");
        action.setParams({
           "svr" : val
        });
        action.setCallback(this,function(response){
            var state = action.getState();
            if(state === "SUCCESS"){
                debugger;
                component.set("v.inptText",response.getReturnValue());  
               
            }
        });
        $A.enqueueAction(action);
        console.log( '$A.enqueueAction(action)' );
        // reload iframe on button click 
alert(component.get("v.inptText"));
                 var d = new Date();
                 var n = d.getTime();   
				component.set("v.ifmsrc", 'https://pespge03-dev-ed--c.na78.visual.force.com/apex/IframeShowData?t='+ n );   
           
    }
})