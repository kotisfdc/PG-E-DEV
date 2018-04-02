({ 
    displayAllTabsData : function(component, event, helper){
      helper.getViewsList(component, event, helper);
    },    
    linkToSAP : function(component, event){ 
        debugger;
        var notifyVal = event.getSource().get("v.value")
        component.set('v.sapLink','https://sapdv8db1.comp.pge.com:1443/sap/bc/gui/sap/its/webgui?transaction='+notifyVal);
        window.open(component.get('v.sapLink'));  
    },    
    displaydetailpage : function(component, event, helper){        
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.recid;
        window.open("/"+recId);       
    },
    reFireGlobalEvent : function (component, event, helper){
        //var evnt = $A.get('e.c:JO_RefreshEvent');
       // evnt.fire();
        //helper.getTableData (component, event, helper);
        var evnt = $A.get('e.c:JO_TaskEvent');
        evnt.setParams({ 
            "jobOwnerIds" : '',
            "notificationIds" : ''
        });       
        evnt.fire();
      //  var childComponent = component.find("porforlioGridId");
     //  childComponent.fetchTaskEventData('Notifications__c',component.get('v.fieldSetValues'),component.get('v.filterContacts'),component.get('v.dashboardRec'));
    },
    
    openModelTask : function (component,event,helper){
        $A.createComponent(
            "c:JO_HelpModel",
            {
                "title": 'Portfolio Help',
                "body": $A.get('$Label.c.JoDashHelpTextForPortfolio')
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
    viewSettings :function (component, event, helper){
        debugger;
        var portfolio = component.get("v.body");
        $A.createComponent(
            "c:JO_HelpModel",
            {
                "title": 'Portfolio',
                "body":  portfolio
            },
            function(msgBox){                
                if (component.isValid()) {
                    var targetCmp = component.find('PortfolioPopOut');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                }
            }
        );        
    },
    openModel : function(component, event, helper) {
        debugger;
		$A.createComponent(
            "c:JO_PortfolioConfig",
            {   
                'aura:id': 'dynamicChild',
                'title' : 'Portfolio Configuration',
                'contactId' : component.get("v.loggedInContact"),
                'portfolioList': component.get('v.portfolioList'),
                'dashboardRec': component.get('v.dashboardRec')
            },
            function(msgBox){
                if(component.isValid()){
                    var targetCmp = component.find('pfbody');
                    var body = targetCmp.get('v.body');
                    body.push(msgBox);
                    targetCmp.set('v.body', body); 
                }
                /*for(var i in body){
                   var dynaC = body[i].find('dynamicChild');
                   if(dynaC != undefined)
                       dynaC.doIntOnLoad();
                }*/
            }
        );
	},
    loadView : function(component, event,helper) {
        debugger;
        var selectVC = component.find('selectV').get('v.value'); 

        selectVC = selectVC != '' && selectVC != undefined ? selectVC : isSelected[0];
        var pickVal =  selectVC.split('#');
        var viewName = pickVal[2]+'('+pickVal[1]+')';
		
        helper.getTableData(component, event,helper, pickVal[0],pickVal[2]);
        
        /*if(selectVC != 'None' && selectVC != 'All') {            
            helper.addTab(component, event,viewName,pickVal[2], pickVal[0]); 
        }*/
    }, 
    addContent : function(component, event,helper) {       
        var tab = event.getSource();
        switch (tab.get('v.id')){
            case tab.get('v.id'):                
                //console.table(component.get('v.all'));
                helper.getTableData(component, event,helper, tab.get('v.id').split('#')[1]);
                $A.createComponent(
                    "c:JO_PortfolioDevGrid",
                    {   
                        'sObjectName':"Notifications__c",
                        'fieldSetValues':component.get('v.fieldSetValues'),
                        'contactIds':component.get('v.filterContacts'),
                        'userConfigRec':component.get('v.dashboardRec'),
                        'aura:id':"porforlioGridId"
                    },
                    function(datatable){
                        debugger;
                        if(component.isValid()){
                            tab.set('v.body', datatable);
                        }
                        /*for(var i in body){
                           var dynaC = body[i].find('dynamicChild');
                           if(dynaC != undefined)
                              dynaC.doIntOnLoad();
                        }*/
                    }
                );   
                break;
            default : break;
        }
    },
    handleSelectedTabIdChange : function(component, event,helper) {    
        var selected = component.get("v.selectTab");
    },
    refreshListViews : function(component, event,helper) {
        debugger;

        component.set('v.portfolioList',{});
        component.set('v.portfolioList', event.getParams().portfolioList);
        event.stopPropagation();
        var selectV = component.find('selectV').get('v.value'); 

        helper.setViewList(component, component.get('v.portfolioList'));
        
        if(selectV != undefined && selectV != '' && selectV != 'No ListViews')
            $A.enqueueAction(component.get('c.loadView'));    
    }
})