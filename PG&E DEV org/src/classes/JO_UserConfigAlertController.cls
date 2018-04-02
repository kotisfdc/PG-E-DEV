public class JO_UserConfigAlertController {
    @AuraEnabled 
    public static Id getLoogedInContact(){
        return Userinfo.getUserId();
    }
    @AuraEnabled
    public static List<Contact> getAllJobOwners(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List < Contact > returnList = new List < Contact > ();
        
        List<Contact> conList= [Select id, FirstName,LastName,Email,JO_Corp_ID__c FROM Contact Where JO_Corp_ID__c!=NULL Order by JO_Corp_ID__c limit 300 ];
        for (Contact acc: conList) {
            returnList.add(acc);
        }
        return returnList;
    }
      
  
    @AuraEnabled
    public static String getloggedUser(){        
        return JO_Util.getLoggedInContact(UserInfo.getUserId());
    }
    
     @AuraEnabled
    public static List<string> getDashboardViews()
    {
        List <string> ids = new list<string>();
        List<Customer_Config__c> config = [SELECT Id, View_Name__c, User_Config__c, Is_Active__c, Is_Admin__c, Is_Default__c, Json_Config__c
                                            FROM Customer_Config__c WHERE RecordType.DeveloperName='JO_Dashboard' AND Ownerid= :UserInfo.getUserId() order by Is_Default__c desc];
        
        
        for(Customer_Config__c cs : config )
        {
            List<String> lstAlpha = cs.Json_Config__c.split(',');
            if(lstAlpha.size()>0)
                ids.addall(lstAlpha);
        }   
        
        
        return ids;  
    }
    
}