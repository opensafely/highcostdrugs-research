use OpenCorona

 select
	FinancialYear,
	cast(FinancialMonth as int) as FinancialMonth,
	count(Patient_ID) as Num_Issues

from OpenCorona.dbo.HighCostDrugs

group by
	FinancialYear,
	FinancialMonth

order by
	FinancialYear,
	FinancialMonth