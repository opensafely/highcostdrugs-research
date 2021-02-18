/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	UnitOfMeasurementGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	UnitOfMeasurement,
	case
		when UnitOfMeasurement is NULL then NULL
		when UnitOfMeasurement = 'NULL' then NULL
		else 'Not NULL'
	end as UnitOfMeasurementGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	UnitOfMeasurement,
	FinancialYear) as a

group by
	UnitOfMeasurementGroup,
	FinancialYear

order by
	NumRecords desc

