({
    doInit : function(component, event, helper) {
        debugger;
       // console.log(component.get('v.objectList'));        
     //   helper.onInit(component, event, helper);
         helper.onHandleChange(component, event, helper);
    },
    doHandleChange : function(component, event, helper) {
         debugger;
        helper.onHandleChange(component, event, helper);
    },
})