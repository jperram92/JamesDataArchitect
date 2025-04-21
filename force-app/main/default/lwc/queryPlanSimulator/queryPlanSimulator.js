import { LightningElement, track } from 'lwc';
import simulateQuery from '@salesforce/apex/QueryPlanSimulatorController.simulateQuery';
import findAccountNames from '@salesforce/apex/QueryPlanSimulatorController.findAccountNames';

export default class QueryPlanSimulator extends LightningElement {
    objectName = '';
    whereClause = '';
    valueInput = '';
    autocompleteInput = '';

    @track result;
    @track error;
    @track autocompleteResults = [];

    handleObjectChange(event) {
        this.objectName = event.detail.value;
    }

    handleWhereChange(event) {
        this.whereClause = event.detail.value;
    }

    handleValueChange(event) {
        this.valueInput = event.detail.value;
    }

    handleAutocompleteInput(event) {
        this.autocompleteInput = event.detail.value;

        if (this.autocompleteInput.length >= 2) {
            findAccountNames({ searchTerm: this.autocompleteInput })
                .then(results => {
                    this.autocompleteResults = results;
                })
                .catch(() => {
                    this.autocompleteResults = [];
                });
        } else {
            this.autocompleteResults = [];
        }
    }

    handleAutocompleteFocus() {
        this.autocompleteResults = [];
    }

    handleSelectAccount(event) {
        const selected = event.currentTarget.dataset.name;
        this.valueInput = selected;
        this.autocompleteInput = selected;
        this.autocompleteResults = [];
    }

    runQuery() {
        this.error = null;
        this.result = null;

        simulateQuery({
            objectApiName: this.objectName,
            whereClause: this.whereClause,
            valueInput: this.valueInput
        })
            .then(data => {
                if (data.error) {
                    this.error = data.error;
                } else {
                    this.result = data;
                }
            })
            .catch(err => {
                this.error = err.body ? err.body.message : err.message;
            });
    }
}
