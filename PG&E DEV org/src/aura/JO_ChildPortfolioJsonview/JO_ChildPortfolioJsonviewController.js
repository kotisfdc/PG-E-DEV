({
	doInit : function(component, event, helper) {
		helper.fetchPickListVal(component, 'Field Type', 'fieldType');
    },
    
     inlineEditName : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.nameEditMode", true); 
        // after the 100 millisecond set focus to input field   
        
        setTimeout(function(){ 
            component.find("inputId").focus();
        }, 100);
    },
    
})