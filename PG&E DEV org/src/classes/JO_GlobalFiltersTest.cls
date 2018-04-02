@IsTest
public class JO_GlobalFiltersTest {
    
    @testSetup static void methodName() {
        //Retrieve the Profile 
        id id1 = userinfo.getProfileId();
        Profile p = [SELECT Id,Name FROM Profile WHERE id=:id1];
        //system.debug('Profile===>'+p);
        
        //Craete User
        User u = new User();
        u.Alias = 'stand';
        u.Email = 'testuser@abc.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Test';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = p.id;
        u.TimeZoneSidKey ='America/Los_Angeles';
        u.Username = 'abcuser@test.com';
        u.FederationIdentifier = 'Test12345';
        Insert u; 
        
        
        //Create PermissionSet
        PermissionSet ps = new PermissionSet();
        ps.Label = 'JO Admin1';
        ps.Name = 'JO_Admin1';
        Insert ps;
        
        
        //Assign user to PermissionSetAssignment
        PermissionSetAssignment pm = new PermissionSetAssignment();
        pm.AssigneeId=u.Id;
        pm.PermissionSetId=ps.id;
        insert pm; 
        
    }   
    testMethod static void global_filterTestMethod()
    {
        List<User> lstUsersWP = JO_GlobalFilters.getAllJobOwners();
        if(lstUsersWP.size()>0) {
            for(User u : lstUsersWP)
            {
                system.runAs(u)
                {
                    JO_GlobalFilters.getSAPSyncTime(u.id ); 
                    //JO_GlobalFilters.getLoogedInContact();
                    //JO_GlobalFilters.getloggedUser();
                    //getDashboardViews Test with ContactId as UserID
                    String contactId = u.id;
                    List<Customer_Config__c> lstUserConfigRecs = JO_GlobalFilters.getDashboardViews(contactId);
                    
                    //newDashboardRecord
                    ID ownerID = u.id;
                    List<Customer_Config__c> createUserConfigRec = JO_GlobalFilters.getDashboardViews(contactId);
                    // System.debug('createUserConfigRec New====>'+createUserConfigRec);    
                    
                    String dashboardId = createUserConfigRec[0].id;
                    String dashboardName = createUserConfigRec[0].View_Name__c;
                    Boolean dashboardActive = createUserConfigRec[0].Is_Active__c;
                    String loggedInContact = u.Id;
                    List<String> globalFilterRecs = new List<String>();
                    globalFilterRecs.add(u.id);
                    Boolean dashboardDefault = createUserConfigRec[0].Is_Default__c;
                    String typestr = 'New';
                    
                    List<Customer_Config__c> lstUpdtConfig = JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);
                    //Clone functionality is not working properly
                    
                    //Create Child Record
                    
                    Id configChartRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Chart').getRecordTypeId();
                    Customer_Config__c cust1 = new Customer_Config__c();
                    cust1.View_Name__c = 'Chart Configurations';
                    cust1.RecordTypeId = configChartRecType;
                    cust1.Json_Config__c = 'SUBM,PEND,APPR'; 
                    cust1.OwnerId = ownerID;
                    cust1.User_Config__c= lstUpdtConfig[0].id;
                    Insert cust1;
                    
                    List<Customer_Config__c> finalUpdtConfig = JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);
                    //System.debug('createConfigfinalUpdtConfig===>'+finalUpdtConfig);
                    
                    String typestr1 = 'Edit';
                    List<Customer_Config__c> lstUpdtConfigEdit = JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr1);
                    //System.debug('EDitcreateConfigfinalUpdtConfig===>'+lstUpdtConfigEdit);
                    
                    String typestr2 = 'Edit';
                    Boolean dashboardDefault2 = true;
                    
                    List<Customer_Config__c> lstUpdtConfigEdit2 = JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault2, typestr2);
                    // System.debug('EDitcreateConfigfinalUpdtConfig2===>'+lstUpdtConfigEdit2);
                    
                    String typestr3 = 'Edit';
                    Boolean dashboardDefault3 = false;
                    
