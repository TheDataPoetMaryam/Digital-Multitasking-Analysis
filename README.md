# 🧠 Digital Multitasking & Cognitive Performance Analysis

> A multi-tool statistical analysis exploring how digital multitasking behaviour affects cognitive task performance.

---

## 📌 Overview

This project investigates the impact of digital multitasking on cognitive performance using real survey data and statistical modeling.

It combines **SQL for data preprocessing** and **R for statistical analysis** to build a structured and realistic analytical pipeline.

---

## 🧩 Workflow

### 🔹 1. Data Preprocessing (SQL)

* Cleaning raw survey data
* Handling encoding issues and inconsistent formats
* Converting categorical responses into numerical features
* Constructing derived variables such as **Multitasking Index**

---

### 🔹 2. Statistical Analysis (R)

* Descriptive statistics
* Correlation analysis
* Multiple regression modeling
* Interaction effects
* Multicollinearity diagnostics (VIF)

---

### 🔹 3. Advanced Analysis

* K-Means clustering (behavioral segmentation)
* Decision tree modeling
* Mediation analysis (indirect effects via focus level)

---

## 📊 Key Findings

* Multitasking behaviour alone does not significantly reduce performance
* Notification frequency has a strong negative impact on task accuracy
* Higher focus levels improve cognitive performance
* Performance differences emerge when multitasking interacts with interruptions

---

## ⚠️ Limitations

* Based on self-reported behavioural data
* Cross-sectional dataset
* External environmental factors not included

---

## 📁 Project Structure

```text
Digital-Multitasking-Analysis/
│
├── multitasking_analysis.R
├── data_preprocessing.sql
├── data/
│   └── dataset.csv
├── report.pdf
├── README.md
```

---

## 🛠️ Tech Stack

* SQL (MySQL)
* R
* tidyverse / ggplot2
* psych, car, corrplot
* rpart, mediation

---

## 👩‍💻 Author

Maryam Shaikh

MSc Applied Statistics

Interested in Behavioral Data Analysis and Statistical Modeling
