/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	TotalCostGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	TotalCost,
	case 
		when cast(TotalCost as numeric) is NULL then NULL
		when cast(TotalCost as numeric) <0 then '<£0'
		when cast(TotalCost as numeric) = 0 then '£0'
		when cast(TotalCost as numeric) > 0 and cast(TotalCost as numeric) <=1000 then 'Up to £1000'
		when cast(TotalCost as numeric) > 1000 then '>£1000'
		else 'Other'
	end as TotalCostGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	TotalCost,
	FinancialYear) as a

group by
	TotalCostGroup,
	FinancialYear

order by
	NumRecords desc

