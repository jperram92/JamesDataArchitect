📘 Overview

This document outlines a comprehensive Solution Architecture and Design for a fictional organization to simulate real-world issues and build hands-on skills in a Salesforce Developer Edition Org. The goal is to cover the Salesforce Certified Data Architect topics with an immersive, guided practice.

🏢 Organization Profile

Org Name: EcoSupply Australia Pty LtdIndustry: Renewable Energy & Equipment DistributionEmployees: 300+ staff across AustraliaSalesforce Org: Salesforce Enterprise Edition (with Dev Org for testing)

🚩 Known Issues

Reports take too long due to millions of case records.

Data duplication across accounts and leads.

Lack of central "golden record" for clients.

Data governance policies are undocumented.

External ERP and Billing system requires integration.

🧩 Objects & Relationships

Standard Objects:

Account

Contact

Lead

Opportunity

Case

Custom Objects:

Energy_Device__c — Represents physical energy devices (solar panels, batteries, etc.)

Device_Maintenance__c — Child of Energy_Device__c

Supply_Order__c — Linked to Opportunity

Customer_Survey__c — Linked to Contact

External Object:

ERP_Invoice__x — Mocked external invoice data via Salesforce Connect

Diagram

Account → Contact → Opportunity → Supply_Order__c                  ↘ Energy_Device__c → Device_Maintenance__c

🔍 Data Modeling Exercises

Create:

Lookup and master-detail relationships

Validation Rules for data integrity

Formula fields to auto-calculate warranty expiration

-- SOQL: Fetch active devices with maintenance
SELECT Name, Serial_Number__c, (SELECT Name, Maintenance_Date__c FROM Device_Maintenances__r)
FROM Energy_Device__c WHERE Status__c = 'Active'

🧠 Large Data Volumes (LDV)

Scenario:

Over 30M Cases linked to Energy_Device__c.

Tasks:

Create Skinny Table Request (mock)

Use Query Plan Tool to optimize:

SELECT Id, Subject, CreatedDate FROM Case WHERE Energy_Device__c != NULL

Enable filters, custom indexes:

Filter by CreatedDate and custom Status__c

🔐 Data Governance Exercises

Tag fields with PII and PHI classification

Setup Field Audit Trail and Field History Tracking

Create Permission Sets to restrict sensitive fields

Apex: Field Classification Tag Simulation

public class DataGovernanceChecker {
    public static void logSensitiveFields() {
        for(SObjectField field : Schema.Account.fields.getMap().values()) {
            if(field.getDescribe().getInlineHelpText().contains('PII')) {
                System.debug('PII Field: ' + field);
            }
        }
    }
}

🔁 Data Migration

Use Data Loader to simulate insert/update/upsert

Enable "Set Audit Fields" to preserve original creation dates

Track failed loads

Upsert Command:

sfdx force:data:bulk:upsert -s Contact -f contacts.csv -i External_Id__c -w 2

🌟 Master Data Management

Create duplicate Contacts

Define "Golden Contact"

Use Matching Rules and Duplicate Rules

Matching Rule Logic

Match on Email + LastName

Apex: Golden Record Resolver

public class GoldenRecordUtil {
    public static Contact resolveGoldenRecord(List<Contact> duplicates) {
        for(Contact c : duplicates) {
            if(c.Has_Signed_Contract__c) return c;
        }
        return duplicates[0];
    }
}

⚙️ Fun with LWC

1. Standard Object LWC: Recent Opportunities

import { LightningElement, wire } from 'lwc';
import getOpps from '@salesforce/apex/OppController.getRecentOpportunities';

export default class RecentOpps extends LightningElement {
    @wire(getOpps) opportunities;
}

Apex Class:

public with sharing class OppController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getRecentOpportunities() {
        return [SELECT Name, Amount, StageName FROM Opportunity ORDER BY CreatedDate DESC LIMIT 10];
    }
}

2. Custom Object LWC: Active Devices

import { LightningElement, wire } from 'lwc';
import getDevices from '@salesforce/apex/DeviceController.getActiveDevices';

export default class DeviceList extends LightningElement {
    @wire(getDevices) devices;
}

Apex Class:

public with sharing class DeviceController {
    @AuraEnabled(cacheable=true)
    public static List<Energy_Device__c> getActiveDevices() {
        return [SELECT Name, Serial_Number__c FROM Energy_Device__c WHERE Status__c = 'Active'];
    }
}

📊 Reports & Dashboards

Create report types for Energy_Device__c with Device_Maintenance__c

Create dashboards:

"Device Health Overview"

"Sales Performance by Region"

"Data Skew Indicators"