public class JO_CustomEmailDocs {
    
 @Auraenabled
    public static List<WrapperDocs> getAttachment(string recId){
        list<WrapperDocs> wp = new   list<WrapperDocs>();
        for(attachment a : [select Id,Name from attachment where parentid=:recId])
        {            
            wp.add(new WrapperDocs(a.Name,a.Id));
        }
        //system.debug('wp--->'+wp);
        return wp;
    }
    public class WrapperDocs
    {
        @Auraenabled
        public Boolean checkBoxValue {get; set;}
        @Auraenabled
        public string  attachmentName {get; set;}
         @Auraenabled
        public Id  attachmentId {get; set;}       
        public WrapperDocs (string attachmentNameValue,Id attachmentIdValue)
        {
            attachmentName = attachmentNameValue;
            attachmentId = attachmentIdValue;
        }
        
}
}