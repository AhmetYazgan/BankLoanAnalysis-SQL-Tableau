USE BankLoanDB

SELECT * FROM financial_loan

-- A. BANK LOAN REPORT | SUMMARY

--KPI'S REQURIEMENTS

--Total Loan Application
SELECT COUNT(id) Total_Application FROM financial_loan

--MTD(month-to-day) Total Loan Application
SELECT COUNT(id) MTD_Total_Application FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--PMTD(previous-month-to-day) Total Loan Application
SELECT COUNT(id) PMTD_Total_Application FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

-- For calculate to Month-to-Month(MoM) rate use this formula: (MTD-PMTD)/PMTD 

------------------------------------------------------------------------------------------------

--Total Funded Amount
SELECT SUM(loan_amount) Total_Amount FROM financial_loan

--MTD(month-to-day) Total Funded Amount
SELECT SUM(loan_amount) MTD_Total_Amount FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--PMTD(previous-month-to-day) Total Funded Amount
SELECT SUM(loan_amount) PMTD_Total_Amount FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

------------------------------------------------------------------------------------------------

--Total Amount Recieved
SELECT SUM(total_payment) Total_Recieved FROM financial_loan

--MTD(month-to-day) Total Amount Recieved
SELECT SUM(total_payment) MTD_Total_Recieved FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--PMTD(previous-month-to-day) Total Amount Recieved
SELECT SUM(total_payment) PMTD_Total_Recieved FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

------------------------------------------------------------------------------------------------

--Average Interest Rate
SELECT AVG(int_rate) Avg_Rate FROM financial_loan

--MTD(month-to-day) Average Interest Rate
SELECT AVG(int_rate) MTD_Avg_Rate FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--PMTD(previous-month-to-day) Average Interest Rate
SELECT AVG(int_rate) PMTD_Avg_Rate FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

------------------------------------------------------------------------------------------------

--Average Debt-to-Income Ratio (DTI)
SELECT ROUND(AVG(dti),4) * 100 Avg_DTI FROM financial_loan

--MTD(month-to-day)Average Debt-to-Income Ratio (DTI)
SELECT AVG(dti) * 100 MTD_Avg_DTI FROM financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--PMTD(previous-month-to-day) Average Debt-to-Income Ratio (DTI)
SELECT AVG(dti) * 100 PMTD_Avg_DTI FROM financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

------------------------------------------------------------------------------------------------ 

--Good Loan & Bad Loan KPI's
SELECT * FROM financial_loan

SELECT DISTINCT loan_status FROM financial_loan
--Fully Paid and Current shows us good loan and Charged Off mean's bad loan

------------------------------------------------------------------------------------------------ 

--GOOD LOAN ISSUES
--Good Loan(GL) Application's Percentage
SELECT 
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0)
	/ 
	COUNT(id) AS GL_Percentage
FROM financial_loan

--Good Loan(GL) Aplication
SELECT COUNT(id) AS GL_Application FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--Good Loan(GL) Founded Amount
SELECT SUM(loan_amount) AS GL_Founded_Amount FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--Good Loan(GL) Total Recieved Amount
SELECT SUM(total_payment) AS GL_Recieved_Amount FROM financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

------------------------------------------------------------------------------------------------ 

--BAD LOAN ISSUES
--Bad Loan(BL) Application's Percentage
SELECT 
	(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0)
	/ 
	COUNT(id) AS BL_Percentage
FROM financial_loan

--Bad Loan(BL) Aplication
SELECT COUNT(id) AS BL_Application FROM financial_loan
WHERE loan_status = 'Charged Off'

--Bad Loan(BL) Founded Amount
SELECT SUM(loan_amount) AS BL_Founded_Amount FROM financial_loan
WHERE loan_status = 'Charged Off'

--Bad Loan(BL) Total Recieved Amount
SELECT SUM(total_payment) AS BL_Recieved_Amount FROM financial_loan
WHERE loan_status = 'Charged Off'

------------------------------------------------------------------------------------------------ 

--LOAN STATUS

SELECT
	loan_status,
	COUNT(id) loan_count,
	SUM(total_payment) Recieved_Amount,
	SUM(loan_amount) Founded_Amount,
	AVG(int_rate)*100 interest_rate,
	AVG(dti)*100 dti_rate,
	ROUND(AVG(annual_income),2) avg_annual_income
FROM financial_loan
GROUP BY loan_status

------------------------------------------------------------------------------------------------ 

SELECT
	loan_status,
	SUM(total_payment) MTD_Recieved_Amount,
	SUM(loan_amount) MTD_Founded_Amount
FROM financial_loan
WHERE MONTH(issue_date) = 11
GROUP BY loan_status

------------------------------------------------------------------------------------------------ 
-- B. BANK LOAN REPORT | OVERVIEW

--Monthly Trends by Issues Date
SELECT
	MONTH(issue_date) Month_Number,
	DATENAME(MONTH,issue_date) Months,
	COUNT(id) Loan_Application,
	SUM(loan_amount) Total_Founded_Amount,
	SUM(total_payment) Total_Recieved_Amount
FROM financial_loan
GROUP BY MONTH(issue_date), DATENAME(MONTH,issue_date)
ORDER BY MONTH(issue_date)

--Regional Analysis by State
SELECT
	address_state,
	COUNT(id) Loan_Application,
	SUM(loan_amount) Total_Founded_Amount,
	SUM(total_payment) Total_Recieved_Amount
FROM financial_loan
GROUP BY address_state
ORDER BY SUM(loan_amount) DESC

--Loan Term Analysis
SELECT
	term,
	COUNT(id) Loan_Application,
	SUM(loan_amount) Total_Founded_Amount,
	SUM(total_payment) Total_Recieved_Amount
FROM financial_loan
GROUP BY term
ORDER BY term

--Employee Length Analysis
SELECT
	emp_length,
	COUNT(id) Loan_Application,
	SUM(loan_amount) Total_Founded_Amount,
	SUM(total_payment) Total_Recieved_Amount
FROM financial_loan
GROUP BY emp_length
ORDER BY COUNT(id) DESC

--Loan Purpose Breakdown
SELECT
	purpose,
	COUNT(id) Loan_Application,
	SUM(loan_amount) Total_Founded_Amount,
	SUM(total_payment) Total_Recieved_Amount
FROM financial_loan
GROUP BY purpose
ORDER BY COUNT(id) DESC

--Home Ownership Analysis
SELECT
	home_ownership,
	COUNT(id) Loan_Application,
	SUM(loan_amount) Total_Founded_Amount,
	SUM(total_payment) Total_Recieved_Amount
FROM financial_loan
GROUP BY home_ownership
ORDER BY COUNT(id) DESC



--Note: We have applied multiple Filters on all the dashboards. You can check the results for the filters as well by modifying the query and comparing the results.
--For e.g
--See the results when we hit the Grade A in the filters for dashboards.

SELECT 
	purpose, 
	COUNT(id) Loan_Applications,
	SUM(loan_amount) Total_Funded_Amount,
	SUM(total_payment) Total_Amount_Received
FROM financial_loan
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose
