/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	DrugVolumeGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	DrugVolume,
	case
		when DrugVolume is NULL then NULL
		when DrugVolume = 'NULL' then NULL
		else 'Not NULL'
	end as DrugVolumeGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	DrugVolume,
	FinancialYear) as a

group by
	DrugVolumeGroup,
	FinancialYear

order by
	NumRecords desc

