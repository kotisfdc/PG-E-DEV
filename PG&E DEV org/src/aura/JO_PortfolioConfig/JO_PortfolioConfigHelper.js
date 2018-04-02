({
    generateView : function(component, event, helper) { 
        debugger;
        var dflst = component.get('v.portfolioList');  
        for(var df in dflst){ 
            if(dflst[df].isDefault == true){
                component.set('v.defaultPortfolio',dflst[df]);
                component.set('v.portfolio',component.get('v.defaultPortfolio')); 
                break;
            }
        }
        var pickVal = component.get('v.defaultPortfolio');
        var selectedPick = [];
        var allPick = [];
        for(var key in pickVal.viewfields)
        {
            debugger; 
            if(pickVal.viewfields[key].visible == true)
            {
                selectedPick.push(pickVal.viewfields[key].fieldAPI);
                allPick.push({ value : pickVal.viewfields[key].fieldAPI , label:  pickVal.viewfields[key].customLabel});
            }
            else
                allPick.push({ value : pickVal.viewfields[key].fieldAPI , label:  pickVal.viewfields[key].customLabel});
        }
        component.set("v.listOptions",allPick);
        component.set("v.defaultOptions",selectedPick);
        
        var selectedV = component.get('v.portfolio');
        var dfViewId = selectedV.isDefault == true ? selectedV.viewId : '';
        helper.selectViews(component, dflst, dfViewId);
    },
    cloneview : function(component, event, helper){
        debugger;
        var clonedPortfolio = {};
        var portfolio = component.get("v.defaultPortfolio");
        var  viewfields = portfolio.viewfields;
        for(var f in viewfields){
            clonedPortfolio.viewfields = viewfields;
        }
        clonedPortfolio.viewId = '';
        clonedPortfolio.viewName = "";
        clonedPortfolio.sortOrder = component.get('v.portfolioList').length;
        clonedPortfolio.isAdmin = false;
        clonedPortfolio.isDefault = false;
        clonedPortfolio.isActive = true;
        component.set('v.portfolio',clonedPortfolio);        
    },
    saveNewView : function(component, event, helper){
        debugger;
        var portfolio = component.get("v.portfolio");
        var portList = component.get('v.portfolioList');
        var extvar = false;
        var truecount = 0;
        for(var key in portfolio.viewfields)
        {
           if(portfolio.viewfields[key].customLabel == "" || portfolio.viewfields[key].customLabel == undefined)
           {
                extvar = true;
                helper.toatMsg(component, 'warning','Enter custom label value.');  
           }
           else if(portfolio.viewfields[key].visible == true)
           {
                truecount++;
           }
        }
        if(truecount == 0)
        {
            extvar = true;
            component.set('v.msg', 'Please select at least one column.');
            helper.toatMsg(component, 'warning','Please select at least one column.');
        }
        if(portfolio.viewName == undefined || portfolio.viewName == ""){
            component.set('v.msg', 'Enter view Name.'); 
            helper.toatMsg(component, 'warning','Enter view Name.');
        }
        else{
            var viewMap = component.get('v.viewMap');
            
            if(viewMap.get(portfolio.viewName) != null && (viewMap.get(portfolio.viewName).viewId == '' || portfolio.viewId !== viewMap.get(portfolio.viewName).viewId)){
                component.set('v.msg','duplicate View name');
                helper.toatMsg(component, 'warning','Duplicate View name');
            }
      
            else {
                if(extvar == false)
                {
                var action = component.get('c.saveView');
                action.setParams({
                    contactId : component.get('v.contactId'),
                    userConfigRec: component.get('v.dashboardRec'),
                    portfolio : JSON.stringify(portfolio)
                });
                action.setCallback(this,function(response){
                    debugger;
                    if(response.getState() == 'SUCCESS'){
                        debugger;
                        component.set('v.msg', 'View saved.');
                        helper.toatMsg(component, 'success','View saved.');
                        component.set('v.portfolio', response.getReturnValue());  
                        if(portfolio != undefined && portfolio != null )           
                            helper.removeElement(component,portfolio.viewId);
                        var oldvalue = component.get('v.portfolioList');
                        var newval = component.get('v.portfolio');
                        if(newval.isDefault == true){
                            for(var val in oldvalue)
                            {
                                if(oldvalue[val].viewName != "All")
                                {
                                    oldvalue[val].isDefault = false;
                                }
                            }
                        }
                        component.get('v.portfolioList').push(component.get('v.portfolio'));
                        component.set('v.aftersave',true);
                        debugger;
                        helper.selectViews(component, component.get('v.portfolioList'), component.get('v.portfolio').viewId);
                    }
                });
                $A.enqueueAction(action);
                }}        
        }

    }, 
    loadViewRec : function(component, event, helper){
        debugger;
        var dflst = component.get('v.portfolioList');
        var selectV = component.find('selectV').get('v.value');
        for(var df in dflst){
            if(dflst[df].viewId == selectV){ 
                if(dflst[df].viewName != 'All')
                {
                    component.set("v.editDisabled",false);
                }
                else component.set("v.editDisabled",true);
                component.set('v.portfolio',dflst[df]); 
                break;
            }
        }
        var pickVal = component.get('v.portfolio');
        var selectedPick = [];
        var allPick = [];
        pickVal.viewfields.sort(function(a, b) {
            debugger;
            var x = a['order']; 
            var y = b['order'];
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));
        })
        for(var key in pickVal.viewfields)
        {
            debugger; 
            if(pickVal.viewfields[key].fieldType == "LINK")
                continue;
            else{
                if(pickVal.viewfields[key].visible == true)
                {
                    selectedPick.push(pickVal.viewfields[key].fieldAPI);
                    allPick.push({ value : pickVal.viewfields[key].fieldAPI , label:  pickVal.viewfields[key].customLabel});
                }
                else
                    allPick.push({ value : pickVal.viewfields[key].fieldAPI , label:  pickVal.viewfields[key].customLabel});
                }
        }
        component.set("v.listOptions",allPick);
        component.set("v.defaultOptions",selectedPick);

        helper.selectViews(component, dflst, selectV);
    },
    selectViews : function(component, dflst, selectV){
        debugger;
        var vArr = [];
        var viewMap = new Map;
        for(var df in dflst){
            if(dflst[df].viewName != 'Notifications')
            {
                var isSelected = (selectV == dflst[df].viewId) ? true : false; //(? true :false)
                vArr.push({ value : dflst[df].viewId , label: dflst[df].viewName, selected: isSelected}); 
                viewMap.set(dflst[df].viewName, dflst[df]);
            }
            
        }
        component.set('v.viewMap', viewMap);
        component.set('v.viewList', vArr);
        if(component.get('v.aftersave') == true){
            var evnt = $A.get('e.c:JO_Portfolio_Config_Event');
            evnt.setParams({
                "portfolioList" : component.get('v.portfolioList'),             
            }); 
            evnt.fire(); 
        }
    },
    deleteViewRec : function(component, event, helper ){
        
        var selectV = component.find('selectV').get('v.value'); 
        var action = component.get('c.deleteViewRec');
        action.setParams({
            viewId : selectV
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                debugger;
                component.set('v.msg', 'View Deleted.');
                helper.toatMsg(component, 'success','View Deleted.');
                component.set('v.aftersave',true);
                helper.removeElement(component,response.getReturnValue());
                helper.generateView(component, event, helper );
            }
            else if(response.getState() == 'ERROR'){
                debugger;
                var error = response.getError();
                if(error){
                    if(error[0]  && error[0].message){
                        component.set('v.msg',error[0].message);
                        helper.toatMsg(component, 'error',error[0].message);
                    }
                }            
            }        
        });
        $A.enqueueAction(action);
    },
    removeElement : function(component,viewId){
        var finalLst = [];
        var dflst = component.get('v.portfolioList');
        for(var key in dflst){
            if(dflst[key].viewId != '' && dflst[key].viewId != viewId){
                finalLst.push(dflst[key]);  
            }
        }
        component.set('v.portfolioList',finalLst);
    },
    toatMsg : function(component, title, messagebody){
        $A.createComponent(
            "c:JO_Toastmsg",
            {
                "title": title,
                "body": messagebody
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
    } 
})