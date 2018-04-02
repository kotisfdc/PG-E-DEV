public class JO_UserEmailTo {
    @AuraEnabled 
    public static Id getLoogedInContact(){
        return Userinfo.getUserId();
    }
      @AuraEnabled
    public static List<User> getAllJobOwners(boolean includejobcustomer, Id RecId) {
        system.debug('Address Id==>>'+RecId);
        List <User> returnList = new List <User>();
        
        ///// ADDED PLATFORM CACHE ////////////////////////////////
        
        returnList = (List<sobject>) JO_Util.getJOUsers();
        List<Notifications__c> notiflst=[select id,Name,(select Id, Name,  LastName__c, EmailAddress__c from Addresses__r) from Notifications__c where Id =: RecId];
        system.debug('Notification Data==>>'+notiflst);
        List<Address__c> adlst;
        User usr=new User();
        for(Notifications__c nf: notiflst)
        {
            adlst=nf.Addresses__r;
			system.debug('Address Data==>>'+adlst);
        }
        for(Address__c ad : adlst)
        {
            usr=new User();
            usr.FirstName=ad.Name;
            usr.LastName=ad.LastName__c;
            usr.Email=ad.EmailAddress__c;
           // usr.FederationIdentifier=ad.LastName__c;
            returnList.add(usr);
        }
        system.debug('user data ===>>'+returnList);
      
            if (returnlist == null)
            return new List<user>();
        
        return returnList;
    }
    @AuraEnabled
    public static String getloggedUser(){        
        return JO_Util.getLoggedInContact(UserInfo.getUserId());
    }
}