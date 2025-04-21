import { LightningElement, track } from 'lwc';
import simulateQuery from '@salesforce/apex/QueryPlanSimulatorController.simulateQuery';
import findAccountNames from '@salesforce/apex/QueryPlanSimulatorController.findAccountNames';
import describeFieldMetadata from '@salesforce/apex/FieldMetadataService.describeFieldMetadata';


export default class QueryPlanSimulator extends LightningElement {
    objectName = '';
    whereClause = '';
    valueInput = '';
    autocompleteInput = '';

    @track result;
    @track error;
    @track autocompleteResults = [];
    @track fieldAnalysis;
    @track fieldAnalysisError;

    handleAnalyzeField() {
        this.fieldAnalysis = null;
        this.fieldAnalysisError = null;
    
        if (!this.objectName || !this.selectedField) {
            this.fieldAnalysisError = 'Please enter object name and field name.';
            return;
        }
    
        describeFieldMetadata({ objectName: this.objectName, fieldName: this.selectedField })
            .then(data => {
                if (data.error) {
                    this.fieldAnalysisError = data.error;
                } else {
                    this.fieldAnalysis = data;
                }
            })
            .catch(err => {
                this.fieldAnalysisError = err.body?.message || err.message;
            });
    }

    handleFieldInput(event) {
        this.selectedField = event.detail.value;
    }

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
