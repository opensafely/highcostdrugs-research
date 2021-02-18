/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	DerivedSNOMEDFromNameGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	DerivedSNOMEDFromName,
	case 
		when DerivedSNOMEDFromName is NULL then NULL
		when DerivedSNOMEDFromName = 'NULL' then NULL
		else 'Not NULL'
	end as DerivedSNOMEDFromNameGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	DerivedSNOMEDFromName,
	FinancialYear) as a

group by
	DerivedSNOMEDFromNameGroup,
	FinancialYear

order by
	NumRecords desc

