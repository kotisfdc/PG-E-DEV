public class JO_Custom_EmailAttachments {
    @AuraEnabled
    public static List<Attachment> getAllJobOwners(string EmialMastId) {
        system.debug('Email master Id==>>'+EmialMastId);
        List<Attachment> attlst = [select Id, Name from Attachment where ParentId =:EmialMastId ];
        return attlst;
    }
}