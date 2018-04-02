({
    onInit : function(component, event, helper) {
        debugger;
        /* Call the Apex class method to fetch the List of all object */
        var action = component.get('c.getrelatedListValue');        
        action.setParams({ 
            "recordId":component.get("v.recordId")
        });
        action.setCallback(this, function(response){
             debugger;
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                /* set the value to the attribute of the component */
                var responseValue = response.getReturnValue();
                var lstOptions = [];
                for(var i=0; i < responseValue.length; i++){
                    lstOptions.push({
                        value : responseValue[i].label,
                        key : responseValue[i].apiName
                    });
                }
                lstOptions.sort();
                component.set('v.objectList', lstOptions);
                
            }else{
                var errors = response.getError();
                $A.log(errors);
                if(errors || errors[0].message){
                    console(errors[0].message);
                }
            }
        });
        helper.onHandleChange(component, event, helper);
        $A.enqueueAction(action);
    },
    onHandleChange : function(component, event, helper){
         debugger;
        /* Call this method whenever user will select the Obejct
         * and show the Dynamic Content */
        var selObject = component.get('v.objectList');
         var selFieldSet = component.get("v.fieldsetName");
        var action = component.get('c.listAllFields');  
        var ObjName = selObject.label;
        component.set('v.objectName' , ObjName);
        //var objrem = selObject.trim('__c');
        //component.set("v.objectName", objrem);
        if(selObject!=null && selObject!='' && selObject!=undefined){
            action.setParams({
                "objectName" : selObject,
                "fieldSetName" : selFieldSet,
                "limitval": component.get('v.limit'),
                "sortOrder":component.get('v.sortFileds'),
                "fieldsToDisplay" : component.get('v.customdisplay'),
                "recId" : component.get('v.recordId')
            });
            action.setCallback(this, function(response){
                 debugger;
                var state = response.getState();
                if( state === 'SUCCESS' && component.isValid()){               
                    //component.find("dynamicBody").set("v.body",[]);
                    component.find('sfdcDiv').set("v.body",[]);
                    var responseValue = response.getReturnValue();
                    var objectValue,fieldList;
                    if(responseValue != null){
                        debugger;
                        objectValue   = responseValue.sObjectDataRel;
                        fieldList     = responseValue.fieldList;
                        component.set("v.ObjectLabel",responseValue.ObjectLabel);
                        component.set("v.ActrecCount",responseValue.ActrecCount);
                    }
                    /* Create Dynamic Table */
                    
                    var sObjectDataTableHeader = [];
                    debugger;
                    // Create table Header
                    if(fieldList != null && fieldList.length > 0){
                        for (var i=0; i <  fieldList.length; i++) {
                            sObjectDataTableHeader.push(fieldList[i].label);
                        }
                    }
                    console.log(sObjectDataTableHeader);
                    //Get the count of columns.
                    var columnCount = sObjectDataTableHeader.length;
                    //Create a HTML Table element.
                    var table = document.createElement("TABLE");
                    table.width = "100%";
                    //table.border = "1";
                    //Add the header row.
                    var row = table.insertRow(-1);
                    for (var i = 0; i < columnCount; i++) {
                        var headerCell = document.createElement("TH");
                        headerCell.innerHTML = sObjectDataTableHeader[i];
                        headerCell.className='hearderClass';
                        row.appendChild(headerCell);
                    }
                    debugger;
                    //var tableid = component.find("sfdcDiv");
                    var tableid = component.get('v.objectList')
                    var dvTable = document.getElementById(tableid);
                    dvTable.innerHTML = "";
                    dvTable.appendChild(table);
                    /* Create Dynamic Table End */
                   
                   var recCountPrest=0;
                   if(objectValue != null && objectValue.length )
                   {
                         recCountPrest = objectValue.length;
                        component.set('v.recCount' , recCountPrest);
                        for(var j=0; j < objectValue.length; j++)
                        {
                            // Dynamic table Row
                            // 
                            row = table.insertRow(-1);
                            // Dynamic Table Row End
                            for (var i=0; i <  fieldList.length; i++) {
                                // Dynamic table Row
                                var cell = row.insertCell(-1);
                                //cell.innerHTML = objectValue[j].sobData[fieldList[i].apiName];                           
                                if(fieldList[i].apiName == "Name")
                                {
                                    var a = document.createElement('a');
                                    var linkText = document.createTextNode(objectValue[j].sobData[fieldList[i].apiName]);
                                    a.appendChild(linkText);
                                    //a.title = objectValue[j].sobData[fieldList[i].apiName];
                                    a.href = "/"+objectValue[j].sobData["Id"];
                                     cell.appendChild(a); 
                                } 
                                else
                                {
                                    if($A.util.isUndefined(objectValue[j].relashipfields[fieldList[i].apiName]))
                                    cell.innerHTML = objectValue[j].sobData[fieldList[i].apiName];
                                    else
                                    {
                                         var a = document.createElement('a');
                                         var linkText = document.createTextNode(objectValue[j].relashipfields[fieldList[i].apiName]);
                                         a.appendChild(linkText);
                                         //a.title = objectValue[j].relashipfields[fieldList[i].apiName];
                                         a.href = "/"+objectValue[j].sobData[fieldList[i].apiName];
                                         cell.appendChild(a);
                                    }    
                                }    
                                component.set('v.isSending' , false);
                            }
                        }
                    }
                    
                }else{
                    var errors = response.getError();
                    $A.log('Error Details '+errors);
                    if( errors || errors[0].message){
                        console.log('Error Details '+errors[0].message);
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set('v.isSending' , false);
        }
    },
})