({
    getDashboardViews : function(component, event, helper){
        debugger;
        var action = component.get('c.getDashboardViews');
        action.setParams({
            contactId : component.get('v.loggedInContact')
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                component.set('v.dashboardViews',response.getReturnValue());
                var dashboardViews = component.get("v.dashboardViews");
                if(component.get('v.dashboardViews').length > 0){
                    for(var key in dashboardViews)
                    {
                        if(dashboardViews[key].Is_Default__c == true && dashboardViews[key].Is_Admin__c == false){
                            component.set("v.defaultSelection",dashboardViews[key].Id);
                            component.set('v.selectedDashboard', dashboardViews[key].Id); 
                            component.set('v.userConfigRec', dashboardViews[key]);
                            component.set('v.dashboardId',dashboardViews[key].Id);
                            component.set('v.jsonconfigids',dashboardViews[key].Json_Config__c);
                        }
                    }
                    if(component.get("v.defaultSelection") == undefined)
                    {
                        for(var key in dashboardViews){
                            if (dashboardViews[key].Is_Admin__c == true ) {
                                component.set("v.defaultSelection",dashboardViews[key].Id);
                                component.set('v.selectedDashboard', dashboardViews[key].Id); 
                                component.set('v.userConfigRec', dashboardViews[key]);
                                component.set('v.dashboardId',dashboardViews[key].Id);
                                component.set('v.jsonconfigids',dashboardViews[key].Json_Config__c);
                            } 
                            
                        }
                        
                    }
                    //Add additional Logic
                    var dashRec = [];
                    debugger;
                    for(var res in dashboardViews)
                    {
                        var isSelected = dashboardViews[res].Id == component.get('v.dashboardId') ? true : false;
                        dashRec.push({value:dashboardViews[res].Id, label:dashboardViews[res].View_Name__c,selected:isSelected});
                    }
                    component.set('v.dashbdLst',dashRec);
                    var jonLst = []; 
                    var selectedJob ='';
                    
                    var jobOwn =   component.get('v.userConfigRec');
                    if(jobOwn.Json_Config__c != null){
                        selectedJob = jobOwn.Json_Config__c;
                    }
                    
                    if(selectedJob.includes(','))
                    {
                        jonLst = selectedJob.split(',');
                    }
                    else jonLst.push(selectedJob);
                    component.set('v.selectedJobOwnerId',jonLst);
                    var jobOwnerList = [];
                    var jobOwnerlst =component.get('v.allJobOwnerRecords');  
                    
                    for(var key in jobOwnerlst){
                        var isSelected = jonLst.includes(jobOwnerlst[key].Id) ? true : false;
                        jobOwnerList.push({value:jobOwnerlst[key].Id, label:jobOwnerlst[key].JO_Corp_ID__c +'-'+ jobOwnerlst[key].FirstName+' '+jobOwnerlst[key].LastName,selected:isSelected});                   
                        
                    } 
                    component.set('v.allJobOwners',jobOwnerList);
                    // component.set('v.selectedJobOwnerId',component.get('v.loggedInContact')); 
                    helper.globalCompEvent(component, event, helper, component.get('v.loggedInContact'), component.get('v.selectedJobOwnerId'), component.get('v.userConfigRec'));
                }
                else helper.toastMSG(component, event, helper, 'error', 'Configuration records are not available');
            }
            else if(response.getState() == 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {                        
                        helper.toastMSG(component, event, helper, 'error', errors[0].message);
                    } else if (errors[0] && errors[0].pageErrors) {

                        // DML Error
                        // （This sample code is corner-cutting. It does not consider the errors in multiple records and fields.）
                        helper.toastMSG(component, event, helper, 'error', errors[0].pageErrors[0].message);

                    }
                    
                } else {
                    console.log("Unknown error");
                }
            }
			 helper.generatedropdown(component, event, helper);
        });
        $A.enqueueAction(action);
    },

    refreshJOBFinal : function (component, event, helper,typeAction){
        debugger;
        
        var jobOwnerRecs = component.get("v.allJobOwnerRecords");
        if(typeAction != 'Event')
        {
            var selectedDashboardId = component.find('selectV').get('v.value');
            
            if(selectedDashboardId != "" || selectedDashboardId != undefined)
            {
                component.set('v.defaultSelection',selectedDashboardId);
                component.set('v.dashboardId',selectedDashboardId); 
            }
        }
        
        var selectedDashboard = component.get("v.dashboardViews");  
        /*var selectedContact = $('[id$=picklist]').select2("val");
        component.set('v.selectedJobOwnerId',selectedContact);*/ 
        var jonLst = []; 
        for(var key in selectedDashboard)
        {
            if(selectedDashboard[key].Id == component.get('v.dashboardId')){
                component.set("v.userConfigRec",selectedDashboard[key]);  
                
            }
        }
        var selectedJob =  component.get("v.userConfigRec").Json_Config__c;
        if(selectedJob.includes(','))
        {
            jonLst = selectedJob.split(',');
        }
        else jonLst.push(selectedJob);
        component.set('v.selectedJobOwnerId',jonLst);
        
        var jobOwnerList =[];
        var jobsOW = component.get("v.allJobOwnerRecords");
        for (var key in jobsOW) {
            var isSelected = (jonLst.includes(jobsOW[key].Id)) ? true : false;
            jobOwnerList.push({value:jobsOW[key].Id, label:jobsOW[key].JO_Corp_ID__c +'-'+ jobsOW[key].FirstName+' '+jobsOW[key].LastName,selected:isSelected});                   
        }
        component.set('v.allJobOwners',jobOwnerList); 
        
        helper.globalCompEvent(component, event, helper, component.get('v.loggedInContact'), component.get("v.selectedJobOwnerId"), component.get("v.userConfigRec"));        
    },
    globalCompEvent : function(component, event, helper, loggedInContact, jobOwnerIds, dashboardId){  
        debugger;       
        var evnt = $A.get('e.c:JO_GlobalFilterEvent');
        evnt.setParams({
            "loggedInContact" : loggedInContact,
            "jobOwnerIds" : jobOwnerIds,
            "dashboardId" : dashboardId
        });        
        evnt.fire();
    },
    openDashBoardModel : function(component, event, helper){
        debugger;
        var selectedids = component.get('v.selectedJobOwnerId');
        //var selectedConatct = $('[id$=picklist]').select2("val");
        //component.set('v.selectedJobOwnerId',selectedConatct);
        $A.createComponent(
            "c:JO_Dashboard_Config",
            {
                'aura:id': 'dynamicChild',
                'title' : 'Dashboard Configuration',
                'dashboardId' : component.get("v.dashboardId"),   //'0032F000005tC2F' //component.get('v.contactId')
                'loggedInContact': component.get("v.loggedInContact"),
                'globalFilterContacts': component.get("v.selectedJobOwnerId"),
                'dashboardRecords': component.get("v.dashboardViews")
                //'dashboardRec': component.get('v.dashboardRec')
            },
            function(msgBox){
                if(component.isValid()){
                    var targetCmp = component.find('dashboardBody');
                    var body = targetCmp.get('v.body');
                    body.push(msgBox);
                    targetCmp.set('v.body', body);
                }
                for(var i in body){
                    debugger;
                    var dynaC = body[i].find('dynamicChild');
                    if(dynaC != undefined)
                        dynaC.doIntOnLoad();
                }
            }
        );
    },
    
    updateOptions : function(component, helper){ 
        debugger;
        var newOption = component.get("v.dashboardViews");        
        component.set("v.dashboardViews",newOption);
    },
    toastMSG : function (component, event, helper,  title, msg){
        $A.createComponent(
            "c:JO_Toastmsg",
            {
                "title": title,
                "body": msg
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
    },
    promptMSG : function (component, event, helper, title, type, msg){
        var action = component.get('c.newDashboardRecord');
        debugger;
        action.setParams({
            "dashboardId" : '',
            "dashboardName" : 'Default',
            "dashboardActive" : true,               
            "loggedInContact" : component.get('v.loggedInContact'),
            "globalFilterRecs" : [].push(component.get('v.loggedInContact')),
            "dashboardDefault" : false,
            "typestr": 'new'
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                debugger;
                var result = response.getReturnValue();
                if(component.get('v.dashboardActive')){
                    var evnt = $A.get('e.c:JO_Dashboard_ConfigEvnt');
                    evnt.setParams({ 
                        "optiontoAdd" : result,
                        "typeofAction" : component.get('v.typeStr')
                    });        
                    evnt.fire();
                }
                component.destroy();
            }
        });
        $A.enqueueAction(action);
        $A.createComponent(
            "c:JO_Prompt",
            {
                "title": title,
                "type": type,
                "body": msg
            },
            function(msgBox){                
                if (component.isValid()) {
                    var targetCmp = component.find('promptMsg');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                }
            }
        );
    },
    pollingApex : function(component, event, helper) { 
        helper.sapSyncTimeFn(component, event, helper);
        
        //execute sapSyncTimeFn() again after 5 sec each
        window.setInterval(
            $A.getCallback(function() { 
              helper.sapSyncTimeFn(component, event, helper);
            }), 10000
        );  
    },    
    sapSyncTimeFn : function(component, event, helper){
        var action = component.get('c.getSAPSyncTime');
        action.setParams({
            loggedInContact : component.get('v.loggedInContact')
        });
        action.setCallback(this, function(response){
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                var syncSettings = response.getReturnValue(); 
                if(syncSettings.Id != undefined && syncSettings != null && syncSettings != undefined){
                   helper.setSyncData(component, event, helper, syncSettings);
                }
                else { 
                    component.set('v.isUpTodate',false); 
                    component.set('v.sapSyncTime',''); 
                    helper.toastMSG(component, event, helper, 'warning', 'SAP and JO Dashboard Not in Sync.');
                }
            }
        });
        $A.enqueueAction(action);
    },
    setSyncData : function(component, event, helper, syncSettings) {
         component.set('v.settings',syncSettings);
        if(syncSettings.SAP_Data_SyncTime__c != undefined){
            var timezone = $A.get('$Locale.timezone');
            var mydate = component.get('v.settings').SAP_Data_SyncTime__c; // .toLocaleString({timeZone: timezone})
            //debugger;
            var dd = Date.parse(mydate);
            
            component.set('v.isUpTodate', parseInt(Date.parse(new Date())) < parseInt(dd) + (component.get('v.settings').Sync_Time_Limit__c * 60000) ? true : false); 
            component.set('v.sapSyncTime',mydate); 
        }
        else {
            debugger;
            component.set('v.isUpTodate',false);
            var cmp = component.find('syncId');
            $A.util.toggleClass(cmp, 'syncCLSError') 
            //helper.toastMSG(component, event, helper, 'error', syncSettings.Status__c+' : SAP Synced  0 records and with error(s).');
        }
        
    },
     generatedropdown : function(component, event, helper)
    {
        debugger;
        var dataGrid;
        $("#gridBox").dxDropDownBox({
            value: component.get("v.loggedInContact"),
            valueExpr: "Id",
            placeholder: "Select a value...",
            displayExpr: "FederationIdentifier",
            showClearButton: false,
            opened: true,
            dropDownOptions: {
                closeOnOutsideClick: false
            },
            dataSource: new DevExpress.data.ArrayStore({
                data: component.get("v.allJobOwnerRecords"),
                key: "Id"
            }),
            onOpened: function (ev) { setTimeout(function() { ev.component.content().parent().width(300) });},
            contentTemplate: function(e){
                debugger;
                var selectedrows = [];
                var value = e.component.option("value"),
                    $dataGrid = $("<div>").dxDataGrid({
                        dataSource: e.component.option("dataSource"),
                        columns: [{dataField: "Name",caption:"Job Owner Name"},{dataField: "FederationIdentifier",caption:"LAN Id"}],
                        hoverStateEnabled: true,
                        paging: { enabled: true, pageSize: 10 },
                        filterRow: { visible: true },
                        scrolling: { mode: "infinite" },
                        height: 250,
                        width: 300,
                        selection: { mode: "multiple" },
                        selectedRowKeys: value,
                        onToolbarPreparing: function(edsd) {
                            edsd.toolbarOptions.items.push({
                                location: "center",
                                widget: "dxButton",
                                options: {
                                    text: "OK",
                                    onInitialized: function(esss) {
                                    },
                                    onClick: function(easa) {
                                        debugger;
                                        var idval = component.get("v.idlist");
                                        var limit = $A.get("$Label.c.JO_Owner_Limit");
                                        if(idval != null && idval.length > 0){
                                            if(idval.length <= parseInt(limit)){
                                                component.set('v.fedaralList',idval);
                                                var idsonly = [];
                                                for(var v in idval)
                                                {
                                                    idsonly.push(idval[v].Id);
                                                }
                                                if(idsonly.length > 0){
                                                    e.component.option("value", idsonly);
                                                    component.set("v.selectedownerids",idsonly);
                                                    component.set('v.selectedJobOwnerId',idsonly);
                                                }
                                                $("#gridBox").dxDropDownBox("instance").option("opened", false);
                                            }
                                            else
                                            {
                                                alert($A.get("$Label.c.JO_Owner_Limit_Error_Message"));
                                                //helper.toastMSG(component, event, helper, 'Warning', 'Cannot select more than 4 Job Owners..!!!');
                                            }
                                        }
                                        else
                                        {
                                            //helper.toastMSG(component, event, helper, 'Warning', 'Job Owner Required..!!!');
                                            alert($A.get("$Label.c.JO_Owner_Required_Message"));
                                        }
                                    }
                                }
                            },{
                                location: "center",
                                widget: "dxButton",
                                options: {
                                    text: "Cancel",
                                    onInitialized: function(esss) {
                                    },
                                    onClick: function(easa) {
                                        debugger;
                                        $("#gridBox").dxDropDownBox("instance").option("opened", false);
                                        var selectedval = component.get("v.selectedownerids");
                                        var uncheck = [];
                                        if(selectedval != null && selectedval.length > 0)
                                        {
                                            for(var v in selectedrows)
                                            {
                                                if(selectedval.indexOf(selectedrows[v]) > -1)
                                                {} 
                                                else
                                                {
                                                    uncheck.push(selectedrows[v]);
                                                }
                                            }
                                            if(uncheck.length >0 )
                                                dataGrid.deselectRows(uncheck);
                                            if(selectedrows.length < selectedval.length)
                                            {
                                                dataGrid.selectRows(selectedval);
                                            }
                                        }
                                    }
                                }
                            });
                        },
                        onSelectionChanged: function(selectedItems){
                            debugger;
                            if(component.get("v.idlist") == null)
                                $("#gridBox").dxDropDownBox("instance").option("opened", false);
                            var keys = selectedItems.selectedRowKeys;
                            selectedrows;
                            selectedrows = keys;
                            component.set("v.idlist",selectedItems.selectedRowsData);
                            if(component.get('v.fedaralList').length == 0)
                                component.set('v.fedaralList',selectedItems.selectedRowsData);
                            /*  var keys = selectedItems.selectedRowKeys;
                            e.component.option("value", keys);
                            component.set('v.selectedJobOwnerId',selectedItems.selectedRowKeys);
                            component.set('v.fedaralList',selectedItems.selectedRowsData);*/
                        }
                    });
                dataGrid = $dataGrid.dxDataGrid("instance");
                e.component.on("valueChanged", function(args){
                    var value = args.value;
                    dataGrid.selectRows(value, false);
                });
                return $dataGrid;
            }
        }).dxDropDownBox('instance');
        if(component.get("v.jsonconfigids") != null)
        {
            var str_array = component.get("v.jsonconfigids").split(',');
            $("#gridBox").dxDropDownBox("instance").option("value", str_array);//component.get("v.jsonconfigids")
            component.set("v.selectedownerids",str_array);
            component.set('v.selectedJobOwnerId',str_array);
        }
    }
})