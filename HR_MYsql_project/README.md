### HR Analytics – MySQL Project
# Project Overview
This project focuses on analyzing employee data from a Human Resources (HR) dataset using MySQL. The dataset was imported from Excel and required extensive cleaning and transformation before performing analytical queries to extract meaningful workforce insights.

### Data Preparation & Cleaning
Imported raw data from Excel into MySQL.
Renamed columns and adjusted incorrect encodings (e.g., ï»؟id → emp_id).
Converted all date fields (birthdate, hire_date, termdate) into proper DATE format.
Fixed inconsistent date formats (MM/DD/YYYY, MM-DD-YYYY) using STR_TO_DATE().
Handled missing or invalid values by removing or standardizing them.
Calculated employee age from birthdate and removed unrealistic entries (e.g., future birthdates).

### Key Insights & Analysis
Gender and race distribution across current employees.
Age group segmentation (20–30, 31–40, 41–50, 51+).
Comparison of employees in headquarters vs. remote locations.
Top job titles by number of employees.
Department-level analysis of turnover rates.
Tenure analysis: average years worked before termination.
% of employees who stayed more than 3 years.
Annual hiring trends by year.
Gender-based turnover breakdown.

### Example Business Questions Answered
 -- What is the age distribution of employees?
 -- How does gender vary by department and job title?
 -- Which department has the highest number of terminations?
 -- What is the average tenure in each department?
 -- How many employees are hired each year?
 -- What percentage of employees have long-term retention?

### Tools Used
 - MySQL
 - Excel
 - SQL Queries for Data Analysis
 - Data Cleaning and Transformation
