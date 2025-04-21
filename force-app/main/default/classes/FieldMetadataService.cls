/**
 * @description       : 
 * @author            : jamesperram@gmail.com
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : jamesperram@gmail.com
**/
public with sharing class FieldMetadataService {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> describeFieldMetadata(String objectName, String fieldName) {
        Map<String, Object> info = new Map<String, Object>();
        try {
            // Describe the object and field
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
            if (objType == null) {
                info.put('error', 'Invalid object name: ' + objectName);
                return info;
            }

            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            Map<String, Schema.SObjectField> fields = objDescribe.fields.getMap();

            if (!fields.containsKey(fieldName)) {
                info.put('error', 'Field "' + fieldName + '" not found on ' + objectName);
                return info;
            }

            Schema.DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();

            info.put('fieldName', fieldName);
            info.put('label', fieldDescribe.getLabel());
            info.put('isCustom', fieldDescribe.isCustom());
            info.put('isExternalId', fieldDescribe.isExternalId());
            info.put('isUnique', fieldDescribe.isUnique());
            info.put('dataType', fieldDescribe.getType().name());

            // Heuristically infer indexed fields
            Boolean isIndexed = (
                fieldDescribe.getName() == 'Id' ||
                fieldDescribe.getName() == 'Name' ||
                fieldDescribe.getName().endsWith('__c') && fieldDescribe.isExternalId()
            );
            info.put('isIndexed', isIndexed);

            // Heuristic selectivity hint
            String selectivity;
            if (isIndexed && fieldDescribe.getType() == Schema.DisplayType.String) {
                selectivity = 'High';
            } else if (fieldDescribe.getType() == Schema.DisplayType.String) {
                selectivity = 'Medium';
            } else {
                selectivity = 'Low';
            }
            info.put('selectivityHint', selectivity);

        } catch (Exception e) {
            info.put('error', e.getMessage());
        }
        return info;
    }
}
