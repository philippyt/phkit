# spec: eda-workflow

## purpose

systematic exploratory data analysis for a new dataset before modelling.
copy this into `.claude/specs/eda.md` and fill in the dataset-specific fields.

---

## dataset

- name: [dataset name]
- format: [csv / parquet / jsonl / images / etc.]
- location: [path or source]
- approximate size: [rows × columns or file size]
- task: [classification / regression / generation / etc.]
- target variable: [column name or description]
- evaluation metric: [accuracy / AUC / F1 / RMSE / etc.]

## phase 1: loading and schema

1. load the dataset and print shape.
2. print dtypes for every column.
3. identify columns that are object type but should be numeric — flag them.
4. identify columns that are numeric but should be categorical — flag them.
5. print the first 5 rows.
6. print basic `.describe()` statistics.

do not proceed to phase 2 until schema issues are documented.

## phase 2: missing values

1. count missing values per column. print as a table: column, count, %.
2. flag any column with >20% missing as high-risk.
3. for the target variable: if any missing, stop and report. missing
   targets cannot be silently dropped without explicit instruction.
4. note the missingness pattern: random or structural?

## phase 3: class balance (classification tasks)

1. print value counts for the target variable.
2. compute the imbalance ratio: majority class / minority class.
3. if ratio > 5, flag as imbalanced and note in the summary.

## phase 4: distributions

1. for numeric columns: plot histograms. note skew > 1.5 or < -1.5.
2. for categorical columns: plot bar charts for columns with < 20 unique values.
3. flag any column with a single dominant value (>95% one value) as low-variance.

## phase 5: correlations

1. compute pearson correlation matrix for numeric columns.
2. flag pairs with |r| > 0.9 as highly correlated — potential redundancy.
3. compute correlation of each numeric feature with the target.
   sort descending. print top 10 and bottom 10.

## phase 6: outliers

1. for numeric columns: flag values beyond 3 standard deviations.
2. print count of outliers per column.
3. do not remove outliers automatically. flag and report.

## output

write a `eda_summary.md` with:
- schema issues found
- missing value summary
- class balance finding
- top 3 distribution observations
- top 3 correlation findings
- outlier summary
- recommended next steps (e.g. imputation strategy, feature engineering ideas)

all plots saved to `figures/eda/`.