                    List<Customer_Config__c> lstUpdtConfigEdit3 = JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault3, typestr3);
                    //System.debug('EDitcreateConfigfinalUpdtConfig3===>'+lstUpdtConfigEdit3);
                    
                    //Delete dashBoard
                    List<Customer_Config__c> lstUpdtConfigDelete = JO_GlobalFilters.deleteDashboardRecord(dashboardId);
                    
                   // SObject[] corpIdSet= new  SObject[];
                    //JO_GlobalFilters.syncSAPx(loggedInContact, corpIdSet);
                }
            }
        }
    }
    /*
testMethod static void getSAPSyncTimeTest()
{
User u = [Select id from user where LastName = 'Test' limit 1]; 
String loggedInContact = u.id;

JO_GlobalFilters.getSAPSyncTime(loggedInContact );
}

testMethod static void logedInContactTest()
{
User u = [Select id from user where LastName = 'Test' limit 1]; 
system.runAs(u)
{
Contact con=new Contact();
con.LastName='Test';
//con.Related_User__c=u.id;
insert con; 

test.startTest();
JO_GlobalFilters.getLoogedInContact();
JO_GlobalFilters.getloggedUser();
test.stopTest();  
}
}    

testMethod static void allJobOwnerTest() {
JO_GlobalFilters.getAllJobOwners();
}

testMethod static void getDashboardViewsTest() {
User u = [Select id from user where LastName = 'Test' limit 1]; 
String contactId = u.id;
List<Customer_Config__c>  lstUserConfig  = JO_GlobalFilters.getDashboardViews(contactId); 
}

testMethod static void newDashBoardTest() {
User u = [Select id from user where LastName = 'Test' limit 1]; 
String contactId = u.id;
List<Customer_Config__c>  lstUserConfig  = JO_GlobalFilters.getDashboardViews(contactId); 

String dashboardId = lstUserConfig[0].id;
String dashboardName = lstUserConfig[0].name;
Boolean dashboardActive = lstUserConfig[0].Is_Active__c;
String loggedInContact = u.id;
List<String> globalFilterRecs = new List<String>();
globalFilterRecs.add(u.id);
Boolean dashboardDefault = lstUserConfig[0].Is_Default__c;
String typestr = 'New';
JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);  
}

testMethod static void newDashBoardTestEdit() {
User u = [Select id from user where LastName = 'Test' limit 1]; 
String contactId = u.id;
List<Customer_Config__c>  lstUserConfig  = JO_GlobalFilters.getDashboardViews(contactId);
lstUserConfig[0].Is_Default__c = false;
upsert lstUserConfig;

String dashboardId = lstUserConfig[0].id;
String dashboardName = lstUserConfig[0].name;
Boolean dashboardActive = lstUserConfig[0].Is_Active__c;
String loggedInContact = u.id;
List<String> globalFilterRecs = new List<String>();
globalFilterRecs.add(u.id);
Boolean dashboardDefault = lstUserConfig[0].Is_Default__c;
String typestr = 'Edit';
JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);  
}

//If Admin is false
testMethod static void newDashBoardTestEditWithAdmin() {
User u = [Select id from user where LastName = 'Test' limit 1]; 
String contactId = u.id;
List<Customer_Config__c>  lstUserConfig  = JO_GlobalFilters.getDashboardViews(contactId);
lstUserConfig[0].Is_Default__c = true;
lstUserConfig[0].Is_Admin__c = false;
upsert lstUserConfig;
system.debug('lstUserConfig====>'+lstUserConfig);
String dashboardId = lstUserConfig[0].id;
String dashboardName = lstUserConfig[0].name;
Boolean dashboardActive = lstUserConfig[0].Is_Active__c;
String loggedInContact = u.id;
List<String> globalFilterRecs = new List<String>();
globalFilterRecs.add(u.id);
Boolean dashboardDefault = lstUserConfig[0].Is_Default__c;
String typestr = 'Edit';
List<Customer_Config__c> newDashboardRecord = JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr); 
system.debug('newDashboardRecord====>'+newDashboardRecord);
}

//If Admin is false
testMethod static void newDashBoardTestEditWithAdmin2() {
User u = [Select id from user where LastName = 'Test' limit 1]; 
String contactId = u.id;
List<Customer_Config__c>  lstUserConfig  = JO_GlobalFilters.getDashboardViews(contactId);
lstUserConfig[0].Is_Default__c = false;
lstUserConfig[0].Is_Admin__c = false;
upsert lstUserConfig;
system.debug('lstUserConfig====>'+lstUserConfig);
String dashboardId = lstUserConfig[0].id;
String dashboardName = lstUserConfig[0].name;
Boolean dashboardActive = lstUserConfig[0].Is_Active__c;
String loggedInContact = u.id;
List<String> globalFilterRecs = new List<String>();
globalFilterRecs.add(u.id);
Boolean dashboardDefault = true;
String typestr = 'Edit';
List<Customer_Config__c> newDashboardRecord = JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr); 
system.debug('newDashboardRecord====>'+newDashboardRecord);
}

testMethod static void deleteDashboardRecordTest()
{
User u = [Select id from user where LastName = 'Test' limit 1]; 
String contactId = u.id;
List<Customer_Config__c>  lstUserConfig  = JO_GlobalFilters.getDashboardViews(contactId); 
JO_GlobalFilters.deleteDashboardRecord(lstUserConfig[0].id);
}
*/  
}