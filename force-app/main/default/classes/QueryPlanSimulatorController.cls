/**
 * @description       : 
 * @author            : jamesperram@gmail.com
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : jamesperram@gmail.com
**/
public with sharing class QueryPlanSimulatorController {

    @AuraEnabled(cacheable=false)
    @SuppressWarnings('ApexSOQLInjection')
    public static Map<String, Object> simulateQuery(String objectApiName, String whereClause, String valueInput) {
        Map<String, Object> result = new Map<String, Object>();

        // Prepare safe WHERE clause
        String preparedClause;
        if (whereClause.contains('{{VALUE}}')) {
            String safeValue = '\'' + valueInput.replaceAll('\'', '\\\'') + '\'';
            preparedClause = whereClause.replace('{{VALUE}}', safeValue);
        } else {
            preparedClause = whereClause.replaceAll('\'', '\\\'');
        }

        // Dynamically construct query
        String query = 'SELECT Id FROM ' + objectApiName + ' WHERE ' + preparedClause;

        Long startTime = System.currentTimeMillis();

        List<SObject> records;
        try {
            records = Database.query(query);
        } catch (Exception e) {
            result.put('error', '⚠️ Query Error: ' + e.getMessage());
            return result;
        }

        Long endTime = System.currentTimeMillis();

        result.put('objectName', objectApiName);
        result.put('whereClause', preparedClause);
        result.put('rowCount', records.size());
        result.put('executionTimeMs', endTime - startTime);

        // ✅ Fixed: use temp list to avoid subList error
        List<SObject> sample = new List<SObject>();
        if (!records.isEmpty()) {
            Integer maxIndex = Math.min(5, records.size());
            for (Integer i = 0; i < maxIndex; i++) {
                sample.add(records[i]);
            }
        }
        result.put('sampleRecords', sample);

        // Notes
        if (records.isEmpty()) {
            result.put('notes', 'No records returned. Consider using more selective filters.');
        } else if (records.size() > 50000) {
            result.put('notes', 'High row count. Add selective filters or indexes.');
        } else if ((endTime - startTime) > 1000) {
            result.put('notes', 'Query took over 1s. Index optimization recommended.');
        } else {
            result.put('notes', 'Query appears performant under current conditions.');
        }

        return result;
    }



    @AuraEnabled(cacheable=true)
    public static List<String> findAccountNames(String searchTerm) {
        List<String> matches = new List<String>();
        if (!Schema.sObjectType.Account.isAccessible()) {
            return matches;
        }

        for (Account acc : [
            SELECT Name FROM Account 
            WHERE Name LIKE :('%' + searchTerm + '%') 
            ORDER BY LastModifiedDate DESC 
            LIMIT 10
        ]) {
            matches.add(acc.Name);
        }
        return matches;
    }
}
