use OpenCorona

 select
	PersonAge,
	case
		when count(Patient_ID) <= 5 then NULL
		else count(Patient_ID)
	end as Num_Issues

from OpenCorona.dbo.HighCostDrugs

group by
	PersonAge

order by
	PersonAge