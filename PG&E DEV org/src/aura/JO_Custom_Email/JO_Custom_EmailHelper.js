({
    getViewsList :function(component, event, helper){
        debugger;
        var action = component.get('c.getSendData'); 
       	action.setParams({
            "TempId":component.get("v.tempId"),
            "RecId": component.get("v.recordsendId") 
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                helper.hideWaiting(component, event, helper);
                var attachmentsDoc = component.get("v.docList"); 
                var wrapperlist = response.getReturnValue();
                if($A.util.isUndefined(attachmentsDoc))
                {    debugger;
                    for(var m in wrapperlist)
                    {
                        wrapperlist[m].Htmlbody = wrapperlist[m].Htmlbody.replace("||Attachments||",""); 
                        //component.set('htmlbody',wrapperlist[m].Htmlbody);
                    }
                 	
                 //	vfWindow.postMessage(htmlbody, "https://pespge03-dev-ed--c.na78.visual.force.com/apex/TestHTML");
                    component.set('v.comTempltes',wrapperlist);
                }    
                else
                { 
                    var j = 1;
                    var am ="" ;
                    var attIdArr = [];
                    console.log(attachmentsDoc);
                    for(var i in attachmentsDoc)
                    {
                        am = am + j+". "+attachmentsDoc[i].attachmentName +"\n " ;
                        j= j+1;         
                        attIdArr.push(attachmentsDoc[i].attachmentId);
                    }                 
                    for(var m in wrapperlist)
                    {
                        wrapperlist[m].Htmlbody = wrapperlist[m].Htmlbody.replace("||Attachments||",am);            
                    }
                    component.set('v.comTempltes',wrapperlist);
                    component.set('v.attachmentId',attIdArr);
                }
                component.set("v.decidervar",true);
                component.set("v.displaydecider",true);
            }
            else if(response.getState() == 'ERROR')
            {
                console.log(response.getReturnValue());
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.getToast(component, 'Error',errors[0].message,'error');
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            debugger;
            var attachlst=component.get("v.Attachmentlist");
        });
        $A.enqueueAction(action);
    },
    sendHelper : function(component, event, helper){
        debugger;
        var EmailLst=[];
        var emaillist=component.get("v.EmailIdsList");
        var attachlst=component.get("v.Attachmentlist");
        var cc=component.find("cc").get("v.value");
        if(cc!==undefined)
        var splitdata=cc.split(";");
        
        if(emaillist!= "")
        {
            for (var key in emaillist)
            {
                if ($A.util.isEmpty(emaillist[key].Email) || !emaillist[key].Email.includes("@") || !splitdata[key].includes("@")) {
                    $A.createComponent(
                        "c:JO_Toastmsg",
                        {
                            "title": 'error',
                            "body": 'Please enter valid email Id'
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
                    helper.hideWaiting(component, event, helper);
                    break;
                } else {
                    EmailLst.push(emaillist[key].Email);
                    debugger;
                }
            }
            if(EmailLst.length == emaillist.length)
            {
                begguer;
                var action = component.get('c.sendEmailTCust'); 
                action.setParams({
                    "Subject":component.find("subject").get("v.value"),
                    "Html":component.find("body").get("v.value"),
                    "RecordId":component.get('v.recordsendId'),
                    "EmailIds":EmailLst,
                    "TempId":component.get("v.EmialMastId"),
                    "Attachlist":attachlst,
                    "cc":splitdata
                });
                debugger;
                action.setCallback(this, function(response) {
                    debugger;
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var storeResponse = response.getReturnValue();
                        helper.getToast(component, 'success','Email sent successfully.','success'); 
                        component.destroy();
                        location.reload();
                    }
                    else
                    {
                        console.log(response.getReturnValue());
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                helper.getToast(component, 'Error',errors[0].message,'error');
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        }
        else
        {
            helper.hideWaiting(component, event, helper);
            $A.createComponent(
                "c:JO_Toastmsg",
                {
                    "title": 'error',
                    "body": 'Please enter email Id'
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
    attachfiledata : function(component, event, helper) {
        debugger;
        var fileInput = component.find("file").getElement();
        if(fileInput == null)
        {}
        else
        {
            var file = fileInput.files[0];
            var fr = new FileReader();
            var self = this;
            fr.onload = function() {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                self.upload(component, event, helper, file, fileContents);
            };
            fr.readAsDataURL(file);    
        }
    },
    
    upload: function(component, event, helper, file, fileContents) {
        debugger;
        var action = component.get("c.addfiledata"); 
        
        action.setParams({
            "EmailID":component.get("v.recordsendId"),
            "fileName": file.name,
            "base64Data": encodeURIComponent(fileContents), 
            "contentType": file.type
        });
        debugger;
        action.setCallback(this,function(a){ 
     
            if(a.getState()=='SUCCESS'){
            
                debugger;
                var compEvent = $A.get("e.c:JO_NewAttchementId");
                compEvent.setParams({
                 "attachId": a.getReturnValue()
                 })
                compEvent.fire();
                helper.hideWaiting(component, event, helper);              
                helper.getToast(component, 'success','File is successfully attached.','success');
                         
            }
            else
            {
                //console.log(a.getReturnValue());
       
                var errors = a.getError();
               
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.hideWaiting(component, event, helper);
                        helper.getToast(component, 'Error',errors[0].message,'error');
                    }
                } else {
                    helper.hideWaiting(component, event, helper);
                    console.log("Unknown error");
                }
            }            
        });
        $A.enqueueAction(action); 
    },
    hideWaiting : function (component, event, helper) {
        component.set("v.toggleSpinner", false);    
    },
    showWaiting : function (component, event, helper) {
        component.set("v.toggleSpinner", true);
    },
    getToast : function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            type: type,
        });
        toastEvent.fire();
    }
})