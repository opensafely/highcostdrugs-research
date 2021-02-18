/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords,
	PersonGender

from
	OpenCorona.dbo.HighCostDrugs
			
where FinancialYear = '201920'

group by
	PersonGender

order by
	PersonGender

