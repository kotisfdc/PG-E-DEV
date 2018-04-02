({
    doInit : function(component, event, helper) 
    {
      /*  alert('hi');
          var urlEvent = $A.get("e.force:navigateToURL");
          if(urlEvent) {
           urlEvent.setParams({
               "url": "https://www.google.com/"
      });

      urlEvent.fire(); 
      } */
       debugger;
       var message = component.get("v.repdsb");
       var vfOrigin = "lightingpage";
   var vfWindow = "https://pespge03-dev-ed--c.na78.visual.force.com/apex/DashboardViewPage";
      //var vfWindow = component.find("vfFrame").getElement().contentWindow;
//vfWindow.postMessage(message, vfOrigin);
  
       
    },
    doHandleChange : function(component, event, helper) {
         debugger;
        helper.onHandleChange(component, event, helper);
    },
})