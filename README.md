# 🗄️ AIDB - Artificial Intelligence Database

A comprehensive **fictional e-commerce database** project with realistic customer data generation, sophisticated deduplication techniques, and multi-year transactional analysis (2023-2026).

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![SQL](https://img.shields.io/badge/SQL-CC2927?style=flat-square&logo=microsoft-sql-server&logoColor=white)](https://en.wikipedia.org/wiki/SQL)
[![Data Analysis](https://img.shields.io/badge/Data%20Analysis-4CAF50?style=flat-square)](#)
[![Database](https://img.shields.io/badge/Type-Fictional-blueviolet?style=flat-square)](#)

---

## 📋 Overview

AIDB is a sophisticated PostgreSQL project that generates **realistic fictional data** for e-commerce business analytics. It creates customer profiles, product catalogs, and transactional records with realistic pricing dynamics, deduplication strategies, and Power BI-ready datasets.

### 🎯 Key Capabilities

- ✅ **Smart Data Generation**: 1,000+ realistic customer profiles with localized names
- ✅ **Intelligent Deduplication**: Advanced techniques to reduce duplicate records
- ✅ **Price Growth Modeling**: Realistic price evolution over 4 years
- ✅ **Multi-Country Support**: 9 European countries with culturally accurate names
- ✅ **Transactional Data**: 4 years of order history (2023-2026)
- ✅ **Power BI Ready**: Optimized views and cleaned datasets for visualization
- ✅ **Advanced SQL**: Window functions, CTEs, and sophisticated partitioning

---

## 📊 Database Architecture

### Core Tables

| Table | Purpose | Records |
|-------|---------|---------|
| **orders** | Main transactional table | 1M+ |
| **customers** | Customer demographic data | 1,000 |
| **product_map** | Product catalog | 15 |
| **powerbi_projekt** | Cleaned dataset for BI tools | Deduplicated |

### Product Categories

- 👕 **Clothing** (Shirt, Pants, Socks, Underwear, Hoodie, Leggings)
- 💊 **Health Supplements** (Protein, Collagen, Vitamins, Minerals, Omega-3)
- 💄 **Beauty** (Make-up, Skin Care, Hair Serum, Face Mask)

### Geographic Coverage

🇸🇰 Slovakia | 🇨🇿 Czech Republic | 🇵🇱 Poland | 🇫🇷 France | 🇩🇪 Germany | 🇮🇹 Italy | 🇪🇸 Spain | 🇳🇱 Netherlands | 🇭🇺 Hungary

---

## 🔄 Data Generation Pipeline

```
1. Customer Generation
   ├─ 1,000 unique customer profiles
   ├─ Gender distribution (50/50)
   ├─ Age range: 18-68 years
   └─ Localized names by country

2. Product Catalog
   ├─ 15 product variants
   ├─ Base pricing: €10-€100
   └─ Growth rates: 3-12% annually

3. Order Timeline
   ├─ 2023: 5-15 orders/day
   ├─ 2024: 20-40 orders/day
   ├─ 2025: 50-80 orders/day
   └─ 2026: 100-160 orders/day

4. Deduplication
   ├─ Remove duplicate customers
   ├─ Keep 15% of duplicates (test2)
   ├─ Target 25% for high-frequency names
   └─ One order per customer per day max
```

---

## 🛠️ Key SQL Techniques

### 1. **Dynamic Data Generation**
```sql
-- Generate series for realistic date ranges
generate_series('2023-01-01'::date, '2026-12-31'::date, '1 day'::interval)

-- Random name selection by country/gender
(ARRAY['Jan','Peter','Martin'])[FLOOR(RANDOM()*3)+1]
```

### 2. **Advanced Deduplication**
```sql
-- Keep only 15% of duplicate records
WITH dedup AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY customer_id, name ORDER BY RANDOM()) AS rn,
        COUNT(*) OVER (PARTITION BY customer_id, name) AS total
    FROM test1
)
SELECT * FROM dedup WHERE rn <= total * 0.15
```

### 3. **Price Growth Modeling**
```sql
-- Realistic annual price increases
ROUND(base_price * POWER(1 + growth_rate, EXTRACT(YEAR FROM order_date) - 2023), 2)
```

### 4. **Window Functions**
```sql
-- Partition-based analysis
COUNT(*) OVER (PARTITION BY order_date) AS daily_orders
DENSE_RANK() OVER (ORDER BY price DESC) AS price_rank
```

---

## 📁 Project Structure

```
AIDB/
├── README.md                              # This file
└── Fiktivna database.sql                  # Main SQL script
    ├── Table Creation & Data Generation   # Lines 1-190
    ├── Testing & Validation               # Lines 192-222
    ├── Deduplication Views (test1, test2) # Lines 223-263
    ├── Power BI Dataset                   # Lines 267-486
    └── Analysis Queries                   # Lines 488-530
```

---

## 🔍 Main Views & Tables

### test1 - Random Sample
25% random sample of original orders data for testing
```sql
-- Useful for quick validation without full dataset overhead
```

### test2 - Deduplicated Sample
Reduces duplicate customer names to 15% of their frequency
```sql
-- Significantly smaller dataset for faster analysis
```

### PowerBI View
Intelligent filtering of target customers with age calculation
- 25% of highly duplicated names kept
- All other names retained
- Age automatically calculated
- 1.4M+ records → optimized for visualization

### Powerbi_projekt Table
Final cleaned dataset - one order per customer per day
- Deduplicated transactions
- Ready for Power BI/Tableau
- Optimized performance

---

## 📈 Growth Trends

The database models realistic e-commerce growth over 4 years:

| Year | Orders/Day | Customer Base | Total Records |
|------|-----------|---------------|---------------|
| 2023 | 5-15      | ~100          | ~5K           |
| 2024 | 20-40     | ~400          | ~12K          |
| 2025 | 50-80     | ~700          | ~25K          |
| 2026 | 100-160   | ~1,000        | ~60K+         |

---

## 🎓 Learning Outcomes

This project demonstrates:

- **Advanced SQL**: CTEs, window functions, window frames
- **Data Engineering**: Generation, transformation, deduplication
- **Database Design**: Normalized structure, efficient queries
- **Performance Optimization**: Partitioning, indexing concepts
- **Real-World Scenarios**: Handling duplicates, growth modeling
- **Business Intelligence**: BI-ready data preparation

---

## 💡 Use Cases

- 📊 **Power BI/Tableau**: Pre-configured views ready for visualization
- 🔬 **SQL Learning**: Complex query examples and patterns
- 📈 **Data Analysis**: Sales trends, customer behavior, pricing evolution
- 🎯 **Portfolio Project**: Demonstrates advanced SQL skills
- 🧪 **Testing**: Large realistic dataset for database testing

---

## 🚀 Quick Start

### Prerequisites
- PostgreSQL 12+
- Basic SQL knowledge

### Setup
```bash
# 1. Open your PostgreSQL client
psql -U your_user -d your_database

# 2. Copy and run the entire Fiktivna database.sql file
\i 'Fiktivna database.sql'

# 3. Test the dataset
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM powerbi_projekt;
```

### First Queries
```sql
-- Check data distribution
SELECT product_category, COUNT(*) FROM powerbi_projekt GROUP BY product_category;

-- Analyze by country
SELECT country, COUNT(*) as customers FROM powerbi_projekt GROUP BY country;

-- Price trends
SELECT EXTRACT(YEAR FROM order_date) as year, AVG(price) FROM powerbi_projekt GROUP BY year;
```

---

## 📊 Data Quality Features

✨ **Realistic Profiles**
- Culturally appropriate names per country
- Coherent gender-name combinations
- Realistic age distribution

🔄 **Sophisticated Deduplication**
- Multi-level filtering approach
- Preserves data integrity
- Handles high-frequency duplicates intelligently

💰 **Realistic Pricing**
- Individual product growth rates
- Compound annual increases
- Realistic price ranges by category

📅 **Temporal Realism**
- Order volume grows with customer base
- Seasonal-like patterns supported
- Multi-year historical data

---

## 📝 Notes & Considerations

- **Data is Fictional**: All customer information is randomly generated and NOT real
- **Performance**: Full dataset (1M+ records) may require optimization for very large queries
- **Customizable**: Easily modify parameters like customer count, date ranges, or product categories
- **Power BI Ready**: Views optimized for quick load in visualization tools
- **Comments**: Original comments preserved in SQL for learning (mostly in Czech/Slovak)

---

## 🔧 Customization Tips

### Change Customer Count
```sql
FROM generate_series(1, 2000) AS id  -- Default is 1000
```

### Adjust Date Range
```sql
'2020-01-01'::date, '2024-12-31'::date  -- Default is 2023-2026
```

### Modify Product Categories
Add new entries to the `VALUES` section in product_map CTE

### Adjust Deduplication Rates
```sql
WHERE rn <= total * 0.25  -- Change 0.25 to desired percentage
```

---

## 📚 Resources & References

- [PostgreSQL Window Functions](https://www.postgresql.org/docs/current/functions-window.html)
- [PostgreSQL CTEs](https://www.postgresql.org/docs/current/queries-with.html)
- [Generate Series Documentation](https://www.postgresql.org/docs/current/functions-srf.html)
- [Window Functions in SQL](https://mode.com/sql-tutorial/sql-window-functions/)

---

<details>
<summary><b>🎯 Advanced Topics</b></summary>

### ROW_NUMBER() vs RANK() vs DENSE_RANK()

```sql
-- ROW_NUMBER: Sequential numbering (1,2,3,4)
-- RANK: Gaps for ties (1,2,2,4)
-- DENSE_RANK: No gaps for ties (1,2,2,3)
```

### PARTITION BY Variations

```sql
-- By single column
PARTITION BY customer_id

-- By multiple columns
PARTITION BY order_date, customer_id

-- Multiple window functions in one query
ROW_NUMBER() OVER (PARTITION BY A ORDER BY B)
COUNT(*) OVER (PARTITION BY A)
```

### Deduplication Strategies

1. **Keep First**: `rn = 1`
2. **Keep Last**: `rn = total_count`
3. **Random Sample**: `RANDOM() < 0.15` (15%)
4. **Stratified**: Use CASE for different rates per group

</details>

---

## 👨‍💻 Author

**Jakub8b**

---

## 📄 License

[Specify your license - MIT, GPL, CC0, etc.]

---

**Status**: ✅ Active  
**Last Updated**: 2026-05-24  
**Dataset Period**: 2023-2026 (4 years)  
**Total Records**: 1M+  

