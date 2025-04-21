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