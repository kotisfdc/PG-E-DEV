@isTest
public class DynamicBindingDemoControllerTest {
    testMethod static void listAllObjectTest() 
    {
        DynamicBindingDemoController.listAllObject();
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'testUsr', Email='testUser@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testUser@testorg01.com');
        insert testUser;        
        
        Id notiRecType = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('AS').getRecordTypeId();        
        Notifications__c not1 = new Notifications__c();
        not1.RecordTypeId = notiRecType;
        not1.Name = 'Notification one';
        not1.Notification_Status__c = 'SUBM';
        not1.OwnerId = testUser.Id;
        insert not1;
        
        Alert__c alert = new Alert__c();
        alert.Name = 'TestAlert';
        alert.Notifications__c = not1.id;
        insert alert;
        
        String recId = not1.id;
        DynamicBindingDemoController.getrelatedListValue(recId);
        String objectName ='Alert__c';
        String fieldSetName ='';
        Integer limitval = 10;
        String sortOrder ='name';
        String fieldsToDisplay ='id,name,notifications__r.Name';
        DynamicBindingDemoController.listAllFields(objectName, fieldSetName, limitval, sortOrder, fieldsToDisplay);
        
        DescribeSObjectResult[] describes = Schema.describeSObjects(new String[] {'Alert__c'});
        Schema.FieldSet fs = describes[0].fieldSets.getMap().get('Alerts_Field_set');
        system.debug('fieldSetObj====>' +fs);
        String objectName1 ='Alert__c';
        String fieldSetName1 ='';
        Integer limitval1 = 10;
        String sortOrder1 ='name';
        String fieldsToDisplay1 ='';
        DynamicBindingDemoController.listAllFields(objectName1, fieldSetName1, limitval1, sortOrder1, fieldsToDisplay1);
        
    }
    
}