---
name: eda-workflow
description: Systematic exploratory data analysis for a new dataset before modelling. Use when inspecting a new dataset's schema, missingness, class balance, distributions, correlations, and outliers.
---

# eda-workflow

run a structured exploratory data analysis before building models.

## inputs to establish first

confirm or inspect from the workspace:
- dataset name, format (`csv`, `parquet`, `jsonl`, images, etc.), and location
- approximate size (rows x columns or file size)
- task type (`classification`, `regression`, `generation`, etc.), target variable, and evaluation metric

## phases

### 1. loading and schema
1. load the dataset and report shape.
2. print dtypes for every column.
3. flag object/string columns that should be numeric, and numeric columns that should be categorical.
4. inspect the first 5 rows and summary statistics.
5. document schema issues before proceeding.

### 2. missing values
1. count missing values per column (column, count, percentage).
2. flag columns with >20% missing as high-risk.
3. if the target variable has missing values, stop and report — never silently drop missing targets.
4. note whether missingness appears random or structural.

### 3. class balance (classification)
1. print target value counts.
2. compute imbalance ratio (`majority / minority`). flag if `> 5`.

### 4. distributions
1. numeric columns: plot histograms and flag `|skew| > 1.5`.
2. categorical columns with `< 20` unique values: plot bar charts.
3. flag low-variance columns where one value exceeds 95% of rows.

### 5. correlations
1. compute Pearson correlation matrix for numeric features; flag redundant pairs with `|r| > 0.9`.
2. rank numeric features by correlation with the target (top 10 and bottom 10).

### 6. outliers
1. flag numeric values beyond 3 standard deviations and report counts per column.
2. never remove outliers automatically; flag and report.

## output

save plots to `figures/eda/` and write `eda_summary.md` containing:
- schema issues
- missing value summary
- class balance finding
- top 3 distribution observations
- top 3 correlation findings
- outlier summary
- concrete next steps (imputation, splits, feature ideas)
