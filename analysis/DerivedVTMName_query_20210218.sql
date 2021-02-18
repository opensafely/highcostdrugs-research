/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	DerivedVTMNameGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	DerivedVTMName,
	case 
		when DerivedVTMName is NULL then NULL
		when DerivedVTMName = 'NULL' then NULL
		else 'Not NULL'
	end as DerivedVTMNameGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	DerivedVTMName,
	FinancialYear) as a

group by
	DerivedVTMNameGroup,
	FinancialYear

order by
	NumRecords desc

