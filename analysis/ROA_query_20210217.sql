/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	RouteOfAdministration,
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
	RouteOfAdministration,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	RouteOfAdministration,
	FinancialYear) as a

order by
	NumRecords desc

