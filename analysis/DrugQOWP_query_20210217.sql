/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	DrugQuanitityOrWeightProportionGroup,
	FinancialYear,
	sum(NumUniquePatients) as NumUniquePatients,
	sum(NumRecords) as NumRecords

from
(select
	DrugQuanitityOrWeightProportion,
	case
		when DrugQuanitityOrWeightProportion is NULL then NULL
		when DrugQuanitityOrWeightProportion = 'NULL' then NULL
		else 'Not NULL'
	end as DrugQuanitityOrWeightProportionGroup,
	FinancialYear,
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords
	
from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	DrugQuanitityOrWeightProportion,
	FinancialYear) as a

group by
	DrugQuanitityOrWeightProportionGroup,
	FinancialYear

order by
	NumRecords desc

