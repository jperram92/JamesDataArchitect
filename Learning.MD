## 🔁 PRACTICE ROADMAP FOR SALESFORCE DEV ORG (DATA ARCHITECT TRACK)

---

### ✅ 1. **Data Modeling / Database Design (25%)**
#### 🎯 Activities:
- Create a complex data model with **custom objects**, **lookups**, and **master-detail relationships**
- Add **junction objects** for many-to-many relationships
- Set up **schema builder** and **external objects**

#### 🛠️ How:
1. Go to **Setup > Object Manager > Create Custom Object**
2. Add fields with different data types (Text, Picklist, Lookup, M/D, etc.)
3. Use **Schema Builder** to visualize it:  
   Setup → Schema Builder → Add your custom objects
4. Create external objects via **Salesforce Connect** to simulate ERP integration (e.g., mock external price list or invoices)

---

### ✅ 2. **Large Data Volume (LDV) Optimization (20%)**
#### 🎯 Activities:
- Simulate LDV with **bulk data load**
- Enable **Skinny Tables** (conceptually) and **Custom Indexes**
- Test performance with reports and list views

#### 🛠️ How:
1. Use **Data Loader** to insert 50k+ records (repeat batch insert to simulate LDV)
2. Query with **SOQL** in Developer Console:  
   `SELECT Id, Name FROM MyObject__c WHERE CreatedDate = LAST_N_DAYS:7`
3. Use **Query Plan Tool**:  
   Dev Console → Query Editor → Enable Query Plan
4. Explore options for **External IDs**, **Custom Indexes**, and **Skinny Tables (via support)**

---

### ✅ 3. **Data Governance (10%)**
#### 🎯 Activities:
- Set **field-level security**, **data classification tags**, and **permission sets**
- Apply **field audit trail** or simulate data lineage tracking

#### 🛠️ How:
1. Go to any field → Enable **data sensitivity** (e.g., PII, PHI)
2. Create **Permission Sets** and assign them to users
3. Setup → **Field History Tracking** on key fields like `Phone`, `Status`, etc.

---

### ✅ 4. **Salesforce Data Management (25%)**
#### 🎯 Activities:
- Create a backup/restore strategy using **Export/Import**
- Use **Data Loader**, **Data Import Wizard**, and **Scheduled Exports**
- Practice **Duplicate Rules** and **Matching Rules**

#### 🛠️ How:
1. Setup → Data → Data Export → Schedule full org export
2. Data Import Wizard (under Setup) → Try importing Leads or Accounts
3. Setup → Duplicate Rules → Create rule for Lead Phone Number
4. Create **Validation Rules** and use **Record Types** for branching data logic

---

### ✅ 5. **Master Data Management (5%)**
#### 🎯 Activities:
- Implement **Account-Contact hierarchy**
- Simulate **Golden Record logic**
- Work with **External ID** and **Upserts** via Data Loader

#### 🛠️ How:
1. Create `ParentAccount` relationships
2. Create a duplicate `Contact`, then use **upsert** with External ID
3. Create custom logic (like a Flow) to resolve conflicts and promote a “Master Record”

---

### ✅ 6. **Data Migration (15%)**
#### 🎯 Activities:
- Plan and simulate a **legacy to Salesforce** migration
- Practice **mapping**, **transformation**, **field matching**
- Track **createdDate**, **originalOwnerId** etc.

#### 🛠️ How:
1. Use Data Loader to **insert** and then **update** records
2. Use **"Set Audit Fields"** feature:  
   Setup → User Permissions → Enable "Set Audit Fields on Record Creation"
3. Track **errors** and **retry** failed imports
4. Build a simple **Flow or Apex** to mimic transformation (e.g., convert text to uppercase)

---

## 🚀 BONUS: Superbadge Recommendations
Use Trailhead to complete these **hands-on challenges**:
- **[Data Integration Specialist](https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_data_integration_specialist)**
- **[Data Management Specialist](https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_data_management_specialist)**
- **[Apex Specialist (for bonus Apex hands-on)](https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex_specialist)**

---

## 🎓 Tips for Maximizing Dev Org Usage
| Area | Tip |
|------|-----|
| ⚙️ Setup | Enable Dev Hub + Scratch Orgs (if you want to go deeper) |
| 🔄 Refresh | Reset your org if cluttered via Setup → Company Information |
| 🛠️ Tools | Use **Workbench**, **VS Code with SFDX**, and **Developer Console** |
| 📦 Data Gen | Use [Salesforce Sample Data](https://developer.salesforce.com/docs/atlas.en-us.data.meta/data/sforce_api_objects_sample_data.htm) or CSVs |

---

Would you like me to generate a checklist or markdown template of all these activities for your Confluence or Notion tracking system?