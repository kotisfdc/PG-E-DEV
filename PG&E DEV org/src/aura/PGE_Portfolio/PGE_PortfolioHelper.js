({    
    getViewsList: function(component, event, helper){
        debugger;
        component.set("v.toggleSpinner", true); 
        component.set('v.filterContacts',event.getParams().jobOwnerIds);
        component.set('v.loggedInContact',event.getParams().loggedInContact);
        component.set('v.dashboardRec',event.getParams().dashboardId);
        var action = component.get('c.generateConfigRec');        
        action.setParams({
            contactIds: component.get('v.filterContacts'),
            userConfigRec: component.get('v.dashboardRec')
        });
        action.setCallback(this, function(a){        
            if(a.getState() === "SUCCESS"){  
                debugger;  
                //helper.alertNotifications(component, event, helper);              
                var viewsArray = [];
                var viewsRec = a.getReturnValue();
                var views = viewsRec.allViewLst;
                console.table(viewsRec.records);
                component.set('v.portfolioList',views); 
                component.set("v.all",viewsRec.records);
                component.set("v.allTabTotal",viewsRec.records.length);
                component.set("v.moretabs", ''); 
                var columns = new Map(); 

                for(var f in views){
                    var clmns = [];
                    //if(views[f].viewName == tab.get('v.title')){ , type: views[f].viewfields[l].fieldType
                        for(var l in views[f].viewfields){
                            if(views[f].viewfields[l].visible){
                                clmns.push({label: views[f].viewfields[l].customLabel, fieldName: views[f].viewfields[l].fieldAPI});
                                columns.set(views[f].viewName, clmns);
                            }
                        }
                    //} 
                    if(!views[f].isAdmin){
                        viewsArray.push(views[f].viewName);
                    }                   
                }
                component.set('v.tColumns', columns);
                 var result = '';
                 var res = [];                 
                for(var f in views){   
                    var viewName = views[f].viewName;
                    views[f].count = viewsRec.recordCount;
                    if(views[f].viewName == 'All'){
                        component.set('v.selectedTabId',"Id_All");

                        component.set('v.allCount',viewName+'('+views[f].count+')');
                       // helper.addTab(component, event,viewName+'('+views[f].count+')',viewName);
                       for(var l in views[f].viewfields){
                            if(views[f].viewfields[l].visible){
                                var labelVal = views[f].viewfields[l].customLabel != null ? views[f].viewfields[l].customLabel : views[f].viewfields[l].fieldApiLabel;                    
                                var fp = {label : labelVal, type : views[f].viewfields[l].fieldType, name : views[f].viewfields[l].fieldAPI};
                                res.push(fp);
                            }
                        }
                    }
                    
                    
                }
                component.set("v.fieldSetValues", res); 
                component.set('v.views',viewsArray);
                helper.setViewList(component, views); 
                component.set("v.toggleSpinner", false);               
           }
           else if(a.getState() === "ERROR"){
               var errors = a.getError();
               if (errors) {
                   if (errors[0] && errors[0].message) {                        
                       $A.createComponent(
                           "c:JO_Toastmsg",
                           {
                               "title": 'error',
                               "body": errors[0].message
                           },
                           function(msgBox){                
                               if (component.isValid()) {
                                   var targetCmp = component.find('toatMsg');
                                   var body = targetCmp.get("v.body");
                                   body.push(msgBox);
                                   targetCmp.set("v.body", body); 
                               }
                           }
                       );
                       component.set("v.toggleSpinner", false); 
                   }
               } else {
                   console.log("Unknown error");
                   component.set("v.toggleSpinner", false); 
               }
           }
        });
        $A.enqueueAction(action);
    },
    allTabRecords : function(component, event, helper) {       
        var action = component.get("c.getFbarjobtable"); 
        action.setStorable();
        action.setCallback(this , function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                debugger; 
                var jdetails = a.getReturnValue(); 
                component.set("v.all",jdetails);
            }
        });
        $A.enqueueAction(action) 
    },
    alertNotifications : function(component, event, helper){
       debugger;
        var action = component.get("c.getNotificationRec");
        action.setStorable();
        action.setParams({
            conatcIds : component.get('v.filterContacts'),
            loggedInContact : component.get('v.loggedInContact'),
            userConfigRec:component.get('v.dashboardRec'),
        })
        action.setCallback(this , function(response){
            if (response.getState() === "SUCCESS") {
                debugger; 
                var notifList = [];
                var jdetails = response.getReturnValue(); 
               
                /*for(var key in jdetails)
                {
                    if(jdetails[key].Notification_Order__c == undefined)
                    {
                       notifList.push(jdetails[key]); 
                    }
                }*/
                component.set("v.all",jdetails);
                component.set("v.allTabTotal",jdetails.length);
                //component.set("v.notifTabTotal",notifList.length); 
                //component.set("v.notificationDetails",notifList); 
                
				//var cmpTarget = component.find('allTabId');
				//$A.util.addClass(cmpTarget, 'slds-active');
                //document.getElementById('allTabId').classList.add('slds-active');
                //var str = component.get("v.allTabTotal");
                
                //helper.getViewsList(component, event, helper);  	
            }
        });
        $A.enqueueAction(action);
    },
    addTab: function(component, event, labelName,viewName, viewId) {
        debugger;
        var tabId;
        $A.createComponent("lightning:tab", {
            "title" : viewName,
            "label": labelName,
            "id": "Id_"+viewName.replace(' ','_')+'#'+viewId,
            "onactive": component.getReference("c.addContent")
        }, function (newTab, status, error) {
            if (status === "SUCCESS") {
                debugger;
                var body = component.get("v.moretabs");
                component.set("v.moretabs", newTab);
                //component.set('v.selectedTabId',newTab.get('v.id'))
                component.set("v.selectTab",newTab.get('v.id'));
            } else {
                throw new Error(error);
            }
        });
    },
    getTableData : function(component,event,helper, viewId,viewName){
        component.set("v.toggleSpinner", true); 
        var action = component.get("c.getViewList");
        action.setParams({            
            contactIds: component.get('v.filterContacts'),
            viewId : viewId,
            userConfigRec:component.get('v.dashboardRec')
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var result = '';
                var res = [];
                var columns = response.getReturnValue();  
                for(var f in columns){
                    var labelVal = columns[f].customLabel != null ? columns[f].customLabel : columns[f].fieldApiLabel;                    
                    var fp = {label : labelVal, type : columns[f].fieldType, name : columns[f].fieldAPI};
                    res.push(fp);
                }
				debugger;
                console.log(res);
               // component.set("v.fieldSetValues", res);
                
                var chartEvent = $A.get("e.c:JO_PortfolioTabEvent");
                chartEvent.setParams({
                    data: {filter: res, name:viewName} 
                }); 
                chartEvent.fire();
                component.set("v.toggleSpinner", false); 
            }
        });
        $A.enqueueAction(action);
    }, 
    setViewList : function(component, views){
        debugger;
        var selectV = component.find('selectV').get('v.value'); 
        var selectedView = [];
        var isDefault = false;  
        var viewsList = [];    
        for(var f in views){ 
            if(views[f].viewName != 'Notifications' && views[f].viewName != 'All')
            {
                if(views[f].isDefault){
                    isDefault = true;
                    selectedView.push(views[f].viewId+'#'+views[f].count+'#'+views[f].viewName);  
                    component.find('selectV').set('v.value',selectedView[0]);
                    selectV = component.find('selectV').get('v.value'); 
                } 
                var isSelected = (selectV == views[f].viewId+'#'+views[f].count+'#'+views[f].viewName) ? true : false; //(? true :false)
                viewsList.push({ value : views[f].viewId+'#'+views[f].count+'#'+views[f].viewName, label: views[f].viewName, selected: isSelected}); 
            }
        }
        if(!isDefault){  
            isDefault = true;
            viewsList.unshift({ value :'--Select View--', label: '--Select View--'});
        }  
        component.set('v.viewList', viewsList);
        $A.enqueueAction(component.get('c.loadView'));   
    }
})