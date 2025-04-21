import { LightningElement, wire } from 'lwc';
import getInvoices from '@salesforce/apex/InvoiceController.getInvoices';

export default class ExternalInvoices extends LightningElement {
    invoices;
    error;

    columns = [
        { label: 'Order ID', fieldName: 'OrderID__c' },
        { label: 'Customer Name', fieldName: 'CustomerName__c' },
        { label: 'Product', fieldName: 'ProductName__c' },
        { label: 'Quantity', fieldName: 'Quantity__c', type: 'number' },
        { label: 'Unit Price', fieldName: 'UnitPrice__c', type: 'currency' }
    ];

    @wire(getInvoices)
    wiredData({ data, error }) {
        if (data) {
            this.invoices = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.invoices = undefined;
        }
    }
}
