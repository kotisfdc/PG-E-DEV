({
    keyPressController : function(component, event, helper) {
        //  debugger;
        var getInputkeyWord = component.get("v.SearchKeyWord");
        if( getInputkeyWord.length > 0 )
        {
            
            component.set("v.Message","Search Result..");
            
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.getAllJobOwnerList(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", component.get("v.selectedRecord") ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    clear :function(component,event,helper){
        debugger; 
        var indexvar = event.getSource().get("v.name");	
        var listVal = component.get("v.selectedRecord");      
        listVal.splice(indexvar,1);
        component.set("v.selectedRecord",listVal);
        // component.set("v.SearchKeyWord",null);
        
        var compEvent = component.getEvent("sampleComponentEvent"); 
        compEvent.setParam("Conlist",component.get("v.selectedRecord"));
        compEvent.fire();
        
    },
    Addressdetails : function(component,event,helper){
        debugger;
        component.set("v.Message","Address details..");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
      //  $A.util.removeClass(forOpen, 'slds-is-close');
        var joCorpRec =  component.get('v.Addresslist');
        var arr=[];
        var i = 0;
        for (var key in joCorpRec)
        {
            if(joCorpRec[key].Email!=null )
            { 
                arr.push(joCorpRec[key]);
                i++;
            }     
        }                
        component.set('v.listOfSearchRecords',arr);
        
        console.log();
        
    },
    handleComponentEvent : function(component, event, helper) {
        debugger;
        var str = component.get("v.selectedRecord");       
        str.push( event.getParam("Con"));       
        component.set("v.selectedRecord" , str); 
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
    },
    inithandlerfun : function(component,event,getInputkeyWord){
        debugger;
        var action = component.get("c.getAllJobOwners");
        action.setParams({
            "RecId": component.get("v.customerId") == '' ? null : component.get("v.customerId"),
            "includejobcustomer": true
        });
        debugger;
        action.setCallback(this,function(response){
            if(response.getState()=== 'SUCCESS')
            {  
                debugger;
                var arr=[];                
                var joCorpRec = response.getReturnValue();
                component.set("v.allJobOwnerRecords",joCorpRec);
                var arr=[];
                
                var loggedInContact = component.get("v.customerId");
                for (var key in joCorpRec)
                {
                    if(joCorpRec[key].Id == null )
                    {
                        arr.push(joCorpRec[key]);
                        
                        console.log(arr);
                    } 
                    
                }    
                
                 component.set('v.Addresslist',arr);
                var compEvent = component.getEvent("sampleComponentEvent"); 
                compEvent.setParam("Conlist",component.get("v.selectedRecord"));
                compEvent.fire();
            }
            else{
                
            }
        });
        $A.enqueueAction(action);    
        
        
    },   
    selectContact :function(component,event,heplper){
        debugger; 
        var indexvar = event.getSource().get("v.name");	
        //alert(indexvar); 
        var listVal = component.get("v.listOfSearchRecords"); 
        var selcon = listVal[indexvar];
        // alert(listVal[indexvar].JO_Corp_ID__c);
        var str = component.get("v.selectedRecord");
        var i = 0;
        var isExist = false;
        for (var key3 in str)
        {
            if(str[key3].Email == selcon.Email)
            {
               
               i=i+1;
               isExist= true;
            }     
        }   
        if(!isExist)
        {    
            str.push(selcon);   
            for(var key4 in str){
                if(str[key4].FederationIdentifier == undefined){
                    str[key4].FederationIdentifier = str[key4].LastName;
                }
            }
            component.set("v.selectedRecord" , str); 
            
            // component.set("v.SearchKeyWord",null);
            component.set("v.listOfSearchRecords",null);
            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show'); 
        } 
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.SearchKeyWord", null);
        
        var compEvent = component.getEvent("sampleComponentEvent"); 
        compEvent.setParam("Conlist",component.get("v.selectedRecord"));
        compEvent.fire();
        
    },
})