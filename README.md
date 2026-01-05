# A/B Testing: Landing Page Conversion Analysis

## 📌 Business Objective
Determine whether the newly designed landing page results in a statistically
significant increase in user conversion compared to the existing (old) landing page.
The outcome of this analysis helps inform whether the new page should be rolled out
to all users.

---

## 📊 Dataset Description
The project uses large-scale, user-level experimental data consisting of
approximately **580,000 total records** across two raw datasets:

- **ab_data.csv (~290,000 rows)**  
  User-level experiment data including:
  - user_id
  - user_group (control / treatment)
  - landing_page (old_page / new_page)
  - converted (0 or 1)
  - session duration and timestamp

- **countries.csv (~290,000 rows)**  
  Mapping of users to their respective countries.

After SQL-based cleaning and experiment validation (duplicate removal and
assignment correction), a final analysis-ready dataset was created:

- **ab_final.csv (~189,000 unique users)**  
  Cleaned and validated dataset used for statistical analysis.

---

## 🛠️ Data Preparation (SQL)
All data cleaning and experiment validation were performed using SQL to ensure
data integrity before statistical analysis.

Key steps:
- Joined experiment data with country information
- Removed duplicate users to maintain independence
- Filtered invalid control–treatment page assignments
- Exported a clean, analysis-ready dataset

SQL script: `sql/ab_testing.sql`

---

## 🔍 Analysis Approach (Python)
The statistical analysis and exploratory data analysis were performed in Python
using Google Colab.

Key analysis steps:
- Exploratory Data Analysis (EDA)
- Conversion rate comparison between control and treatment groups
- Two-sample Z-test for proportions
- Time-based session behavior analysis
- Country-level conversion comparison

Notebook: `notebooks/ab_testin.ipynb`  

---

## 📈 Key Result
At a 95% confidence level, the analysis **did not find a statistically significant
difference** in conversion rate between the old landing page and the new landing page.
Based on the results, there is insufficient evidence to recommend a full rollout
of the new page.

---

## 🧰 Tools & Technologies
- SQL (data cleaning and validation)
- Python
- Pandas & NumPy
- Matplotlib & Seaborn
- Statsmodels
- Google Colab

---
