Implementation Guide: Next Steps for Salesforce Data Architect Training

This document provides step-by-step implementation guidance for the advanced "Next Steps" identified in the EcoSupply Australia training org design. These steps simulate real enterprise architecture tasks for deeper learning.

🔗 Step 1: ERP Integration with External Objects

Goal:

Simulate integration with an ERP system using Salesforce Connect and External Objects.

Tools:

Salesforce Connect

OData 2.0 / 4.0 mock server (or public dataset like OData.org)

Instructions:

Go to Setup → External Data Sources.

Create a new External Data Source:

Type: Salesforce Connect: OData 2.0

URL: https://services.odata.org/V2/Northwind/Northwind.svc (for demo)

Format: JSON or XML

Click Validate and Sync → Select Invoices → Sync

An object like Invoices__x will be created

Create a lookup relationship on Account or Opportunity to this object

Test SOQL:

SELECT Id, Customer_Name__c, Invoice_Total__c FROM Invoices__x LIMIT 5

🔁 Step 2: Build an ETL Simulation with Python or MuleSoft

Goal:

Practice extracting data from an external source and inserting it into Salesforce.

Option A: Python (Simple ETL Simulation)

Install libraries:

pip install simple-salesforce pandas

Sample script:

from simple_salesforce import Salesforce
import pandas as pd

sf = Salesforce(username='your-user', password='your-pass', security_token='your-token')
data = pd.read_csv('contacts.csv')

for _, row in data.iterrows():
    sf.Contact.create({
        'FirstName': row['FirstName'],
        'LastName': row['LastName'],
        'Email': row['Email'],
        'External_Id__c': row['ExternalId']
    })

Option B: MuleSoft (Enterprise Grade)

Create a new MuleSoft project in Anypoint Studio

Use Salesforce Connector → Basic Authentication

Use HTTP Listener + DataWeave to transform and upsert

🛡️ Step 3: Explore Salesforce Shield and Big Objects

A. Platform Encryption (Shield)

Go to Setup → Platform Encryption

Enable encryption for fields such as Contact.SSN__c

Create Key Management Policy

B. Field Audit Trail

Setup → Field History Tracking → Choose up to 60 fields

Add to Field Audit Trail (if Shield is enabled)

C. Big Objects

Create a Big Object using Metadata:

<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>Device Log</label>
    <fullName>Device_Log__b</fullName>
    <fields>
        <fullName>DeviceId__c</fullName>
        <label>Device ID</label>
        <type>Text</type>
    </fields>
    <indexes>
        <fullName>DeviceLogIndex</fullName>
        <label>Device Index</label>
        <fields>
            <name>DeviceId__c</name>
            <sortDirection>ASC</sortDirection>
        </fields>
    </indexes>
</CustomObject>

Deploy using VS Code or Metadata API

Query using SOQL with filters on indexed fields:

SELECT DeviceId__c FROM Device_Log__b WHERE DeviceId__c = 'D1001'

🧪 Bonus: Combine ETL + Shield

Simulate a secure ETL pipeline:

Extract contacts from public CSV

Encrypt fields like Email in Shield

Monitor load failures

✅ Summary

This implementation guide lets you:

Simulate ERP integration with External Objects

Create full-cycle ETL pipelines using Python or MuleSoft

Explore LDV tools like Shield and Big Objects for real-world LDV resilience

Recommended next step: Create a dashboard showing imported invoices, ETL success logs, and encryption audit trail for stakeholders.

🎯 Objective

To create a dynamic dashboard titled "DataOps Overview" that surfaces:

ERP-sourced invoice records

ETL job success/failure trends

Changes to encrypted fields or sensitive data

🏗️ Step 1: Define Report Foundations

Custom Report Types:

Invoices Report

Base Object: Invoices__x

Related Object: Opportunity or Account

Filters: Invoice Date = LAST 30 DAYS

ETL Logs Report

Custom Object: ETL_Log__c

Fields: Status, Sync_Time__c, Record_Count__c, Job_Reference__c

Grouped by: Status (Success/Fail)

Audit Trail / Field Change Report

Source: Setup Audit Trail (download/export required for external view) or Field History Tracking

Fields: Object, Field, Old Value, New Value, Modified By, Date

🗂️ Step 2: ETL_Log__c Object Schema

<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>ETL Log</label>
    <fullName>ETL_Log__c</fullName>
    <fields>
        <fullName>Job_Reference__c</fullName>
        <label>Job Reference</label>
        <type>Text</type>
    </fields>
    <fields>
        <fullName>Sync_Time__c</fullName>
        <label>Sync Time</label>
        <type>DateTime</type>
    </fields>
    <fields>
        <fullName>Record_Count__c</fullName>
        <label>Record Count</label>
        <type>Number</type>
    </fields>
    <fields>
        <fullName>Status__c</fullName>
        <label>Status</label>
        <type>Picklist</type>
        <valueSet>
            <valueSetDefinition>
                <value>Success</value>
                <value>Failed</value>
            </valueSetDefinition>
        </valueSet>
    </fields>
</CustomObject>

📊 Step 3: Build the Dashboard

Name: DataOps Overview

Location: Public Folder or Data Governance Folder

Components:

Latest Imported Invoices

Type: Table or Bar Graph

Report: Invoices__x Report (LAST 30 DAYS)

ETL Job Outcomes

Type: Donut or Bar Chart

Report: ETL_Log__c grouped by Status

Subtitle: "Last 10 Syncs"

Encrypted Field Changes

Type: Table or Line Chart

Report: Encrypted Field Change History

Include: Field Name, Change Date, Modified By

Design Tips:

Use chart colors to reflect job success (green) and failure (red)

Enable dynamic filters by Date, Object, or Job

Include descriptive dashboard headers

🚀 Deployment Option: Metadata JSON

Use Salesforce CLI or VS Code to deploy dashboard metadata:

sfdx force:source:deploy -p force-app/main/default/reports/Dashboard_DataOpsOverview.report-meta.xml

You can extract a sample dashboard using:

sfdx force:source:retrieve -m Dashboard:DataOps_Overview

📈 Visualization Samples (Concepts)

KPI Widgets: Total Invoices, Total ETL Failures This Week

Heat Map: Time of day with most failures (if logs have timestamp granularity)

Trend Line: Monthly encrypted field changes

Stacked Bar: Records imported by ETL Job Reference

✅ Summary

With this guide, you can:

Build stakeholder-facing dashboards for DataOps transparency

Track ETL reliability, audit sensitive data changes

Present integrated ERP activity inside Salesforce visually

This dashboard is the final piece in turning your mock architecture into a measurable, visual, enterprise-grade simulation.

