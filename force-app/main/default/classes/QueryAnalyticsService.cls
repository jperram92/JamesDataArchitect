/**
 * @description       : 
 * @author            : jamesperram@gmail.com
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : jamesperram@gmail.com
**/
public with sharing class QueryAnalyticsService {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getHistogramByDate(String objectName, String dateFieldName) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();

        try {
            String query = 'SELECT CALENDAR_MONTH(' + dateFieldName + ') monthNum, COUNT(Id) recordCount ' +
                           'FROM ' + objectName + ' ' +
                           'WHERE ' + dateFieldName + ' != NULL ' +
                           'GROUP BY CALENDAR_MONTH(' + dateFieldName + ') ' +
                           'ORDER BY CALENDAR_MONTH(' + dateFieldName + ')';

            List<AggregateResult> rows = Database.query(query);

            for (AggregateResult row : rows) {
                Map<String, Object> bucket = new Map<String, Object>();
                bucket.put('label', 'Month ' + String.valueOf(row.get('monthNum')));
                bucket.put('count', row.get('recordCount'));
                result.add(bucket);
            }
        } catch (Exception e) {
            Map<String, Object> error = new Map<String, Object>();
            error.put('error', e.getMessage());
            result.add(error);
        }

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static String getPerformanceTip(Integer rowCount, Long queryTimeMs, Boolean isIndexed) {
        if (rowCount > 50000) {
            return '⚠️ Over 50k rows — consider using batch Apex or filters with indexable fields.';
        } else if (queryTimeMs > 1000) {
            return '🕒 Query took over 1s — avoid LIKE patterns with leading % or use skinny tables.';
        } else if (!isIndexed) {
            return '💡 Field not indexed — consider marking as External ID or filtering by CreatedDate.';
        } else {
            return '✅ Query performance looks healthy under current parameters.';
        }
    }
}
