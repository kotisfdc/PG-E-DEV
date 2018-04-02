@IsTest
public class JO_CustomEmailAttachmentsTest {
    @testSetup static void methodName() {
        Email_Template_Master__c etm = new Email_Template_Master__c();
        etm.Name = 'TestEmailTemplate';
        etm.Business_Name__c = 'TestBusiness';
        etm.Sort_Order__c = 1;
        insert etm;
    }
    testMethod static void getAllJobOwners() {
        Email_Template_Master__c etm = [Select id from Email_Template_Master__c where name='TestEmailTemplate'];
        JO_CustomEmailAttachments.getAllJobOwners(etm.id); 
        JO_CustomEmailAttachments.getNewAttachment(etm.id);
    }
    
}