/**
 * @description       : 
 * @author            : jamesperram@gmail.com
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : jamesperram@gmail.com
**/
global class Batch_AccountToBigObjectArchiver implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Pull all accounts (simulate large volume)
        return Database.getQueryLocator([
            SELECT Id, Name, Industry, Type, OwnerId
            FROM Account
        ]);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<My_Big_Object__b> recordsToInsert = new List<My_Big_Object__b>();
        
        for (SObject sObj : scope) {
            Account acc = (Account)sObj;
            try {
                if (String.isEmpty(acc.Id)) continue;

                String details = 'Name: ' + acc.Name +
                                 ', Industry: ' + acc.Industry +
                                 ', Type: ' + acc.Type;

                if (acc.Name != null && acc.Name.startsWith('Fake Bad')) {
                                    // 💣 Trigger intentional failure
                                    details = '💥'.repeat(40000); // 40,000 chars — exceeds Long Text Area max (32,768)
                                }

                My_Big_Object__b bo = new My_Big_Object__b();
                bo.JamesID__c = acc.Id;
                bo.EventDate__c = System.now();
                bo.Details__c = details;
                bo.UserId__c = acc.OwnerId;

                recordsToInsert.add(bo);
            } catch (Exception ex) {
                LogUtil.logError(acc.Id, 'Transformation failed in batch: ' + ex.getMessage());
            }
        }

        if (!recordsToInsert.isEmpty()) {
            try {
                Database.insertImmediate(recordsToInsert);
            } catch (Exception ex) {
                LogUtil.logError('BatchInsert', 'InsertImmediate failed: ' + ex.getMessage());
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        LogUtil.logInfo('BatchFinish', 'Batch job for Account to Big Object finished.');
    }
}