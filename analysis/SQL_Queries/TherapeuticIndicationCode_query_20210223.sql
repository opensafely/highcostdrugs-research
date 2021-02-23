/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	FinancialYear,
	count(*) as Num_Records,
	sum(case
			when TherapeuticIndicationCode is NULL then 1
			when TherapeuticIndicationCode  = 'NULL' then 1
			else 0
		end) as NULL_Records,
	sum(case	
			when TherapeuticIndicationCode not like '%[^0-9]%' then 1
			else 0
		end) as Numeric_Records,
	count(distinct(TherapeuticIndicationCode)) as Unique_Values

from
	OpenCorona.dbo.HighCostDrugs

where
	FinancialYear <> '202021'
			
group by
	FinancialYear

