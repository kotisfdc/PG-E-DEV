Global class SendEmailAlert {
    @InvocableMethod
    Global static void sendEmail(List<String> orderId){
        List<string> Values=orderId[0].split(',');
        string UsID=UserInfo.getUserId();
        try{
            Order__c ord=[select id,Name,Customer_Email__c from Order__c where id =: Values[0]];
            //OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
            EmailTemplate let =[select id,Name from EmailTemplate where Name like :Values[1].trim()];
            Messaging.SingleEmailMessage mails = Messaging.renderStoredEmailTemplate(let.Id, UsID, Values[0]);
            Messaging.singleEmailMessage mail=new Messaging.singleEmailMessage();  
            mail.setToAddresses(new String[] {ord.Customer_Email__c});
            mail.setHtmlBody(mails.getHTMLbody());
            mail.setSubject(mails.getSubject());
            mail.setSaveAsActivity(true);
            //mail.setOrgWideEmailAddressId(owa.id);
            mail.setWhatId(Values[0]); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception e){
            Order__c error=new Order__c();
            error.addError(e.getMessage());
        }
        
    }
}