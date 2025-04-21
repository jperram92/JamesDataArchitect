/**
 * @description       : 
 * @author            : jamesperram@gmail.com
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : jamesperram@gmail.com
**/
public class LogUtil {
    public static void logError(String refId, String message) {
        try {
            insert new Log__c(
                LogType__c = 'Error',
                ReferenceId__c = refId,
                Message__c = message
            );
        } catch (Exception ex) {
            System.debug('⚠️ Failed to log error: ' + ex.getMessage());
        }
    }

    public static void logInfo(String refId, String message) {
        try {
            insert new Log__c(
                LogType__c = 'Info',
                ReferenceId__c = refId,
                Message__c = message
            );
        } catch (Exception ex) {
            System.debug('⚠️ Failed to log info: ' + ex.getMessage());
        }
    }
}
