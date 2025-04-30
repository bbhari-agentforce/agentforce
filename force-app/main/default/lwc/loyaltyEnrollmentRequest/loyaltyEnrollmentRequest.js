import { LightningElement, wire } from 'lwc';
import getRecords from '@salesforce/apex/LoyaltyEnrollmentRequestController.getRecords';

export default class LoyaltyEnrollmentRequest extends LightningElement {
    records;
    error;

    columns = [
        { label: 'UserFirstName', fieldName: 'UserFirstName__c' },
        { label: 'UserLastName', fieldName: 'UserLastName__c' },
        { label: 'UserEmail', fieldName: 'UserEmail__c' },
        { label: 'Status', fieldName: 'Status__c' }
    ];

    @wire(getRecords)
    wiredRecords({ error, data }) {
        if (data) {
            this.records = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.records = undefined;
        }
    }
}