/**
 * @description       : 
 * @author            : jamesperram@gmail.com
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : jamesperram@gmail.com
**/
public class AccountToBigObjectArchiver implements Schedulable {

    public void execute(SchedulableContext sc) {
        // Step 1: Query Accounts (safe limit for demo)
        List<Account> accounts = [
            SELECT Id, Name, Industry, Type, OwnerId
            FROM Account
            WHERE CreatedDate = TODAY
            LIMIT 200 // Keep it safe in non-batch context
        ];

        // Step 2: Build Big Object records
        List<My_Big_Object__b> snapshots = new List<My_Big_Object__b>();

        for (Account acc : accounts) {
            try {
                if (String.isEmpty(acc.Id)) continue;

                String details = 'Name: ' + acc.Name + 
                                 ', Industry: ' + acc.Industry + 
                                 ', Type: ' + acc.Type;

                My_Big_Object__b record = new My_Big_Object__b();
                record.JamesID__c = acc.Id;
                record.EventDate__c = System.now();
                record.Details__c = details;
                record.UserId__c = acc.OwnerId;

                snapshots.add(record);
            } catch (Exception e) {
                System.debug('⚠️ Error with Account ' + acc.Id + ': ' + e.getMessage());
            }
        }

        // Step 3: Insert into Big Object
        if (!snapshots.isEmpty()) {
            try {
                Database.insertImmediate(snapshots);
                System.debug('✅ Archived ' + snapshots.size() + ' accounts into Big Object.');
            } catch (Exception e) {
                System.debug('💥 Insert to Big Object failed: ' + e.getMessage());
            }
        } else {
            System.debug('⚠️ No valid Account records to archive.');
        }
    }
}
