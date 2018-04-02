public class DatatableAdvancedController {
	@AuraEnabled public static string getAccountdetails() {
        List<Account> acc =  [SELECT Name, Industry, AnnualRevenue,Fax,Phone,AccountNumber,NumberOfEmployees,SLAExpirationDate__c,Rating,
                              (select Name,Birthdate,Email,Phone,LeadSource from Contacts)
                              FROM Account LIMIT 1000];
        return  JSON.serialize(acc);
    }
    @AuraEnabled
    public static string fetcContacts() {
        List<Contact> lst =  [SELECT Name,Phone,OtherPhone,MobilePhone,Level__c,LeadSource,AccountId,Account.Name,Account.industry ,Birthdate,Email,Fax FROM Contact];
        return  JSON.serialize(lst);
    }
    @AuraEnabled
    public static List<Contact> getColumnvalue() {
        return [SELECT id,Description,title FROM Contact ];
    }
    @AuraEnabled public static Contact saveContact(String filter) {
        System.debug('filter value : '+filter);
        Contact con = new Contact();
       // con.Id = '0036F00002KoQ56';
        con.Title = filter;
        upsert con;
        return con;
    }
}