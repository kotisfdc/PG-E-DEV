public class GlobalFilters {
    @AuraEnabled
    public static JO_SAPSyncTime__c getSAPSyncTime(String loggedInContact){
        loggedInContact = loggedInContact != null ? loggedInContact : Userinfo.getUserId();
        JO_SAPSyncTime__c setting = JO_SAPSyncTime__c.getInstance(loggedInContact);
        // system.debug('setting:'+setting);
        return setting == null ? new JO_SAPSyncTime__c() : setting; 
    }
    @AuraEnabled 
    public static Id getLoogedInContact(){
        return Userinfo.getUserId();
    }
    
    @AuraEnabled
    public static List<User> getAllJobOwners() {
        List<User> jobOwnersList = new List<User>();
        for(User jUser :[SELECT Id, Name, FederationIdentifier FROM User WHERE Id In 
                         (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN('JO_Admin','JO_User'))]){
                             jobOwnersList.add(jUser);
                             
                         }
        return jobOwnersList;
    }
    
    /************** To get Logged In user as default Job owner In global filters***************/
    @AuraEnabled
    public static String getloggedUser(){        
        return JO_Util.getLoggedInContact(UserInfo.getUserId());
    }
    @AuraEnabled
    public static List<Customer_Config__c> getDashboardViews(String contactId, string applname){
        system.debug('@@Id: '+contactId);
        system.debug('Application Name===>'+applName);
        List<Customer_Config__c> config = new List<Customer_Config__c>();
        config = [SELECT Id, View_Name__c, User_Config__c, Is_Active__c, Is_Admin__c, Is_Default__c, Json_Config__c
                  FROM Customer_Config__c WHERE RecordType.DeveloperName='JO_Dashboard' AND OwnerId = :contactId AND Is_Active__c = true AND appName__c=:applName order by Is_Default__c desc];
        
        system.debug('===config====>'+config);
        if(config.Size() == 0)
        {
            if(applname != null){
                Customer_Config__c newConfig = new Customer_Config__c();
                newConfig.View_Name__c = 'Default';
                newConfig.Json_Config__c = UserInfo.getUserId();
                newConfig.OwnerId = UserInfo.getUserId();
                newConfig.Is_Admin__c = true;
                newConfig.Is_Default__c = true;
                newConfig.Is_Active__c = true;
                newConfig.AppName__c = applName;
                newConfig.RecordTypeId = JO_Util.getRecordTypeId('Customer_Config__c', 'JO Dashboard' );
                insert newConfig;
                if(newConfig.Id != null)
                    config.add(newConfig);
            }
        }
        return config;  
    }
    @AuraEnabled
    public static List<Customer_Config__c> newDashboardRecord(String dashboardId, String dashboardName, boolean dashboardActive, String loggedInContact, List<String> globalFilterRecs, boolean dashboardDefault, String applName, String typestr)
    { 
      //  String applname1 = 'Job Owner Dashboard';
        //system.debug('Starting in method'+dashboardId);
        List<Customer_Config__c> returnConfig = new List<Customer_Config__c>();
        List<Customer_Config__c> updateConfig = new List<Customer_Config__c>();
        List<Customer_Config__c> relatedCustomConfig = new List<Customer_Config__c>();  
        string filteredJobOwners = '';
        for(String jb : globalFilterRecs){filteredJobOwners += jb+',';}
        filteredJobOwners = filteredJobOwners.removeEnd(',');
        if(typestr == 'New')
        {
            if(dashboardDefault == true)
            {
                List<Customer_Config__c> configrec = [Select Id,User_Config__c,Is_Active__c, Is_Admin__c, RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c 
                                                      From Customer_Config__c 
                                                      Where OwnerId =:loggedInContact AND Is_Default__c=true AND appName__c=:applName];
                if(configrec.size() > 0)
                {
                    configrec[0].Is_Default__c = false;
                    upsert configrec;
                }
            }
            
            Customer_Config__c configDashboard = new Customer_Config__c();
            configDashboard.View_Name__c = dashboardName;
            configDashboard.Json_Config__c = filteredJobOwners;
            configDashboard.Is_Active__c = dashboardActive;
            configDashboard.Is_Default__c = dashboardDefault;
            configDashboard.Is_Admin__c = false;
            configDashboard.AppName__c = applName;
            configDashboard.RecordTypeId = JO_Util.getRecordTypeId('Customer_Config__c', 'JO Dashboard');
            upsert configDashboard;
            returnConfig.add(configDashboard);
            for(Customer_Config__c conf :[Select Id,User_Config__c,Is_Active__c, Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c 
                                          From Customer_Config__c Where User_Config__c=:dashboardId].clone()){
                                              conf.Id = null;
                                              conf.User_Config__c = configDashboard.Id; 
                                              conf.AppName__c = applName;
                                              relatedCustomConfig.add(conf);
                                          }
            upsert relatedCustomConfig;
            
        }
        if(typestr == 'Edit')
        {
            // system.debug('>>>>>>>>'+dashboardId);
            Customer_Config__c conf = [Select Id,User_Config__c,Is_Active__c, Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c 
                                       From Customer_Config__c Where Id=:dashboardId];
            // system.debug('>>>>>'+conf);
            if(conf.Is_Default__c == dashboardDefault && dashboardDefault == true)
            {
                system.debug('>>>>>InsideOe'+conf);
                conf.View_Name__c = dashboardName;
                conf.Is_Active__c = dashboardActive;
                conf.Is_Default__c = dashboardDefault;
                conf.Json_Config__c = filteredJobOwners;
                updateConfig.add(conf);
                update updateConfig;
                returnConfig.add(conf);
            }
            else if(dashboardDefault == true)
            {
                //   system.debug('>>>>loggedInContact'+loggedInContact);
                List<Customer_Config__c> configrecEdit = [Select Id,User_Config__c,Is_Active__c, Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c 
                                                          From Customer_Config__c Where OwnerId=:loggedInContact AND Is_Default__c=true AND RecordType.Name='JO Dashboard' AND Is_Admin__c=false];
                
                if(configrecEdit.size() > 0)
                {
                    configrecEdit[0].Is_Default__c = false;
                    upsert configrecEdit;
                } 
                //     system.debug('>>>>'+configrecEdit);
                conf.View_Name__c = dashboardName;
                conf.Is_Active__c = dashboardActive;
                conf.Is_Default__c = dashboardDefault; 
                conf.Json_Config__c = filteredJobOwners;
                //      system.debug('conf.View_Name__c'+conf.View_Name__c+'conf.Is_Active__c'+conf.Is_Active__c+'conf.Is_Default__c'+conf.Is_Default__c);
                upsert conf;
                //       system.debug('>>>>'+conf);
                returnConfig.add(conf);
                
            }
            else
            { 
                conf.View_Name__c = dashboardName;
                conf.Is_Active__c = dashboardActive;
                conf.Is_Default__c = dashboardDefault;
                conf.Json_Config__c = filteredJobOwners;
                //      system.debug('conf.View_Name__c'+conf.View_Name__c+'conf.Is_Active__c'+conf.Is_Active__c+'conf.Is_Default__c'+conf.Is_Default__c);
                upsert conf;
                returnConfig.add(conf); 
            }
            
        }
        
        //        system.debug('relatedCustomConfig:'+relatedCustomConfig);
        
        return returnConfig;
    }
    @AuraEnabled
    public static List<Customer_Config__c> deleteDashboardRecord(String dashboardId)
    {
        //     system.debug('>>>>>start8ing'+dashboardId);
        List<Customer_Config__c> delList = new List<Customer_Config__c>();
        Customer_Config__c conf = [Select Id,User_Config__c,Is_Active__c, Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c From Customer_Config__c Where Id=:dashboardId];
        delList.add(conf) ;
        List<Customer_Config__c> delLst = [Select Id,User_Config__c  From Customer_Config__c Where User_Config__c=:dashboardId];
        
        if(delList.Size() > 0)
            delete delList;
        
        if(delLst.Size() > 0) delete delLst;
        //       system.debug('>>>>delete '+conf);
        return delList;
    }
    /************** periods drop down data in global filters component ******************/
    /*  @AuraEnabled
public static Map<String,String> getPeriods(){
Map<String,String> periodMap = new Map<String,String>();
Map<String,DateUtilitiFunctions__c> custMap = DateUtilitiFunctions__c.getAll();
for(String p :custMap.keySet()){
if(custMap.get(p).Is_Active__c)
periodMap.put(custMap.get(p).name, custMap.get(p).Function__c);
}     
system.debug('periodMap:'+periodMap);
return periodMap;
}*/
    @AuraEnabled
    public static JO_SAPSyncTime__c syncSAPx(String loggedInContact, SObject[] corpIdSet){
        
        String fId ='';
        for(SObject s : corpIdSet)
            fId += s.get('FederationIdentifier')+',';
        
        JO_SAPSyncTime__c orgsetting = JO_SAPSyncTime__c.getOrgDefaults();
        
        String dtTo = Datetime.now().format('yyyyMMdd');
        String dtFrom = (Datetime.now()-orgsetting.TMD__c).format('yyyyMMdd');
        
        Jo_Wrapper.SyncWrapper syncObj = new JO_SAPSyncStats(fId.removeEnd(','),dtTo,dtFrom, '000000').SavenSync('000000');
        system.debug('xxxxxxx'+syncObj);
        
        JO_SAPSyncTime__c setting = JO_SAPSyncTime__c.getInstance(loggedInContact);
        
        if(setting.Id == null){
            setting = new JO_SAPSyncTime__c();
            setting.SetupOwnerId = Userinfo.getUserId(); 
            setting.Name = Userinfo.getName();  
            setting.Sync_Time_Limit__c = 15;
        }
        
        setting.JO__c = fId.removeEnd(',');
        setting.RC__c = syncObj.rectotal != null ? syncObj.rectotal : 0;
        setting.SAP_Data_SyncTime__c = syncObj.processEndDt ;
        setting.Status__c = syncObj.msg;
        setting.Comments__c = syncObj.msg;
        setting.SDST__c = syncObj.processSrtDt != null ? syncObj.processEndDt : system.now();
        
        if(setting != null){
            upsert setting ; 
            system.debug('setting:'+setting);
            return setting;
        }
        
        else {
            throw new AuraHandledException('SAP not Synced');
            return null;
        }       
        
        return null;
    }
}