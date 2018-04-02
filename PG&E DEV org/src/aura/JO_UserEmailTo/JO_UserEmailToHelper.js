({ 
    getAllJobOwnerList : function(component,event,getInputkeyWord){
         var joCorpRec =  component.get("v.allJobOwnerRecords");
         var arr=[];
         var i = 0;
         for (var key in joCorpRec)
         {
             if(joCorpRec[key].Email!=null )
             {
                  if((joCorpRec[key].Email.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) || (joCorpRec[key].FirstName.toLowerCase().startsWith(getInputkeyWord.toLowerCase())) || (joCorpRec[key].LastName.toLowerCase().startsWith(getInputkeyWord.toLowerCase())))
                  {   
                        arr.push(joCorpRec[key]);
                      i++;
                  }
              }     
          }                
                component.set('v.listOfSearchRecords',arr);
        if(i==0)
        {
         /* var usr = component.get("v.testuser"); 
             usr.FirstName = getInputkeyWord;
            usr.LastName =getInputkeyWord;
            usr.Email =getInputkeyWord; 
            usr.FederationIdentifier = getInputkeyWord;  */
            
            
           
         //  var usr = "{ 'sobjectType': 'User','FirstName':'"+getInputkeyWord+"','LastName':'"+getInputkeyWord+"','Email':'"+getInputkeyWord+"'}";
            
            arr.push({ 'sobjectType': 'User',
                           'FirstName': getInputkeyWord,
                         'LastName': getInputkeyWord,
                           'Email':getInputkeyWord     
                       });
            component.set('v.listOfSearchRecords',arr);
          // component.set('v.Message',"Please enter a vaild data");  
            
        }
    }, 
})