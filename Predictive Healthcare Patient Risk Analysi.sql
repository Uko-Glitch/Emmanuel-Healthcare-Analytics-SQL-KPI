--REPORTED KPI
Select *
From [dbo].[Healthcare_Date]

-- Ranking Age on the number of patients Hospitalized
--Introduction to Analytical Function (Row Number, Rank, Dense Rank)
--Row number - assign a unique no to your data irrespective of duplication, It is used to identify duplicate records 
--Rank is also use to rank record, difference between rank and row number is if the record are the same
--it will assign the same Rank Number but giving a gap for the next rank
--Dense Rank is aslo use to rank record but it eliminates the gap between same records 
--All of this re called window function
SELECT 
       Age,
       COUNT(*) As Patient_Count,
       DENSE_RANK() OVER (ORDER By Age DESC) As Age_Rank
FROM [dbo].[Healthcare_Date]
GROUP By Age

-- Provide a list of hospitals along with the count of patients admitted in the year 2024 AND 2025
SELECT 
    Hospital,
    Year(Date_of_Admission) As Year_of_Admission,
    COUNT(*) As Patient_Count
FROM [dbo].[Healthcare_Date]
WHERE YEAR(Date_of_Admission) In (2024, 2025)
GROUP By Hospital, Year(Date_of_Admission)
ORDER By Patient_Count DESC

-- Most preferred Insurance Provider by Patients Hospitalized
SELECT Top 1 
    Insurance_Provider, 
    COUNT(*) As Usage_Count
FROM [dbo].[Healthcare_Date]
GROUP By Insurance_Provider
ORDER By Usage_Count DESC

-- Identifying Average Billing Amount by Medical Condition
SELECT 
    Medical_Condition, 
    ROUND(AVG(Billing_Amount), 2) As Average_Billing
FROM [dbo].[Healthcare_Date]
GROUP By Medical_Condition 

-- Finding Total number of days spent by patient in a hospital for given medical condition
SELECT 
    Medical_Condition, 
    SUM(DATEDIFF(DAY, Date_of_Admission, Discharge_Date)) As Total_Days_Spent
FROM [dbo].[Healthcare_Date]
GROUP By Medical_Condition

SELECT 
    Medical_Condition, 
    DATEDIFF(DAY, Date_of_Admission, Discharge_Date) As Total_Days_Spent
FROM [dbo].[Healthcare_Date]
GROUP By Medical_Condition,  Date_of_Admission, Discharge_Date

SELECT
    Medical_Condition, [name] as Patient_Name,
    sum(Datediff(Day, Date_of_Admission, Discharge_Date)) As Total_Days_Spent
From [dbo].[Healthcare_Date]
Group By Medical_Condition, [name]

-- Finding out most preferred Hospital
SELECT Top 1 
    Hospital, 
    COUNT(*) As Patient_Count
FROM [dbo].[Healthcare_Date]
GROUP By Hospital
ORDER By Patient_Count DESC

-- Finding maximum age of patient admitted Healthcare
SELECT MAX(Age) As Maximum_Age
FROM [dbo].[Healthcare_Date]

-- Finding Hospitals which were successful in discharging patients after having test results as "Normal" 
-- with count of days taken to get results to Normal
SELECT 
    Hospital, 
    COUNT(*) AS Normal_Discharge_Count,
    AVG(DATEDIFF(DAY, Date_of_Admission, Discharge_Date)) As Average_Days_to_Normal
FROM [dbo].[Healthcare_Date]
WHERE Test_Results = 'Normal'
GROUP By Hospital 
--Correction
SELECT 
    Hospital, 
    COUNT(*) AS Normal_Discharge_Count,
    DATEDIFF(DAY, Date_of_Admission, Discharge_Date) As Number_of_Days
FROM [dbo].[Healthcare_Date]
WHERE Test_Results = 'Normal'
GROUP By Hospital, Date_of_Admission, Discharge_Date

