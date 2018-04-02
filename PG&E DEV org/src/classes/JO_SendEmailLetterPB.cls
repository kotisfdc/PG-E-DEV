Global class JO_SendEmailLetterPB {
    @InvocableMethod
    Global static void sendEmail(List<String> orderId){
        system.debug('orderId====>'+orderId);
        List<string> Values=orderId[0].split(',');
        system.debug('Values====>'+Values);
        Notifications__c nf= [select id,Notification_Order__c,RecordType.Name from Notifications__c where id =:Values[0] and RecordType.Name='OD'];
        string UsID=UserInfo.getUserId();
        try{
            Order__c ord=[select id,Name,Customer_Email__c from Order__c where id =: nf.Notification_Order__c];
            EmailTemplate let =[select id,Name from EmailTemplate where Name like :Values[1].trim()];
            Messaging.SingleEmailMessage mails = Messaging.renderStoredEmailTemplate(let.Id, UsID, nf.Notification_Order__c);
            Messaging.singleEmailMessage mail=new Messaging.singleEmailMessage();  
            mail.setToAddresses(new String[] {ord.Customer_Email__c});
            mail.setHtmlBody(mails.getHTMLbody());
            mail.setSubject(mails.getSubject());
            mail.setSaveAsActivity(true);
            mail.setWhatId(nf.Notification_Order__c); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception e){
            Order__c error=new Order__c();
            error.addError(e.getMessage());
        }
        
    }
}