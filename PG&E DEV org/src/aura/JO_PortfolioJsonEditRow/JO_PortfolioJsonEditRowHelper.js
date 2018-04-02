({
    Itemselected : function(component, event, helper) {
        helper.Orderhelper(component, event);
    },
    fieldItemselected : function(component, event, helper) {
        var selectedFieldItemVar = component.get("v.selectedFieldValue"); 
       
        console.log('>>><<<'+selectedFieldItemVar);
        component.set("v.selectedFieldAPI", selectedFieldItemVar);
    },
       // component.set("v.selectedFieldAPILabel", selectedFieldAPILabeVar);
        fieldAPILabelselected : function(component, event, helper) {
            var selectedFieldAPILabeVar = component.get("v.selectedFieldAPILabel");
            console.log('>>><<<'+selectedFieldItemVar);
             component.set("v.selectedFieldAPILabel", selectedFieldAPILabeVar);
    },
    visibleItemselected : function(component, event, helper) {
        var selectedvisibleItemVar = component.get("v.selectedVisibleValue"); 
        console.log('>>><<<'+selectedvisibleItemVar);
        component.set("v.selectedVisibleval", selectedvisibleItemVar);
    },
    
    submitForm : function(component, event, helper) {
        console.log('>>'+component.get("v.customLabel"));
        var obj = { 
            		"visible":component.get("v.selectedVisibleval"), 
                   	"order":component.get("v.selectedOrder"), 
                   	"fieldType":"SomeThng DATA", 
                   	"fieldApiLabel":component.get("v.selectedFieldAPI"), 
                   	"fieldAPI":component.get("v.selectedFieldAPILabel"), 
                   	"customLabel":component.get("v.customLabel")
                  };
        var myJSON = JSON.stringify(obj);
        console.log(myJSON);
        alert('JSON DATA>>>>>> '+myJSON);
        
    }
})