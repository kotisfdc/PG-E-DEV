({
    handleClick : function(component, event, helper) {
        var URLValues = component.get('v.myURL');        
        window.open(URLValues);
        
    },
    doInit : function(component, event, helper) {
        var Url=$A.get("{!$Label.c.JO_Dashboard_URL}");
        if(Url === 'JO_Dashboard_URL'){
            
        } else
        {
            window.open(Url);
        }
    }
})