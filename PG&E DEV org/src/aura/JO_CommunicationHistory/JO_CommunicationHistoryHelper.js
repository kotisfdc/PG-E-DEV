({
    hideWaiting : function (component, event, helper) {
        component.set("v.toggleSpinner", false);    
    },
    showWaiting : function (component, event, helper) {
        component.set("v.toggleSpinner", true);
    },
})