@isTest
public class JO_Custom_EmailTest {
    
    @testSetup static void setupMethod() {
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'test';
        validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.Subject = 'Your Subject Here';
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        insert validEmailTemplate;
    }

    list<Id> ids=new list<Id>();
    
    @future
    public static void test1()
    {   
       EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'test';
        validEmailTemplate.DeveloperName = 'Letter_C';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.Subject = 'Your Subject Here';
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        insert validEmailTemplate;

    }
    
    
   
    public  static testMethod void setup(){
    
        list<contact> conlist=new list<contact>();
        contact con=new contact();
        con.LastName='Krishna';
        con.Email = 'sdff@gh.com';
        conlist.add(con);
        insert con;

        Notifications__c notif=new Notifications__c();
        notif.Name='1234567';
        //notif.Jb_Owner__c=con.id;
        insert notif;
        
        Id RecType = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('E060').getRecordTypeId();
        
        Order__c Od = new Order__c();
        Od.Name = 'Test Order';
        Od.RecordTypeId = RecType;
        Od.Notification_Order__c = Notif.id;
        Od.Order_Notification__c = Notif.id;
        Insert Od;
        
        EmailMessage emg=new EmailMessage();
        emg.MessageDate=datetime.newInstance(2017, 12, 11, 13, 3, 0);
        emg.Subject='Template C';
        emg.RelatedToId=notif.ID;
        emg.Status='3';
        emg.MessageIdentifier='krishsna';
        insert emg;
        test1();
        EmailTemplate empT = [select id,name,developerName from EmailTemplate where DeveloperName = 'Letter_C'];
        
        
        Email_Template_Master__c etm=new Email_Template_Master__c();
        
        etm.Name='Letter';
        etm.Business_Name__c='Thank you';
        etm.Email_Template__c=empT.Id;
        etm.Sort_Order__c=1;
        etm.Object_Record_Type__c='AS';
        etm.Object_Type__c='Notification';
        etm.Is_Active__c=true;
        insert etm;
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=etm.Email_Template__c;
        insert attach;
        
        system.debug('EEEmail:::'+etm.Email_Template__c);
        JO_Custom_Email joce=new JO_Custom_Email();
        JO_Custom_Email.addfiledata(etm.id,'Jo templates','hello','html');
        //JO_Custom_Email.WrapperData Jowp=new JO_Custom_Email.WrapperData('krish@143.com',con.email,'Hello','contact','Thank you');
        //JO_Custom_Email.getAllJobOwners('email');
        JO_Custom_Email.getSendData(etm.Email_Template__c,notif.ID);
        //JO_Custom_Email.sendEmailTCust('letter_C','Hello',notif.Id,etm.Email_Template__c,conlist);
        
        JO_Custom_Email.getSendData(etm.Email_Template__c,Od.ID);
        
        String Subject = 'Test Subject';
        String Html = 'Test Body';
        String RecordId = od.ID;
        List<String> lstStr = new List<String>();
        lstStr.add(attach.id);
        List<String> lstEmails = new List<String>();
        lstEmails.add('test@abc.com');
        
        string TempId = etm.Email_Template__c;
       // JO_Custom_Email.sendEmailTCust(Subject, Html, RecordId,  lstEmails, TempId, lstStr);
        
        
    }
}