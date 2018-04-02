({
    displayEmaildetails : function(component, event, helper) 
    {
        helper.getViewsList(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        component.destroy();
    },
    sendMail : function(component, event, helper) {
        helper.showWaiting(component, event, helper);
        helper.sendHelper(component, event, helper);
    },
    closeMessage : function(component, event, helper) {
        location.reload();
    },
    fileToBeUploaded:function(component,event,helper){
        debugger;
        helper.showWaiting(component, event, helper);
        helper.attachfiledata(component, event, helper);
    },
    selectedemailevent : function(component,event,heplper)
    {
        debugger;
        component.set("v.EmailIdsList",event.getParam("Conlist"));
    }, 
    attachlistdata : function(component,event,heplper)
    {
        debugger;
        component.set("v.Attachmentlist",event.getParam("Attlist"));
    }
})