/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords,
	sum(case when Patient_ID is NULL then 1 else 0 end) as NumNoPatientID,
	FinancialYear,
	FinancialMonth

from
	OpenCorona.dbo.HighCostDrugs

group by
	FinancialYear,
	FinancialMonth

