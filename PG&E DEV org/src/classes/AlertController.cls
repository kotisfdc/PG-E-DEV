public class AlertController {
    public static List<JO_Wrapper.JO_AlertCountWrapper> countOfAlerts = new List<JO_Wrapper.JO_AlertCountWrapper>();
    
    @AuraEnabled
    public static List<JO_Wrapper.JO_AlertCountWrapper> getjobAlerts(List<String> conatcIds, String loggedInContact, Customer_Config__c userConfigRec, String applName)
    {   
        system.debug('=====userConfigRec=====>'+userConfigRec);
        system.debug('applName====AlertController=>'+applName);
        system.debug(userConfigRec + ' conatcIds:'+conatcIds+' loggedInContact:'+loggedInContact);
        
        List<JO_Wrapper.JO_AlertCountWrapper> alertList = new List<JO_Wrapper.JO_AlertCountWrapper>();
        
        if(conatcIds.size() > 0)
        {
            List<String> contactSet = new List<String>();
            for(string str :conatcIds) contactSet.add('\''+str+'\'');
            
            alertList.addall(getjobAlertsbyDashboard(contactSet, loggedInContact, userConfigRec, applName, false));
            
        } 
        
        //system.debug('xxx'+alertList);
        if(alertList.size() > 0) {           
            for(JO_Wrapper.JO_AlertCountWrapper alert : alertList){    
                //system.debug('stdQuery:'+alert.alertQuery);
                AggregateResult ar = Database.query(alert.alertQuery);
                alert.alertCount = Integer.valueOf(ar.get('recs'));
                countOfAlerts.add(alert);
            }
        }
        
        system.debug('countOfAlerts'+countOfAlerts);
        
        return countOfAlerts; 
    }
    
    @AuraEnabled
    public static JO_Wrapper.JO_IdWrapper notificationQuery(String strQuery, list<String> jobOwnerIds, String applName)
    {
        JO_Wrapper.JO_IdWrapper IdWrapper = new JO_Wrapper.JO_IdWrapper();
        
        List<String> contactSet = new List<String>();
        if(String.isNotBlank(strQuery)){
            if(jobOwnerIds.size()>0){
                for(string str :jobOwnerIds)
                    contactSet.add('\''+str+'\'');
                strQuery+=' AND OwnerId IN '+contactSet +'AND RecordType.Name =: '+applName;
            }               
            system.debug('strQuery---->'+strQuery);
        }
        
        List<Alert__c> recs = (List<Alert__c>) Database.query(strQuery);
        if (recs == null)
            return IdWrapper;
        else
        {
            for(Alert__c r : recs)
            {
                if (r.Orders__c != null)
                    IdWrapper.orderNo.add(r.orders__r.Name);
                else
                    IdWrapper.notifyNo.add(r.Notifications__r.Name);
            }
        }
        return IdWrapper;
    }
    
    public static List<JO_Wrapper.JO_AlertCountWrapper> getjobAlertsbyDashboard(List<String> contactIds, String loggedInContact, Customer_Config__c userConfigRec, String applName, boolean ForConfig)
    {
       // system.debug('=====userConfigRec=====>'+userConfigRec);
        system.debug('applName=getjobAlertsbyDashboard=AlertController==>'+applName);
        Map<integer,JO_Wrapper.JO_AlertCountWrapper> alertlist = new Map<integer,JO_Wrapper.JO_AlertCountWrapper>();        
        List<Customer_Config__c> config = new List<Customer_Config__c> ();        
        config = [select id, name, Json_Config__c from Customer_Config__c where User_Config__c =: userConfigRec.id and RecordType.Name = 'JO Alert' and AppName__c=:applName];        
        system.debug('=====config=======>'+config);
        Map<Id,JO_Wrapper.JO_AlertConfigWrapper> alertmap = new Map<Id,JO_Wrapper.JO_AlertConfigWrapper>();
        
        if (config.size() > 0)
        {
            if(config[0].Json_Config__c != null){
                JO_Wrapper.JO_AlertConfigWrapperList alertwrapper = (JO_Wrapper.JO_AlertConfigWrapperList)JSON.deserialize(config[0].Json_Config__c, JO_Wrapper.JO_AlertConfigWrapperList.Class);
                for(JO_Wrapper.JO_AlertConfigWrapper a : alertwrapper.viewfields)
                {
                    system.debug('---Alert Map Custom Record --' + a);
                    alertmap.put(Id.valueof(a.id), a);
                }
            }
            else {
                throw new AuraHandledException('JSON Configuration Records is null');
            }
            
        }
        
        //system.debug('---Alert Map---' + alertmap);
        
        Map<Id,JO_Alert__c> master = new Map<Id,JO_Alert__c>();
        
        // Added Platform Cache for JO Alert Records
        // DO NOT TOUCH THIS WITHOUT APPROVAL
        // -------------------------------------------------
        
        Cache.OrgPartition orgPart = JO_Util.GetJOPartition();        
        if(orgPart != null)
            master = (Map<Id,JO_Alert__c>)orgPart.get('JOALERTMASTER');
        
        // Check the cache value that the get() call returned.
        if (master == null) 
        {
            master = new map<Id,JO_Alert__c>([SELECT id, Sort__c, Name, Group_by_query__c, Alert_Type__c, Query_String__c, Alert_Number__c, Alert_Is_Enabled__c, Priority__c
                                              FROM JO_Alert__c 
                                              WHERE Alert_Is_Enabled__c = True AND RecordType.Name =:applName
                                              ORDER BY Sort__c, Name ASC]);
            system.debug('master=======>'+master);
            if(orgPart != null)
                orgPart.put('JOALERTMASTER', master);
        } 
        
        ////////// ORG CACHE ////////////////////////////
        
        JO_Wrapper.JO_AlertCountWrapper twrap;
        
        integer rr = -1;
        for(JO_Alert__c taskcon : master.values())
        {
            rr++;
            
            if (alertmap.size() > 0 && !alertmap.containsKey(taskcon.id))
                continue;
            //system.debug('@@: '+alertmap.get(taskcon.id));   
            else{
                
                twrap = new JO_Wrapper.JO_AlertCountWrapper();
                twrap.alertId = taskcon.Id;
                twrap.alertName = taskcon.Name;
                twrap.alertCount = 0;
                twrap.alertNo = taskcon.Alert_Number__c;  
                twrap.notificationQuery = taskcon.Query_String__c;            
                JO_Wrapper.JO_AlertConfigWrapper xx = alertmap.get(taskcon.id);
                
                twrap.sortOrder = xx == null ? rr : xx.sortOrder;            
                twrap.alerttype = taskcon.Alert_Type__c;
                twrap.sysPriority = taskcon.Priority__c;
                twrap.selectedUserPriority = taskcon.Priority__c;
                
                
                //// FOR ALERT CONFIG POPUP 
                if (ForConfig)
                    twrap.alertQuery = taskcon.Group_by_query__c;
                else
                twrap.alertQuery = taskcon.Group_by_query__c+' AND OwnerId IN '+contactIds; 
                twrap.isenabled = taskcon.Alert_Is_Enabled__c;            
                JO_Wrapper.JO_AlertConfigWrapper j = alertmap.get(taskcon.id);
                
                // Set Alert Hidden variable based on default JO Alert or JSON Customization
                twrap.isHide = j == null ? true : j.isHidden;   
            }
            
            alertList.put(twrap.sortOrder, twrap);
        } 
        system.debug('------- WARPPER ----- ' + alertList);        
        Set<integer> setid = alertList.keyset();        
        List<JO_Wrapper.JO_AlertCountWrapper> finallist = new List<JO_Wrapper.JO_AlertCountWrapper>();        
        List<Integer> ls = new List<integer>();        
        ls.addAll(setid);
        ls.sort();  
        for(integer i : ls)
        {
            finallist.add(alertList.get(i));            
        }   
        return finallist;       
    }
    
    
    
    
}