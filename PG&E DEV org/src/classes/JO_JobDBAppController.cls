public class JO_JobDBAppController {
    public static List<String> userDetails {get; set;}

    @AuraEnabled
    public static List<String> getUserInfo(){
        userDetails = new  List<String>();
        userDetails.add(UserInfo.getName()); 
        userDetails.add([Select Id, Name From User Where Id =: UserInfo.getUserId()].Id);  
        return userDetails;
    }
}