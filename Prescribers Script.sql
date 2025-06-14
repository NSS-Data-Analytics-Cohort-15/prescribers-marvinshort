-- 1a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

-- SELECT npi, SUM(total_claim_count) as sum_claim_count
-- FROM prescription
-- LEFT JOIN prescriber
-- USING (npi)
-- GROUP BY npi
-- ORDER BY sum_claim_count DESC
-- LIMIT 1

--ANSWER npi = 1881634483, sum_claim_count = 99707


--1b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

-- SELECT npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, SUM(total_claim_count) as sum_claim_count
-- FROM prescription
-- LEFT JOIN prescriber
-- USING (npi)
-- GROUP BY npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description
-- ORDER BY sum_claim_count DESC
-- LIMIT 1

--ANSWER npi = 1881634483, Bruce Pendley, Family Practice, sum_claim_count = 99707


--2a. Which specialty had the most total number of claims (totaled over all drugs)?

-- SELECT specialty_description, SUM(total_claim_count) as sum_claim_count
-- FROM prescription
-- LEFT JOIN prescriber
-- USING (npi)
-- GROUP BY specialty_description
-- ORDER BY sum_claim_count DESC
-- LIMIT 1

--ANSWER  Family Practice has the most number of claims across all drugs.


-- 2b. Which specialty had the most total number of claims for opioids?

-- SELECT specialty_description, SUM(total_claim_count) as sum_claim_count
-- FROM prescription
-- LEFT JOIN prescriber
-- USING (npi)
-- LEFT JOIN drug
-- USING (drug_name)
-- WHERE opioid_drug_flag = 'Y'
-- GROUP BY specialty_description
-- ORDER BY sum_claim_count DESC
-- LIMIT 1


--ANSWER The Nurse Practicioner specialty had the most number of claims for opioids.


--3a. Which drug (generic_name) had the highest total drug cost?

-- SELECT generic_name, SUM(total_drug_cost) as sum_of_drug_cost
-- FROM prescription
-- LEFT JOIN drug
-- USING (drug_name)
-- GROUP BY generic_name
-- ORDER BY sum_of_drug_cost DESC
-- LIMIT 1

--ANSWER Insulin Glargine has the highest total drug cost.


--3b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

-- SELECT generic_name, ROUND(SUM(total_drug_cost)/sum(total_day_supply),2) as drug_cost_perday
-- FROM prescription
-- LEFT JOIN drug
-- USING (drug_name)
-- GROUP BY generic_name
-- ORDER BY drug_cost_perday DESC
-- LIMIT 1;

--ANSWER LEDIPASVIR/SOFOSBUVIR has the highest total cost per day, 88270.87



--4a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

-- SELECT drug_name,
-- CASE
-- 	WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 	ELSE 'neither'
-- END drug_type
-- FROM drug


--4b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics.

SELECT SUM(total_drug_cost) as sum_of_drug_cost,
CASE 
	WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither'
END drug_type
FROM drug
LEFT JOIN prescription
USING (drug_name)
GROUP BY drug_type

--ANSWER More money was spent on Opioids.


--5a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

SELECT DISTINCT(cbsa)
FROM cbsa 
WHERE cbsaname LIKE '%, TN%'


SELECT DISTINCT(cbsa)
FROM cbsa
INNER JOIN fips_county
USING(fipscounty)
WHERE state = 'TN'


--ANSWER  There are 10 CBSA's in Tennessee.


--5b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

-- SELECT cbsaname, SUM(population) AS total_population
-- FROM cbsa
-- LEFT JOIN population
-- USING (fipscounty)
-- WHERE population IS NOT NULL
-- GROUP BY cbsaname
-- ORDER BY total_population DESC
-- --LIMIT 1

--ANSWER The CBSA with the largest population is "Nashville-Davidson--Murfreesboro--Franklin, TN" with a populatiuon of 1830410.

-- SELECT cbsaname, SUM(population) AS total_population
-- FROM cbsa
-- LEFT JOIN population
-- USING (fipscounty)
-- WHERE population IS NOT NULL
-- GROUP BY cbsaname
-- ORDER BY total_population ASC
-- LIMIT 1

--ANSWER The CBSA with the smallest population is "Morristown, TN" with a population of 116352.


--5c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- SELECT fips_county.county, population.population
-- FROM population
-- LEFT JOIN fips_county
-- USING (fipscounty)
-- LEFT JOIN cbsa
-- USING (fipscounty)
-- WHERE CBSA IS NULL
-- ORDER BY population DESC

ANSWER The largest county not included in a CBSa is SEVIER with a population of 95523.


--6a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

SELECT npi, drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >=3000
ORDER BY total_claim_count DESC;


--6b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.



