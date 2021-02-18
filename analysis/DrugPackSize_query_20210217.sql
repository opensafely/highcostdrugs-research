/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	DrugPackSizeGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	DrugPackSize,
	case
		when DrugPackSize is NULL then NULL
		when DrugPackSize = 'NULL' then NULL
		else 'Not NULL'
	end as DrugPackSizeGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	DrugPackSize,
	FinancialYear) as a

group by
	DrugPackSizeGroup,
	FinancialYear

order by
	NumRecords desc

