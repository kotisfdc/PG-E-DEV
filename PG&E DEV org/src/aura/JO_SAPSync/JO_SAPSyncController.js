({
	doneRendering : function(component, event, helper) {
        //setTimeout(function(){ component.destroy(); }, 6000);
        window.setTimeout(
            $A.getCallback(function() {
                if(component.isValid())
                    component.destroy();
            }), component.get("v.fadeTimeout")
        );
    }
})