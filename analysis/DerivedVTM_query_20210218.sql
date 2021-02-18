/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	DerivedVTMGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	DerivedVTM,
	case 
		when DerivedVTM is NULL then NULL
		when DerivedVTM = 'NULL' then NULL
		else 'Not NULL'
	end as DerivedVTMGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	DerivedVTM,
	FinancialYear) as a

group by
	DerivedVTMGroup,
	FinancialYear

order by
	NumRecords desc

