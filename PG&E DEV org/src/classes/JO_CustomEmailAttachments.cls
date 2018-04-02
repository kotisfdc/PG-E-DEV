public class JO_CustomEmailAttachments {
    @AuraEnabled
    public static List<Attachment> getAllJobOwners(string EmialMastId) {
        system.debug('Email master Id==>>'+EmialMastId);
        List<Attachment> attlst = [select Id, Name from Attachment where ParentId =:EmialMastId ];
        return attlst;
    }
    
    @AuraEnabled
    public static List<Attachment> getNewAttachment(string EmialMastId) {
        system.debug('Email master Id==>>'+EmialMastId);
        List<Attachment> attlst = [select Id, Name from Attachment where Id =:EmialMastId ];
        return attlst;
    }
}