@istest
public class JO_PortfolioControllerTest {
/*    
    static testMethod void JO_PortfolioControllerTestMethod(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        list<string> us=new list<string>();        
        User user = new User(Alias = 'testUsr', Email='abc@gmail.com', 
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='testing123@gmail.com');
        insert user; 
        us.add(user.id);
        
        list<string> str=new list<string>();
        list<contact> conlist=new list<contact>();
        contact cont=new contact();
        cont.Email='abc@gmail.com';
        cont.LastName='new';
        insert cont;
        str.add(cont.id);
        
        String [] notil = new List<String>();
        list<Notifications__c> notilist=new list<Notifications__c>();
        Notifications__c notif=new Notifications__c();
        //notif.Jb_Owner__c=cont.id;
        //notif.IsDeleted=false;
        insert notif;
        notil.add(notif.id);
        
        Customer_Config__c config=new Customer_Config__c();
        config.Is_Active__c=true;
        config.Is_Admin__c=true;
        config.Job_Owner__c=cont.Name;
        config.Is_Default__c=true;
        config.Sort_Order__c=1;
        config.View_Name__c='default';
        config.Json_Config__c='{"viewfields":[{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"Notification Name","fieldAPI":"Name","customLabel":"Notification Name1"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"Type","fieldAPI":"NotificationType__c","customLabel":"Type"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZNotify","fieldAPI":"Name","customLabel":"ZNotification"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"Order","fieldAPI":"Notification_Order__c","customLabel":"Order"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZOrder","fieldAPI":"Notification_Order__c","customLabel":"ZOrder"},{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"NOTIFICATION DESCRIPTION","fieldAPI":"NotificationDesc__c","customLabel":"Notification Description"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"CUSTOMER","fieldAPI":"Customer__c","customLabel":"Customer"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"JOB OWNER","fieldAPI":"Jb_Owner__c","customLabel":"Job Owner"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"NOTIFICATION STATUS","fieldAPI":"Notification_Status__c","customLabel":"Notification Status"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"PRIORITY TYPE","fieldAPI":"NotifPriorityType__c","customLabel":"Priority Type"}]}';
        //system.debug('usesr config record' +config);
        upsert config;
        string jsonstr='{"viewfields":[{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"Notification Name","fieldAPI":"Name","customLabel":"Notification Name1"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"Type","fieldAPI":"NotificationType__c","customLabel":"Type"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZNotify","fieldAPI":"Name","customLabel":"ZNotification"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"Order","fieldAPI":"Notification_Order__c","customLabel":"Order"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZOrder","fieldAPI":"Notification_Order__c","customLabel":"ZOrder"},{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"NOTIFICATION DESCRIPTION","fieldAPI":"NotificationDesc__c","customLabel":"Notification Description"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"CUSTOMER","fieldAPI":"Customer__c","customLabel":"Customer"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"JOB OWNER","fieldAPI":"Jb_Owner__c","customLabel":"Job Owner"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"NOTIFICATION STATUS","fieldAPI":"Notification_Status__c","customLabel":"Notification Status"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"PRIORITY TYPE","fieldAPI":"NotifPriorityType__c","customLabel":"Priority Type"}]}';    
        
        //String myJSON = JSON.serialize(jsonstr);
        string jsons='{"isActive": true,"isAdmin": true,"isDefault": true,"viewfields":[{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"Notification Name","fieldAPI":"Name","customLabel":"Notification Name1"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"Type","fieldAPI":"NotificationType__c","customLabel":"Type"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZNotify","fieldAPI":"Name","customLabel":"ZNotification"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"Order","fieldAPI":"Notification_Order__c","customLabel":"Order"},{"visible":false,"order":0,"fieldType":"LINK","fieldApiLabel":"ZOrder","fieldAPI":"Notification_Order__c","customLabel":"ZOrder"},{"visible":false,"order":0,"fieldType":"STRING","fieldApiLabel":"NOTIFICATION DESCRIPTION","fieldAPI":"NotificationDesc__c","customLabel":"Notification Description"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"CUSTOMER","fieldAPI":"Customer__c","customLabel":"Customer"},{"visible":false,"order":0,"fieldType":"REFERENCE","fieldApiLabel":"JOB OWNER","fieldAPI":"Jb_Owner__c","customLabel":"Job Owner"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"NOTIFICATION STATUS","fieldAPI":"Notification_Status__c","customLabel":"Notification Status"},{"visible":false,"order":0,"fieldType":"PICKLIST","fieldApiLabel":"PRIORITY TYPE","fieldAPI":"NotifPriorityType__c","customLabel":"Priority Type"}]}';       
        system.debug('jsons===>'+jsons);
        JO_PortfolioController.generateListViews(str, config);
        JO_PortfolioController.deleteViewRec(config.id);
        
        JO_PortfolioController.generateTableRecords(str,config.id,config);
        JO_PortfolioController.getNotificationRec('contact', 'lastName', str, config, jsonstr, notil);
        JO_PortfolioController.saveView(cont.Id, config, jsons);
        //JO_PortfolioController.editView(user.id, jsons);     
        
        
        
    }
*/
}