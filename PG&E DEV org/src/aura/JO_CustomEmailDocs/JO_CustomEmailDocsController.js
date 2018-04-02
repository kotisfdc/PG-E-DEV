({
    doInit: function(component, event, helper) {
       
       helper.getDocsList(component, event, helper);  
    },
    
    close: function(component, event, helper) {
       component.destroy();
    },  
    selectAll: function(component, event, helper) {
        debugger;
        var selectedHeaderCheck = event.getSource().get("v.value");
       
        var attchs = [];
        attchs = component.get("v.attachmentList");
        
        if(attchs.length >0 )
        {    
        
        var getAllId = component.find("Checkbox");
        
        if(! Array.isArray(getAllId))
        {
            if(selectedHeaderCheck == true){ 
                component.find("Checkbox").set("v.value", true);
                component.set("v.selectedCount", 1);
            }else{
                component.find("Checkbox").set("v.value", false);
                component.set("v.selectedCount", 0);
            }
        }
        else{
            
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("Checkbox")[i].set("v.value", true);
                    component.set("v.selectedCount", getAllId.length);
                }
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("Checkbox")[i].set("v.value", false);
                    component.set("v.selectedCount", 0);
                }
            } 
        }  
       } 
    },
    saveDocs : function (component,event, helper) {
      
        var a =[];
        var att  = component.get("v.attachmentList");
        for(var  i  in att )
        {
            if(att[i].checkBoxValue == true)
            {    
                         
            att[i].attachmentName = att[i].attachmentName.split('.')[0];
             a.push(att[i]);
            }    
        }  
       // alert (a);
        if(a.length>0)
        {
            component.set("v.docList",a);
            component.set("v.emaildoc",true);
            component.set("v.customemail",true);            
        }
        if(a.length == 0 && att.length == 0 )
        {
			component.set("v.docList",a);
            component.set("v.emaildoc",false);
            component.set("v.customemail",true);            
        }    
        else
        {
            $A.createComponent(
                "c:JO_Toastmsg",
                {
                    "title": 'error',
                    "body": 'Please Select Required Documents'
                },
                function(msgBox){                
                    if (component.isValid()) {
                        var targetCmp = component.find('toastMsg');
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body); 
                    }
                }
            ); 
           
        }
    
    },
})