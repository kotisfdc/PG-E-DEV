@IsTest
public class JO_CustomEmailDocsTest {
   
    testMethod static void attachmetGetTest()
    {
        Email_Template_Master__c etm = new Email_Template_Master__c();
        etm.Name = 'LetterTest';
        etm.Business_Name__c = 'Welcome';
        etm.Sort_Order__c = 1;
        insert etm;
        
        Attachment att1 = new Attachment();
        att1.Name       = 'Unit Test Attachment 1';
        att1.body       = Blob.valueOf('Unit Test Attachment Body 1');
        att1.ParentId = etm.id;
        Insert att1;
        string recId = etm.Id;
        JO_CustomEmailDocs.getAttachment(recId);   
    }
    
}