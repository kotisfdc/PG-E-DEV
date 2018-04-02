({
    doInit : function(component, event, helper) { 
        debugger;
        helper.getNotificationOrders(component, event, helper) ;          
    },
    showPanel : function(component, event, helper){ 
        debugger;
        helper.onLoadPage(component, event, helper); 
    },
    showHidePanel : function(component, event, helper) {
        debugger;
        var id=component.get("v.orders[0].Id");        
        var e=document.getElementById(id);      
        if (e.style.display == 'block' || e.style.display=='')
        {
            e.style.display = 'none';
            component.set("v.ext","minus");
        }
        else
        {
            e.style.display = 'block';
            component.set("v.ext","plus");
        } 
    }
})