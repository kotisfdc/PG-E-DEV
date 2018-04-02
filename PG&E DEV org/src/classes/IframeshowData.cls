public class IframeshowData {
    public static string cnval{get; set;}
    public static string val{get{   val=cnval; 
                                             return val;   
 } set;}   
    
    @AuraEnabled
    public static string assignValue(string svr){
        cnval = svr;
          system.debug('aura-->'+cnval);   
          return svr;
       }    

}