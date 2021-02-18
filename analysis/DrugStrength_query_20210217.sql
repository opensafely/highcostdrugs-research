/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	DrugStrengthGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	case
		when DrugStrength is NULL then NULL
		when DrugStrength = 'NULL' then NULL
		else 'Not NULL'
	end as DrugStrengthGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	DrugStrength,
	FinancialYear) as a

group by
	DrugStrengthGroup,
	FinancialYear

order by
	NumRecords desc

