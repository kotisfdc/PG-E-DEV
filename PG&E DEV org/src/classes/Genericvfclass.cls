public class Genericvfclass 
{
    public String recid {get;set;}
    public void fetchid()
    {
        string s = apexpages.currentPage().getParameters().get('id');
        recid = s;
        System.debug('coming inside : '+s);
    }
}