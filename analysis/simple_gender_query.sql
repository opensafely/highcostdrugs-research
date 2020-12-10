use OpenCorona

 select
	PersonGender,
	case
		when count(Patient_ID) <= 5 then NULL
		else count(Patient_ID)
	end as Num_Issues

from OpenCorona.dbo.HighCostDrugs

group by
	PersonGender

order by
	PersonGender