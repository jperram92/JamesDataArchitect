/**
 * @description       : 
 * @author            : jamesperram@gmail.com
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : jamesperram@gmail.com
**/
public class MyBigObjectScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        List<My_Big_Object__b> logs = new List<My_Big_Object__b>();

        for (Integer i = 0; i < 10; i++) {
            try {
                String jamesId = 'JP' + i;

                if (String.isEmpty(jamesId)) continue;

                My_Big_Object__b r = new My_Big_Object__b();
                r.JamesID__c = jamesId;
                r.EventDate__c = DateTime.now().addMinutes(i);
                r.Details__c = 'Scheduled Event #' + i;
                r.UserId__c = UserInfo.getUserId();

                logs.add(r);
            } catch (Exception ex) {
                System.debug('❌ Skipped bad record at index ' + i + ': ' + ex.getMessage());
            }
        }

        if (!logs.isEmpty()) {
            try {
                Database.insertImmediate(logs);
                System.debug('✅ Inserted ' + logs.size() + ' Big Object records from scheduler.');
            } catch (Exception ex) {
                System.debug('💥 Insert failed in scheduled job: ' + ex.getMessage());
            }
        } else {
            System.debug('⚠️ No valid records to insert from scheduler.');
        }
    }
}
