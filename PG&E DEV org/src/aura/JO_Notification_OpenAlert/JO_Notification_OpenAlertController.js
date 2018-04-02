({
    doInit: function(component, event, helper) {
        helper.getChildRecors(component, event);
    },
    displayRecordDetails : function(component, event, helper){
        debugger;
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.recid;
        var Url=$A.get("{!$Label.c.JO_Alert_url}");
        window.open(Url+recId);  
        //window.open("/one/one.app#/sObject/"+recId+"/view");       
    },
    
    
    //For select all
    selectAll: function(component, event, helper) {
        debugger;
        var selectedHeaderCheck = event.getSource().get("v.value");
        
        var getAllId = component.find("Checkbox");
        
        if(! Array.isArray(getAllId)){
            /*if(getAllId != null){
                component.set("v.execute",true); 
            }else*/
            if(selectedHeaderCheck == true){ 
                component.find("Checkbox").set("v.value", true);
                component.set("v.selectedCount", 1);
            }else{
                component.find("Checkbox").set("v.value", false);
                component.set("v.selectedCount", 0);
            }
        }else{
            
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
        
    },
    closeSelected: function(component, event, helper) {
        var tempIDs = [];
        var status=[];
        var IsAuto=[];
        debugger;
        
        var getAllId = component.find("Checkbox");
        var alertList = component.get("v.ListOfAlerts");
        if(getAllId == undefined)
        {
            for(var key in alertList){
                if((val[key].status == 'Close' && val[key].IsAuto == false) || (val[key].status == 'Open' && val[key].IsAuto == true))
                {
                    component.set("v.execute",true);
                }
                   else
                    {
                        component.set("v.execute",false);
                        break;
                    }
            }
        }
        else if(getAllId.length != null)
        {
            for (var i = 0; i < getAllId.length; i++)
            {        
                if (getAllId[i].get("v.value") == true)
                {
                    tempIDs.push(getAllId[i].get("v.text"));
                    
                }
            } 
        }
            else if(getAllId.length == null)
            {
                if (getAllId.get("v.value") == true)
                {
                    tempIDs.push(getAllId.get("v.text"));
                    
                }
            }
        
        if(tempIDs.length > 0){
            debugger;       
            var count = 0;
            for(var key in alertList)
            {
                for(var id in tempIDs)
                {
                    if(alertList[key].RecordId == tempIDs[id]) 
                    {
                        if(alertList[key].status == 'Open')
                        {
                            if(count == 0)
                            {
                                helper.addSelectedHelper(component, event, tempIDs);
                            }
                        }
                    }
                }
            }
        }
        if(tempIDs.length == 0)
        {
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "type":"Error",
                "title": "Error!",
                "message":$A.get('$Label.c.JO_Alert_NoAlertsSelected')
            });
            toastEvent.fire();
        }
    },
})