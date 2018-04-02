@istest
public class JO_ConfigGraphTest {
    testMethod static void chartConfigDataTest()
    {
        // Setup test data
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        System.runAs(u) {
            Contact con=new Contact();
            con.LastName='Test';
            //con.Related_User__c=userinfo.getuserid();
            insert con;
            //JO_ConfigGraph.getloggedUser();
            
            Id dashrecordTypeId = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();         
            Customer_Config__c dashBoardRec = new Customer_Config__c();
            dashBoardRec.View_Name__c = 'DashBoradRecTest';
            dashBoardRec.Json_Config__c = 'Test JSON';
            dashBoardRec.Is_Active__c = true;
            dashBoardRec.Is_Admin__c = true;
            dashBoardRec.Is_Default__c = true;
            dashBoardRec.RecordTypeId = dashrecordTypeId;
            //dashBoardRec.Job_Owner__c = con.id;
            Insert dashBoardRec;
            
            ID recordTypeId = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Chart').getRecordTypeId();        
            Customer_Config__c CustConfig = new Customer_Config__c();
            CustConfig.View_Name__c = 'Test';
            CustConfig.Json_Config__c = 'SUBM,UNSC,APPR';
            CustConfig.Is_Active__c = true;
            CustConfig.Is_Admin__c = true;
            CustConfig.Is_Default__c = true;
            CustConfig.RecordTypeId = recordTypeId;
            CustConfig.User_Config__c = dashBoardRec.Id;
           // CustConfig.Job_Owner__c = con.id;
            Insert CustConfig;
            
            
            JO_ConfigGraph.chartConfigData(con.Id, dashBoardRec);
            
            
            
            Customer_Config__c CustConfig1 = new Customer_Config__c();
            CustConfig1.Json_Config__c = 'SUBM,UNSC,APPR';
            CustConfig1.RecordTypeId = recordTypeId;
            CustConfig1.User_Config__c = CustConfig.Id;
            //CustConfig1.Job_Owner__c = con.id;
            Insert CustConfig1; 
            
            List<String> filteredList = new List<String>(); 
            JO_Wrapper.JO_StringWrapperConfig wrap = JO_ConfigGraph.chartConfigData(con.Id, dashBoardRec);
            system.debug('wrap==>'+wrap.left);
            system.debug('wrap==>'+wrap.right);
            //filteredList.addAll(wrap.left);
            filteredList.addAll(wrap.right);
            String loggedInUser = con.id;
            String userConfigId = CustConfig1.id;
            
            JO_ConfigGraph.UpdateUserConfig(filteredList, loggedInUser, userConfigId, dashboardRec);

        }
    }
    
}