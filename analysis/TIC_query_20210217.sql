/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	TherapeuticIndicationCode,
	FinancialYear,
	case
		when NumUniquePatients <=5 then NULL
		else NumUniquePatients
	end as NumUniquePatients,
	case
		when NumRecords <=5 then NULL
		else NumRecords
	end as NumRecords

from
(select
	TherapeuticIndicationCode,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	TherapeuticIndicationCode,
	FinancialYear) as a

order by
	TherapeuticIndicationCode,
	FinancialYear


