({
    scriptsLoaded : function(component, event, helper) 
    {   
        component.set("v.idWrapper",null);
        helper.fetchNotification(component, event, helper);
    },
    doInit : function(component, event, helper){
        debugger;
        if(event.getParams() != undefined && event.getType() != "aura:methodCall" && event.getType() != "aura:valueInit"){
            var params = event.getParams().notificationIds;
            component.set("v.idWrapper",JSON.stringify(params));
            event.stopPropagation(); 
           	
            /*if(component.get('v.tableRecords').length > 0){
                var nrecords = component.get('v.tableRecords')
                var selectRec = [];
                for(var i in nrecords){
                    for(var j in params){
                        if(nrecords[i].Id == params[j])
                            selectRec.push(nrecords[i]);
                    }                
                }
                helper.pagination(component,event,helper, selectRec);
                component.set('v.PaginationList', selectRec);
            }*/
            //helper.fetchNotification(component, event, helper);
           
            helper.dataGridBuilder(component, event, helper, component.get('v.gridData'),component.get('v.portfoliofields'),component.get('v.viewname'));
        } 
        else{
            component.set("v.idWrapper",null);
            //dataGrid.clearFilter();
            helper.fetchNotification(component, event, helper);
        }
    },
    doInit1 : function(component, event, helper){
        debugger;
         var params = event.getParam('data');
        var stage;
        if(params != undefined){
            if(event.getParam('data') != undefined)
                stage = event.getParam('data').colvals;
        }
        console.log('fields:'+stage);

        var viewname = params.name;
        component.set('v.portfoliofields',stage);
        component.set('v.viewname',viewname);
        //if(stage != undefined && stage.length > 0 &&  component.get('v.gridData') != undefined)
        if(component.get("v.onetimeload") == false)   
        helper.fetchNotification(component, event, helper);
           // helper.dataGridBuilder(component, event, helper, component.get('v.gridData'),stage,viewname);
    }
})