🧠 What are Big Objects in Salesforce?
Big Objects are Salesforce’s way to store and manage massive volumes of data (billions of records) without affecting performance. They're designed for:

Historical data (e.g. old cases, logs)

Auditing/Archiving

Analytics/Reporting (via tools like Einstein or External Systems)

❗ Big Objects are read-only once inserted — you can only insert and query (no updates/deletes).

🛠️ How to Set Up a Custom Big Object
🔹 Step 1: Create a Big Object Definition
You can do this via Metadata API or SFDX project. Here’s how to define one in a .object-meta.xml file.

Folder structure:

pgsql
Copy
Edit
force-app/
└── main/
    └── default/
        └── objects/
            └── My_Big_Object__b/
                └── My_Big_Object__b.object-meta.xml
📄 Example: My_Big_Object__b.object-meta.xml
xml
Copy
Edit
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>My Big Object</label>
    <deploymentStatus>Deployed</deploymentStatus>
    <description>Stores historical events</description>
    <fields>
        <fullName>EventDate__c</fullName>
        <label>Event Date</label>
        <type>DateTime</type>
    </fields>
    <fields>
        <fullName>UserId__c</fullName>
        <label>User ID</label>
        <type>Text</type>
        <length>18</length>
    </fields>
    <fields>
        <fullName>Details__c</fullName>
        <label>Details</label>
        <type>LongTextArea</type>
        <visibleLines>3</visibleLines>
    </fields>
    <indexes>
        <fullName>UserIndex</fullName>
        <label>User Index</label>
        <fields>
            <name>UserId__c</name>
            <sortDirection>ASC</sortDirection>
        </fields>
        <unique>false</unique>
    </indexes>
</CustomObject>
🔹 Step 2: Deploy with SFDX
bash
Copy
Edit
sfdx force:source:deploy -p force-app/main/default/objects/My_Big_Object__b
📥 How to Load Data into Big Objects
Use the Bulk API or Async Apex. Here's how to insert via Apex:

🧾 Example Apex Insertion
apex
Copy
Edit
My_Big_Object__b record = new My_Big_Object__b();
record.UserId__c = '005...';
record.EventDate__c = DateTime.now();
record.Details__c = 'Logged access';

Database.insertImmediate(record); // This inserts into Big Object
⚠️ Use Database.insertImmediate() for Big Objects — NOT regular insert.

🔍 How to Query Big Objects
Only SOQL-like syntax with a WHERE clause on the index fields:

apex
Copy
Edit
List<My_Big_Object__b> records = [
  SELECT UserId__c, EventDate__c FROM My_Big_Object__b
  WHERE UserId__c = '005...'
];
❗ You must filter by all index fields in the correct order.

🧯 Common Big Object Errors & How to Debug Them
❌ 1. System.BigObjectException: Only insertImmediate allowed
Fix: Use Database.insertImmediate() instead of insert.

❌ 2. INVALID_QUERY_FILTER_OPERATOR: Filtering must include all index fields
Fix: Ensure your WHERE clause includes all fields in the index definition (and in the exact order).

❌ 3. FIELD_INTEGRITY_EXCEPTION when deploying
Fix: This usually happens if:

Field type doesn’t match Big Object requirements.

Text fields > 255 chars must be LongTextArea.

❌ 4. Too Many Lock Contention Failures
Explanation: This occurs when:

Multiple processes try to write to the same Big Object index at the same time.

It's common during bulk loads or parallel inserts.

Solutions:

Break batch jobs into smaller batches.

Reduce concurrency.

Ensure index uniqueness to avoid clashes.

🎯 Data Architect Exam Tips on Big Objects

Topic	Key Points
Big Object Use Cases	Use for audit/history, not transactional data
Indexing	Must index fields you want to filter on; max 5 fields
Querying	Only query using SELECT with full index in WHERE
Limitations	No updates, no deletes, not visible in UI/reporting
Deployment	Always via Metadata API or SFDX — not UI
Data Locks	Mitigate using low-concurrency and async inserts
🧪 Testing Big Objects
Salesforce doesn’t support Test Data Insertion into Big Objects directly. You can:

Write Apex Tests that mock the logic around Big Object usage.

Avoid test failures by abstracting logic and mocking inserts.

📌 Summary Cheat Sheet

Feature	Big Object
CRUD support	Only Create + Read
UI Support	❌ Not visible in standard UI
Reporting	❌ No Reports
Query	Only via Apex/Developer Console
Max records	Billions
Deployment	Metadata/SFDX only
Indexes	Max 5, mandatory for query
Insert method	insertImmediate() only
Use case	Historical data, archiving, event logs