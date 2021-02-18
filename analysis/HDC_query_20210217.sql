/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	HomeDeliveryChargeGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	HomeDeliveryCharge,
	case 
		when cast(HomeDeliveryCharge as numeric) is NULL then NULL
		when cast(HomeDeliveryCharge as numeric) <0 then '<£0'
		when cast(HomeDeliveryCharge as numeric) = 0 then '£0'
		when cast(HomeDeliveryCharge as numeric) > 0 and cast(HomeDeliveryCharge as numeric) <=100 then 'Up to £100'
		when cast(HomeDeliveryCharge as numeric) > 100 then '>£100'
		else 'Other'
	end as HomeDeliveryChargeGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	HomeDeliveryCharge,
	FinancialYear) as a

group by
	HomeDeliveryChargeGroup,
	FinancialYear

order by
	NumRecords desc

