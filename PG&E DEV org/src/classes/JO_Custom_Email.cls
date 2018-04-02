public class JO_Custom_Email 
{
    public  string cachedTitle{get;set;}
    
    public void emailHtmldat()
    {
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('HTMLBODYDATA');
        if (sessionPart.contains('HTMLBODYDATA')) {
            cachedTitle = (String)sessionPart.get('HTMLBODYDATA');
            system.debug('cachedTitle====>>'+cachedTitle);
        }
        
        /*Test_Email__c customtemp = Test_Email__c.getall().values();
        System.debug('cdata : '+customtemp);
       // JO_Custom_Email.getSendData(customtemp.Name,customtemp.recid__c);
        System.debug('Htmltmpbody vf pafe: '+Htmltmpbody);
        Email_Template_Master__c emptmp=[select id,Name,Business_Name__c,Email_Template__c from Email_Template_Master__c where Email_Template__c=: customtemp.Name];
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(emptmp.Email_Template__c, UserInfo.getUserId(), customtemp.recid__c);    
        system.debug('mail===>>>'+mail);
         Htmltmpbody=mail.gethtmlBody();
        delete customtemp;*/
       
	}
    @AuraEnabled
    public static List<WrapperData> getSendData(string TempId, string RecId) 
    {
        system.debug('Template Id ==>>'+TempId+'<<==RecId Id===>>'+RecId);
        
        Email_Template_Master__c emptmp=[select id,Name,Business_Name__c,Email_Template__c from Email_Template_Master__c where Email_Template__c=: TempId];
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(emptmp.Email_Template__c, UserInfo.getUserId(), RecId);    
        system.debug('mail===>>>'+mail);
        string Htmltmpbody=mail.gethtmlBody();
        //  string HtmlBody=mail.getPlainTextBody();
        List<WrapperData> wrapEmailList = new List<WrapperData>();
        
        string subject=emptmp.Name +' : '+emptmp.Business_Name__c;
        string  businessname=emptmp.Business_Name__c;
        wrapEmailList.add(new wrapperData(Htmltmpbody,subject,businessname));
        system.debug('html data==>>'+Htmltmpbody);
        string cachekeytemprec=TempId+'-'+RecId;
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('HTMLBODYDATA');
        if (!Cache.Session.contains('HTMLBODYDATA')) {
        	Cache.Session.put('HTMLBODYDATA', Htmltmpbody);
        }   
        else {
        	Cache.Session.put('HTMLBODYDATA', Htmltmpbody);
        }
            // Add cache value to the partition
     //   sessionPart.put('cachekeytemprec', Htmltmpbody);
        /*JO_Custom_Email.emailHtmldat(Htmltmpbody);
        JO_CustomHTML test=new JO_CustomHTML(Htmltmpbody);
        
        Test_Email__c customtemp = new Test_Email__c();
        customtemp.recid__c = RecId;
        customtemp.Name = TempId;
        upsert customtemp;*/
        
        return wrapEmailList;
    }
    @AuraEnabled
    public static id addfiledata(String EmailID,String fileName, String base64Data, String contentType) 
    {
        try{
            system.debug('Email Tempalte Id==>'+EmailID);
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            List<Attachment> aad = new List<Attachment>();
            Attachment a = new Attachment();
            a.parentId = EmailID;
            a.Body = EncodingUtil.base64Decode(base64Data);
            a.Name = fileName;
            a.ContentType = contentType;  
            insert a;
            return a.id; 
        }
        catch(Exception e)
        {
            return null;
        }    
    }
    @AuraEnabled
    public static void sendEmailTCust(string Subject,string Html,string RecordId,List<string> EmailIds,string TempId,List<Attachment> Attachlist,list<string> cc) 
    {
        system.debug('TempId ===>>'+TempId+'<<===Attachlist===>>'+Attachlist);
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'dineshvakati@gmail.com'];
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(EmailIds);
        mail.setCcAddresses(cc);
        mail.setSubject(Subject);
        mail.setHtmlBody(Html);
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setTreatTargetObjectAsRecipient(false); 
        system.debug('mcs==>>'+owea);
        if(owea.size()>0)
        {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);   
        }
        List<string> attach=new List<String>();
        for (Attachment a : Attachlist)
        {
            system.debug('Attachment data===>>'+a);
            attach.add(a.Id);    
        }
        
        mail.setEntityAttachments(attach);
        mail.setWhatId(RecordId);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    public class WrapperData
    {
        @Auraenabled
        public string Htmlbody {get; set;}
        @Auraenabled
        public string subject {get; set;}
        @Auraenabled
        public string businessname {get; set;}
        public wrapperData(string Htmlbody,string subject,string businessname)
        {
            this.Htmlbody=Htmlbody;
            this.subject=subject;
            this.businessname=businessname;
        }
    }
}