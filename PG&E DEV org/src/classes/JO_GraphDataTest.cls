@isTest
public class JO_GraphDataTest {

    @testSetup
    static void dataCreation(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'testUsr', Email='testUser@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testUser@testorg01.com');
        insert testUser;         

        Id notiRecType = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('AS').getRecordTypeId();        
        List<Notifications__c> notList = new List<Notifications__c>();
        Notifications__c not1 = new Notifications__c();
        not1.RecordTypeId = notiRecType;
        not1.Name = 'Notification one';
        not1.Notification_Status__c = 'SUBM';
        not1.OwnerId = testUser.Id;
        notList.add(not1);
        Notifications__c not2 = new Notifications__c();
        not2.RecordTypeId = notiRecType;
        not2.Name = 'Notification two';
        not2.Notification_Status__c = 'SUBM';
        not2.OwnerId = testUser.Id;
        notList.add(not2);
        insert notList;

        List<Order__c> orList = new List<Order__c>();
        Order__c ord = new Order__c();        
        ord.Name = 'Order one';
        ord.Notification_Order__c = not1.id;
        ord.OrderStatus__c = 'SUBM';
        ord.OwnerId = testUser.Id;
        orList.add(ord);
        Order__c ord1 = new Order__c();
        ord1.Name = 'Order two';        
        ord1.OrderStatus__c = 'SUBM';
        ord1.OwnerId = testUser.Id;
        orList.add(ord1);
        insert orList;

        Id configDashRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        Customer_Config__c cust = new Customer_Config__c(); 
        cust.View_Name__c = 'Default Dashboard';
        cust.RecordTypeId = configDashRecType;
        cust.OwnerId = testUser.Id;
        insert cust;        
        Id configChartRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Chart').getRecordTypeId();
        Customer_Config__c cust1 = new Customer_Config__c();
        cust1.View_Name__c = 'Chart Configurations';
        cust1.RecordTypeId = configChartRecType;
        cust1.Json_Config__c = 'SUBM,PEND,APPR'; 
        cust.OwnerId = testUser.Id;
        cust1.User_Config__c= cust.Id;
        insert cust1;
        
    }

    
    static testMethod void getConfigStatusLst(){
        List<String> jobOwnerIds = new List<String>();
        User loggedUser = [SELECT id,LastName FROM User WHERE Email='testUser@testorg.com']; 
        for(User usr: [SELECT id,LastName FROM User WHERE Email='testUser@testorg.com'])   jobOwnerIds.add(usr.id);        
        Customer_Config__c cust1 = [SELECT id,Json_Config__c FROM Customer_Config__c where OwnerId IN:jobOwnerIds and RecordType.Name='JO Dashboard'];
        //Customer_Config__c cust2 = [SELECT id,Json_Config__c FROM Customer_Config__c where OwnerId IN:jobOwnerIds and RecordType.Name='JO Chart'];
        Map<String,String> status = new Map<String,String>();
        status.put('SUBM','SUBM');
        status.put('PEND','PEND');
        status.put('APPR','APPR');
        Test.startTest();
            List<String> configList = JO_GraphData.getConfigStatusLst(String.valueOf(loggedUser.Id),status,cust1);
            //List<String> configList1 = JO_GraphData.getConfigStatusLst(String.valueOf(loggedUser.Id),status,cust2);
            system.assert(configList.size()>0,'Successfully Executed');            
        Test.stopTest();
    }
    @isTest
    public static void coverForThreeMethods(){
        List<String> jobOwnerIds = new List<String>();      
        User loggedUser = [SELECT id,LastName FROM User WHERE Email='testUser@testorg.com']; 
        for(User usr: [SELECT id,LastName FROM User WHERE Email='testUser@testorg.com'])   jobOwnerIds.add(usr.id);        
        Customer_Config__c cust1 = [SELECT id,Json_Config__c FROM Customer_Config__c where OwnerId IN:jobOwnerIds and RecordType.Name='JO Dashboard'];
        
        Test.startTest();
            system.runAs(loggedUser){
                List<JO_Wrapper.JO_PIEChart> pList = JO_GraphData.getPieChartData(jobOwnerIds,cust1);
                List<JO_Wrapper.JO_BarChart> bList = JO_GraphData.getBarChartData(jobOwnerIds,cust1);
                JO_Wrapper.JO_IdWrapper wrap = JO_GraphData.fetchNotificationLsts(jobOwnerIds, 'SUBM');
            }
        Test.stopTest();
    }    
}