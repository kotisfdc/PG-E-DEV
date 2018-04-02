({
    doInit : function(component, event, helper) {
        helper.helperMethod(component, event);
    },

    addRecord : function(component, event, helper) {
        alert('Add Record.......');
        var jsonList = component.get("v.jsonDataList");
        jsonList.push({
            "visible": " " ,
            "order": " ",
            "fieldType": " ",
            "fieldApiLabel": " ",
            "fieldAPI": " ",
            "customLabel": " "
        });
        component.set("v.jsonDataList",jsonList);
        component.set("v.recordsCount", jsonList.length);
    },

    //inlineEdit Rows
	inlineEdit : function(component,event,helper){   
        // show the name edit field popup 
		component.set("v.customlabelEditMode", true);
        component.set("v.Savemode", false);
        component.set("v.nameEditMode", true); 
     },
    
	//Save rows 
    Saverows : function(component, event, helper){
        component.set("v.Savemode", true);
        component.set("v.customlabelEditMode", false);
        component.set("v.nameEditMode", false);
        helper.Saverows(component, event, helper);
    },
    
    Cancel : function(component, event, helper){
        component.set("v.customlabelEditMode", false);
        component.set("v.nameEditMode", false);
        component.set("v.Savemode", true);
    },

    // show modal view
			handleShowModal: function(component, evt, helper) {
			var modalBody;
			$A.createComponent("c:JO_JSONeditRow", {},
							   function(content, status) {
								   if (status === "SUCCESS") {
									   modalBody = content;
									   component.find('overlayLib').showCustomModal({
										   header: "Please Enter Row Values",
										   body: modalBody, 
										   showCloseButton: true,
										   cssClass: "mymodal",
										   closeCallback: function() {
											   alert('You closed the alert!');
										   }
									   })
								   }
							   });
			},
    // count the selected cheackboxes 
    checkboxSelect: function(component, event, helper) {
        // get the selected checkbox value
          var selectedRec = event.getSource().get("v.value");
	  // get the selectedCount attrbute value(default is 0) for add/less numbers. 
	  var getSelectedNumber = component.get("v.selectedCount");
	  // check, if selected checkbox value is true then increment getSelectedNumber with 1 
	  // else Decrement the getSelectedNumber with 1     
	  if (selectedRec == true) {
	   getSelectedNumber++;
	  } else {
	   getSelectedNumber--;
	  }
	  // set the actual value on selectedCount attribute to show on header part. 
	  component.set("v.selectedCount", getSelectedNumber);
    },
    
    // For select all Checkboxes 
    
    selectAll: function(component, event, helper) {
	  //get the header checkbox value  
	  var selectedHeaderCheck = event.getSource().get("v.value");
	  // get all checkbox on table with "boxPack" aura id (all iterate value have same Id)
	  // return the List of all checkboxs element 
	  var getAllId = component.find("boxPack");
	  // If the local ID is unique[in single record case], find() returns the component. not array   
		 if(! Array.isArray(getAllId)){
		   if(selectedHeaderCheck == true){ 
			  component.find("boxPack").set("v.value", true);
			  component.set("v.selectedCount", 1);
		   }else{
			   component.find("boxPack").set("v.value", false);
			   component.set("v.selectedCount", 0);
		   }
		 }else{
		   // check if select all (header checkbox) is true then true all checkboxes on table in a for loop  
		   // and set the all selected checkbox length in selectedCount attribute.
		   // if value is false then make all checkboxes false in else part with play for loop 
		   // and select count as 0 
			if (selectedHeaderCheck == true) {
			for (var i = 0; i < getAllId.length; i++) {
			  component.find("boxPack")[i].set("v.value", true);
			 component.set("v.selectedCount", getAllId.length);
			}
			} else {
			  for (var i = 0; i < getAllId.length; i++) {
				component.find("boxPack")[i].set("v.value", false);
				 component.set("v.selectedCount", 0);
			}
		   } 
		 }  
    },
    
    deleteJsonRow : function(component, event, helper) {
      alert('Delete Record.......'); 
        //var event = component.getEvent("deleteJsonRow");
        /* event.setParams({
            'selectedJsonRow':component.get("v.jsonDataList")
        });
        event.fire();*/
        //delete jsonRow
        /*var selJsonRow = event.getParam("deleteJsonRow");        
        var JsonRows = component.get("v.jsonDataList");        
        var index = JsonRows.indexOf(selJsonRow);        
        if (index > -1) {            
            JsonRows.splice(index, 1);            
        }        
        component.set("v.jsonDataList",JsonRows); */   
        
        //delete selected Records
       // create var for store record id's for selected checkboxes  
	  var delId = [];
	  // get all checkboxes 
	  var getAllId = component.find("boxPack");
	  // If the local ID is unique[in single record case], find() returns the component. not array
		 if(! Array.isArray(getAllId)){
			 if (getAllId.get("v.value") == true) {
			   delId.push(getAllId.get("v.text"));
                 
                    
			 }
		 }else{
		 // play a for loop and check every checkbox values 
		 // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
		 for (var i = 0; i < getAllId.length; i++) {
		   if (getAllId[i].get("v.value") == true) {
			 delId.push(getAllId[i].get("v.text"));
		   }
		  }
		 } 
         // call the helper function and pass all selected record id's.    
		  helper.deleteSelectedHelper(component, event, delId);
			
        
    },
})