@istest
public class JO_UserConfigAlertControllerTest {
    Static testMethod Void JO_UserConfigAlertControllerMethodTest(){
        User u = [select firstname from user where id=:userinfo.getuserid()];
        
        Contact con=new Contact();
        con.LastName='Test';
        // con.Related_User__c=u.id;
        con.JO_Corp_ID__c='con123';
        insert con;
        Id configDashRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        Customer_Config__c cust = new Customer_Config__c(); 
        cust.OwnerId =u.id;        
        cust.View_Name__c = 'Default Dashboard';
        cust.RecordTypeId = configDashRecType;
        cust.Json_Config__c = '{"viewfields":[{"alertType":"External","Id":"a2O2F0000006I2OUAU","isEnabled":true,"isHidden":true,"joAlertName":"New Application Call Customer","selectedUserPriority":"High","sortOrder":2,"sysPriority":"High"},{"alertType":"External","Id":"a2O2F0000006I3WUAU","isEnabled":true,"isHidden":true,"joAlertName":"Send Request for Additional Email","selectedUserPriority":"High","sortOrder":3,"sysPriority":"High"}]}'; 
        insert cust;    
        
        String searchKeyWord;
        JO_UserConfigAlertController Jou=new JO_UserConfigAlertController();
        JO_UserConfigAlertController.getAllJobOwners('searchKeyWord');
        JO_UserConfigAlertController.getloggedUser();
        JO_UserConfigAlertController.getLoogedInContact();
        JO_UserConfigAlertController.getDashboardViews();
        
    }
}