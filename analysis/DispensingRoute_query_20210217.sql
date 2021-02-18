/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	DispensingRouteGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	DispensingRoute,
	case
		when DispensingRoute is NULL then NULL
		when DispensingRoute = 'NULL' then NULL
		when DispensingRoute = '1' then '1'
		when DispensingRoute = '2' then '2'
		when DispensingRoute = '3' then '3'
		when DispensingRoute = '4' then '4'
		when DispensingRoute = '5' then '5'
		when DispensingRoute = '6' then '6'
		else 'Other'
	end as DispensingRouteGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	DispensingRoute,
	FinancialYear) as a

group by
	DispensingRouteGroup,
	FinancialYear

order by
	NumRecords desc

