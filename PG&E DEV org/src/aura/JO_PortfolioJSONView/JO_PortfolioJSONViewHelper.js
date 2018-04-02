({
    helperMethod : function(component, event) {
        console.log('TEST');        
        var openRecordID = component.get("v.recordId"); 
        console.log('recordID>> '+openRecordID);
        var action = component.get("c.getJsonData");
        action.setParams({"recordID" : openRecordID});
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('TURE>>'+response.getReturnValue().length);
                component.set("v.jsonDataList", response.getReturnValue());
               
                // set deafult count and select all checkbox value to false on load 
                 component.set("v.selectedCount", 0);
                component.find("box3").set("v.value", false);
                
                //response.getReturnValue();
            } else {
                console.log('Problem getting account, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	    },
             deleteSelectedHelper: function(component, event, deleteRecordsIds) {
          //call apex class method
          var action = component.get('c.deleteRecords');
          // pass the all selected record's Id's to apex method 
          action.setParams({
           "lstRecordId": deleteRecordsIds
          });
          action.setCallback(this, function(response) {
           //store state of response
           var state = response.getState();
           if (state === "SUCCESS") {
            console.log(state);
            if (response.getReturnValue() != '') {
             // if getting any error while delete the records , then display a alert msg/
             alert('The following error has occurred. while Delete record-->' + response.getReturnValue());
            } else {
             console.log('check it--> delete successful');
            }
               // call the onLoad function for refresh the List view  
               this.helperMethod(component, event);
           }
        });
        $A.enqueueAction(action);
        },
    
     Saverows: function(component, event, helper) {
     var jsonList = component.get("v.jsonDataList");
          
         var arr = [];
            for(var i = 0; i < jsonList.length; i++){
            arr.push(jsonList[i].order);
    }
         
            var sorted_arr = arr.slice().sort(); 
            var results = [];
            for (var i = 0; i < sorted_arr.length - 1; i++) {
                if (sorted_arr[i + 1] == sorted_arr[i]) {
                    results.push(sorted_arr[i]);
                }
            }

         if(results.length <= 0){
             
             var recordId = component.get("v.recordId");
         var action = component.get('c.saveRecords');
         action.setParams({ "jsonList" : JSON.stringify(jsonList),"recordId" : recordId });
          action.setCallback(this, function(response) {
           //store state of response
           var state = response.getState();
           if (state === "SUCCESS") {
               var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success Message',
            message: 'Records has been saved!',
            messageTemplate: 'Record {0} created! See it {1}!',
            duration:'3',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
            }
         });
        $A.enqueueAction(action);
        component.set("v.jsonDataList",jsonList);
        component.set("v.customlabelEditMode", false);
        component.set("v.nameEditMode", false); 
        helper.helperMethod(component, event);
             
         }else{
             var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'SEQUENCE value must be unique',
            messageTemplate: 'Record {0} created! See it {1}!',
            duration:'3',
            key: 'info_alt',
            type: 'warning',
            mode: 'pester'
        });
        toastEvent.fire();
         component.set("v.customlabelEditMode", true);
         component.set("v.nameEditMode", true); 
         component.set("v.Savemode", false);   
         }
     }
})