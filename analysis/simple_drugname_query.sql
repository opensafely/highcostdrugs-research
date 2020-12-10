use OpenCorona

 select
	DrugName,
	HighCostTariffExcludedDrugCode,
	DerivedSNOMEDFromName,
	DerivedVTM,
	DerivedVTMName,
	case
		when count(Patient_ID) <= 5  then NULL
		else count(Patient_ID) 
	end as Num_Issues
	
from OpenCorona.dbo.HighCostDrugs

group by
	DrugName,
	HighCostTariffExcludedDrugCode,
	DerivedSNOMEDFromName,
	DerivedVTM,
	DerivedVTMName 

order by
	Num_Issues DESC