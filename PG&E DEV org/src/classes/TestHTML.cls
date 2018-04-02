public class TestHTML {
    public string HtmlBody{get;set;}
    public TestHTML()
    {
               
    }
    public PageReference sendHtml()
    {
        string templateid='00X1N000001NIVf';
        string recid='a0A1N00001Eab7m';
        string userid='0051N0000053IAQ';
                  Savepoint sp = Database.setSavepoint(); 
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] { 'dineshreddyvakati@gmail.com' });
                    mail.setSaveAsActivity(false);
                    mail.setTreatTargetObjectAsRecipient(false); 
                    mail.setTargetObjectId('0031N00001IhWj7');
                    mail.setTemplateId(templateid);
                    mail.setWhatId(recid); 
                    Messaging.SingleEmailMessage[] emailList = new Messaging.SingleEmailMessage[] {mail};       
                    Messaging.sendEmail(emailList);
                              
                    Database.rollback(sp);
                    HtmlBody=mail.gethtmlBody();
                    system.debug('Html body===>>'+htmlbody);

        /* Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateid, UserInfo.getUserId(),recid);    
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateid, userid, recid);
                */
        return null;
    }
}