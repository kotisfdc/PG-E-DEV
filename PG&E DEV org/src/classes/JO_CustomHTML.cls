public class JO_CustomHTML {
    public final string htmldatatovf{get;set;}
    public string htmdatataa{get;set;}
   
    public JO_CustomHTML()
    {
        system.debug('htmldatatovf dfsfjkg===>>'+this.htmldatatovf);
        //htmdatataa=this.htmldatatovf;
        
        htmdatataa = JO_Custom_Email.Htmltmpbody;
        system.debug('htmldatatovf dfsfjkg===>>'+htmdatataa);
    }
    public JO_CustomHTML(string htmlbody){
        system.debug('htmlbody data to constructors==>>'+htmlbody);
        htmdatataa=htmlbody;
        
    }
    
    public void rendereddata()
    {
        system.debug('htmldatatovf dfsfjkg===>>'+htmldatatovf);
        htmdatataa=htmldatatovf;
        system.debug(' after htmldatatovf dfsfjkg===>>'+htmdatataa);
    }
    
    
  /* public static String RecId = ApexPages.currentPage().getParameters().get('RecId');
     system.debug('RecId====>>'+RecId);
   public static String TempId = ApexPages.currentPage().getParameters().get('TempId');
   public JO_CustomHTML()
   {
       system.debug('RecId====>>'+RecId+'<<<TempId===>'+TempId);
       Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(TempId, UserInfo.getUserId(), RecId);
       system.debug('Email data====>>'+mail);
   }*/
   
  /*  public JO_CustomHTML()
    {
        htmlbody=htmlbody;
    }*/
    
  /*  global static void htmlData(string HtmlBody)
    {
        system.debug('HtmlBody in custom email==>>'+HtmlBody);
        htmlbody=HtmlBody;
        system.debug('HtmlBody in htmlbody email==>>'+htmlbody);
        
    } */
    
 /*   public static object getbody{get;set;}
     public string htmlbody{get;set;}
   
    public class JO_ObjectLongTextWrapper
    {
        public String HtmlBody;
        public JO_ObjectLongTextWrapper(String HtmlBody)
        {
            this.HtmlBody = HtmlBody;
        }   
    }
    public static object htmldatat{get;set;}
    public static List<JO_ObjectLongTextWrapper> wrapEmail{get;set;}
    public static string postToSAP(JO_ObjectLongTextWrapper sapLongTextObj)
    {
        system.debug('HtmlBody in custom email==>>'+sapLongTextObj);
       wrapEmail=new List<JO_ObjectLongTextWrapper>();
        wrapEmail.add(sapLongTextObj);
        system.debug('wrapEmail in wrapEmail email==>>'+wrapEmail);
        renderdata();
        return null;
    }
     public static void renderdata()
    {
        system.debug('Renderd data==>>>'+wrapEmail);
        for(JO_ObjectLongTextWrapper wrs: wrapEmail)
        {
            getbody=wrs.HtmlBody;    
        }
        system.debug('Renderd data==>>>'+getbody);
    }*/
}