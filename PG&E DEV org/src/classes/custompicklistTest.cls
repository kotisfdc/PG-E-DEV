@isTest
public class custompicklistTest {
    testMethod static void custompicklistTestMethod(){
        String objName = 'Notifications__c';
        VisualEditor.DesignTimePageContext str = new VisualEditor.DesignTimePageContext();
        str.entityName =objName;
        Test.startTest();
        custompicklist obj = new custompicklist(str);
        obj.getDefaultValue();
        obj.getValues();
        Test.stopTest();
    }

}