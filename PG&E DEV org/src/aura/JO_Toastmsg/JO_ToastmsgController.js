({
    doneRendering : function(component, event, helper) {
        debugger;
        //setTimeout(function(){ component.destroy(); }, 6000);
        window.setTimeout(
            $A.getCallback(function() {
                if(component.isValid()) {
                    component.destroy();
                    //$A.util.addClass(component, "slds-transition-hide");
                }
            }), component.get("v.fadeTimeout")
        );
        
    },
	close : function(component, event, helper) {
		 component.destroy();
	}
})