/**
 * @description       : 
 * @author            : jamesperram@gmail.com
 * @group             : 
 * @last modified on  : 04-21-2025
 * @last modified by  : jamesperram@gmail.com
**/
public with sharing class InvoiceController {
    @AuraEnabled(cacheable=true)
    public static List<Invoice__x> getInvoices() {
        return [SELECT Id, OrderID__c, CustomerName__c, ProductName__c, Quantity__c, UnitPrice__c 
                FROM Invoice__x LIMIT 50];
    }
}
