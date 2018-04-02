({
    
        doInit : function(component) {
            var vfOrigin = "https://" + component.get("v.vfHost");
            window.addEventListener("message", function(event) {
                if (event.origin !== vfOrigin) {
                    // Not the expected origin: Reject the message!
                    return;
                }
                // Only handle messages we are interested in
                if (event.data.name === "com.mycompany.chatmessage") {
                    // Handle the message
                    console.log(event.data.payload);
                }
            }, false);
        },
    
    
    sendToVF : function(component, event, helper) {
        var message = component.get("v.message");
        var vfOrigin = "https://" + component.get("v.vfHost");
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, vfOrigin);
	}
})