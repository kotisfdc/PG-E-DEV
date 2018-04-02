({
    filterAction : function(component, event, helper) {
        debugger;
        helper.showWaiting(component, event, helper);
        helper.displayBarchart(component, event, helper);
        var Outstan = ($A.get('$Label.c.JO_Permit_ChartMenuLabelsOutstanding'));
        component.set('v.OutStanding',Outstan);
        var div = ($A.get('$Label.c.JO_Permit_ChartMenuLabelsDivision'));
        component.set('v.Division',div);
        var age = ($A.get('$Label.c.JO_Permit_ChartMenuLabelsAgency'));
        component.set('v.Agency',age);
    },
    scriptsLoaded : function(component,event,helper){
        debugger;
        component.set("v.checkload",true);        
        if(component.get("v.checkload") == true)
            helper.loadBarChart(component, event, helper);       
    },
    togglePieChart: function(component,event,helper){        
        component.set("v.renderCharts",false);        
        helper.loadPieChart(component,event,helper);
    },
    toggleBarChart: function(component,event,helper){
        component.set("v.renderCharts",true);
        helper.loadBarChart(component, event, helper); 
    },  
   
    openModelTask : function (component,event,helper){
        $A.createComponent(
            "c:JO_HelpModel",
            {
                "title": 'Chart Help',
                "body": $A.get('$Label.c.HelpTextForGraph')
            },
            function(msgBox){                
                if (component.isValid()) {
                    var targetCmp = component.find('ModalDialogPlaceholder');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                }
            }
        );
    },
    
    openGraphConfig: function(component,event,helper){
        debugger;
        $A.createComponent(
            "c:JO_GraphConfig",
            {
                "aura:id": "dynamicChild",
                "title": 'Configure Graph',
                "loggedInContact": component.get('v.loggedInContact'),
                "jobOwnerIds": component.get('v.jobOwnerIds'),
                "dashboardRec": component.get('v.dashboardRec')
            },
            function(messageBox){
                if(component.isValid()){
                    var targetComp = component.find('displayGraphConfigModal');
                    var body = targetComp.get("v.body");
                    body.push(messageBox);
                    targetComp.set('v.body',body);
                    
                    for(var i in body){
                        var dynaC = body[i].find('dynamicChild');
                        if(dynaC != undefined)
                            dynaC.doIntOnLoad();
                    }
                    
                }
            }
        )
    },
    fetchNotificationIds: function(component,event,helper){
        debugger;      
        var action = component.get('c.fetchNotificationLsts');
        action.setParams({
            jobOwnerId: component.get('v.jobOwnerIds'),
            selectedStatus: event.getParams().SelectedStatus
        });
        event.stopPropagation();
        action.setCallback(this , function(response){        
            if(response.getState() == 'SUCCESS'){            
                debugger;
                component.set('v.selectedStatus',response.getReturnValue());          
                var evnt = $A.get("e.c:JO_TaskEvent");
                evnt.setParams({ 
                    "jobOwnerIds" : component.get('v.jobOwnerIds'),
                    "notificationIds" : response.getReturnValue(),
                    
                });        
                evnt.fire();
                console.log('Success in fetchNotificationIds:'+response.getState());
            }
            else{
                console.log('Error in fetchNotificationIds:'+response.getState());
            } 
        });
        $A.enqueueAction(action);
    },
    
    handleMenuSelect : function(component,event,helper)
    {
        debugger;  
        var menuItem = event.getParam("value");
        var myoutlab = ($A.get('$Label.c.JO_Permit_ChartMenuLabelsOutstanding'));
        var mydivlab = ($A.get('$Label.c.JO_Permit_ChartMenuLabelsDivision'));
        var myagelab = ($A.get('$Label.c.JO_Permit_ChartMenuLabelsAgency'));
        debugger;
        if(menuItem === myoutlab)
        {   
             $("#Outstandingchart1").css({"height":"240px","visibility": " visible"});
             $("#Outstandingdivchart1").css({"height":"0px","visibility": "collapse"});
           component.set('v.permittsByOutstandingLabel',true);
            component.set('v.PermittsByDivisionLabel',false);
            component.set('v.PermittsByAgencyLabel',false);
            component.set('v.projects',false);
           helper.loadStackedBarChart(component, event, helper); 
        }
        else if( menuItem === mydivlab)
        {  
            $("#Outstandingdivchart1").css({"height":"240px","visibility": " visible"});
             $("#Outstandingchart1").css({"height":"0px","visibility": "collapse"});
            component.set('v.PermittsByDivisionLabel',true);
            component.set('v.permittsByOutstandingLabel',false);
            component.set('v.PermittsByAgencyLabel',false);
            component.set('v.projects',false);
            helper.loadStackedBarChartDivision(component, event, helper);
         }
            else if (menuItem === myagelab)
            {
                 $("#Outstandingdivchart1").css({"height":"240px","visibility": " visible"});
                 $("#Outstandingchart1").css({"height":"0px","visibility": "collapse"});
                component.set('v.PermittsByAgencyLabel',true);
                helper.loadStackedBarChartAgency(component, event, helper);
                component.set('v.permittsByOutstandingLabel',false);
                component.set('v.PermittsByDivisionLabel',false);
                component.set('v.projects',false); 
            }
            else
            {
                    component.set('v.projects',true);
                    component.set('v.permittsByOutstandingLabel',false);
                    component.set('v.PermittsByDivisionLabel',false);
                    component.set('v.PermittsByAgencyLabel',false);  
                    component.set("v.renderCharts",false);  
            }
        
    },
  
})