-- Finding Count of Medical Condition of patients and listing it by maximum no of patients
SELECT 
    Medical_Condition, 
    COUNT(*) As Patient_Count
FROM [dbo].[Healthcare_Date]
GROUP By Medical_Condition
ORDER By Patient_Count DESC

-- Finding Billing Amount of patients admitted and number of days spent in respective hospital
SELECT 
    Hospital, 
    SUM(Billing_Amount) AS Total_Billing,
    SUM(DATEDIFF(DAY, Date_of_Admission, Discharge_Date)) AS Total_Days_Spent
FROM [dbo].[Healthcare_Date]
GROUP BY Hospital

-- Finding Average age of hospitalized patients Healthcare
SELECT AVG(Age) As Average_Age
FROM [dbo].[Healthcare_Date]

-- Find the average, minimum and maximum billing amount for each insurance provider
SELECT 
    Insurance_Provider, 
    AVG(Billing_Amount) As Avg_Billing,
    MIN(Billing_Amount) As Min_Billing,
    MAX(Billing_Amount) As Max_Billing
FROM [dbo].[Healthcare_Date]
GROUP BY Insurance_Provider

SELECT *
From [dbo].[Healthcare_Date]
Where Billing_Amount < 0

-- 13. Find how many patients are Universal Blood Donor (O-) and Universal Blood receiver (AB+)
SELECT 
    SUM(  CASE WHEN Blood_Type = 'O-' THEN 1  ELSE 0   END ) As [Universal_Blood_Donors_0-],
    SUM( CASE  WHEN Blood_Type = 'AB+' THEN 1 ELSE 0  END ) As [Universal_Blood_Receivers_AB+]
From [dbo].[Healthcare_Date]

--  Create a new column that categorizes patients as high, medium, or low risk based on their medical condition
-- (Logic: Cancer/Diabetes as High, Hypertension/Asthma as Medium, others Low - Adjust as needed)
SELECT *,
    CASE 
    WHEN Medical_Condition In ('Cancer', 'Diabetes') THEN 'High Risk'
    WHEN Medical_Condition In ('Hypertension', 'Asthma', 'Obesity') THEN 'Medium Risk'
    ELSE 'Low Risk'
    END AS Risk_Category
FROM [dbo].[Healthcare_Date]

-- Counting Total Record in Healthcare data
SELECT COUNT(*) AS Total_Records
FROM [dbo].[Healthcare_Date]


-- Calculating Patients Hospitalized Age-wise from Maximum to Minimum
SELECT 
    Age, 
    COUNT(*) AS Patient_Count
FROM [dbo].[Healthcare_Date]
GROUP BY Age
ORDER BY Age DESC


-- Calculating Maximum Count of patients on basis of total patients hospitalized with respect to age
SELECT TOP 1 
    Age, 
    COUNT(*) AS Maximum_Patient_Count
FROM [dbo].[Healthcare_Date]
GROUP BY Age
ORDER BY Maximum_Patient_Count DESC


-- Calculate number of blood types of patients which lies between age 20 to 45
SELECT 
    Blood_Type, 
    COUNT(*) AS Count_Between_20_and_45
FROM [dbo].[Healthcare_Date]
WHERE Age BETWEEN 20 AND 45
GROUP BY Blood_Type


-- Finding Rank & Maximum number of medicines recommended to patients based on Medical Condition
WITH Medicine_Counts AS (
    SELECT 
        Medical_Condition, 
        Medication, 
        COUNT(*) AS Med_Usage_Count
    FROM [dbo].[Healthcare_Date]
    GROUP BY Medical_Condition, Medication
)
SELECT 
    Medical_Condition, 
    Medication, 
    Med_Usage_Count,
    RANK() OVER (PARTITION BY Medical_Condition ORDER BY Med_Usage_Count DESC) AS Med_Rank
FROM Medicine_Counts