public class JO_Communication_Template{
    public static Set<Id> taskWhatIDs = new set<Id>();
    @AuraEnabled
    public static List<WrapperData> getEmailtemplate(string RecId) {
        system.debug('Record Id==>>'+RecId);
        List<Email_Template_Master__c> Emlst;
        Id rec=Id.valueof(RecId);
        String sObjName = rec.getSObjectType().getDescribe().getName();
        system.debug('Object Type==>>'+sObjName);
        Notifications__c nf;
        Order__c ord;
        if(sObjName == 'Notifications__c')
        {
            nf = [SELECT Id,Name,Customer__c FROM  Notifications__c WHERE Id =:RecId];
            taskWhatIDs.add(nf.Id);
            Emlst =[SELECT Id,Name,OpA__c,Email_Template__c,Business_Name__c,Sort_Order__c,Object_Type__c,Object_Record_Type__c,Is_Active__c,Is_Auto__c FROM Email_Template_Master__c where Object_Type__c='Notification' and Is_Active__c=true order by Sort_Order__c ];
        }
        else if(sObjName == 'Order__c')
        {
            ord=[select id,Name,Notification_Order__c,Notification_Order__r.Customer__c from Order__c where id =: RecId];
            taskWhatIDs.add(ord.Id);
            Emlst =[SELECT Id,Name,OpA__c,Email_Template__c,Business_Name__c,Sort_Order__c,Object_Type__c,Object_Record_Type__c,Is_Active__c,Is_Auto__c FROM Email_Template_Master__c where Object_Type__c='Order' and Is_Active__c=true order by Sort_Order__c ];
        }
        
        List<EmailMessage> emmes=[SELECT id,MessageDate,RelatedToId,Status,Subject,CreatedBy.Name FROM EmailMessage where RelatedToId In : taskWhatIDs order by CreatedDate DESC ];        
        List<WrapperData> wrapEmailList = new List<WrapperData>();
        Map<String,Integer> recordcount=new Map<String,Integer>(); 
        for(Email_Template_Master__c em : Emlst)
        {
            wrapEmailList.add(new wrapperData(null,'',em,'',0,''));
        }
        for(EmailMessage tk : emmes)
        {
            if(recordcount.get(tk.Subject) != null){
                recordcount.put(tk.Subject, recordcount.get(tk.Subject)+1) ; 
            }
            else {
                recordcount.put(tk.Subject, 1);
            }
        }
        for(WrapperData w : wrapEmailList)
        {
            for(EmailMessage tk : emmes)
            {
                if(tk.Subject.contains(w.EmailTemp.Name))
                {
                    w.SentDate=tk.MessageDate;
                    w.SentByName=tk.CreatedBy.Name;
                    w.previewId=tk.id;
                    break;
                }
            }
            if(sObjName == 'Notifications__c')
                w.customerId=nf.Customer__c;
            else
                w.customerId=ord.Notification_Order__r.Customer__c;
            w.recordCount = recordcount.get(w.EmailTemp.Name +' : '+ w.EmailTemp.Business_Name__c);
        }
        return wrapEmailList;
    }
    public class WrapperData
    {
        @Auraenabled
        public DateTime  SentDate {get; set;}
        @Auraenabled
        public string SentByName {get; set;}
        @Auraenabled
        public string customerId {get; set;}
        @Auraenabled
        public Integer recordCount {get; set;}
        @Auraenabled
        public Email_Template_Master__c EmailTemp {get; set;}
        @Auraenabled
        public string previewId {get; set;}
        @Auraenabled
        @testvisible public string EmailTempName 
        {
            get
            {
                return EmailTemp.Name;
            }
        }
        public wrapperData(DateTime  SentDate,string SentByName,Email_Template_Master__c EmailTemp,string previewId, Integer recordCount,string customerId)
        {
            this.SentDate=SentDate;
            this.EmailTemp=EmailTemp;
            this.recordCount=recordCount;
            this.SentByName=SentByName;
            this.previewId=previewId;
            this.customerId=customerId;
        }
    }    
}