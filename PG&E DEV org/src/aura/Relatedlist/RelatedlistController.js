({
    doInit : function(component, event, helper) {
        debugger;
        console.log(component.get('v.objectList'));
        helper.onHandleChange(component, event, helper);
        //helper.onInit(component, event, helper);
    },
    doHandleChange : function(component, event, helper) {
         debugger;
        helper.onHandleChange(component, event, helper);
    },
})