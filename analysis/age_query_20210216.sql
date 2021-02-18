/* Query used to summarise information on number of 
unique patient IDs in high cost drug dataset*/
use OpenCorona

select
	count(distinct(Patient_ID)) as NumUniquePatients,
	count(*) as NumRecords,
	PersonAge_Group

from
	(select
		Patient_ID,
		cast(PersonAge as numeric) as Person_Age,
		case 
			when PersonAge <0 then '< 0'
			when PersonAge = 0 then '0'
			when PersonAge > 0 and PersonAge <= 10 then '1 to 10'
			when PersonAge > 10 and PersonAge <= 20 then '11 to 20'
			when PersonAge > 20 and PersonAge <= 30 then '21 to 30'
			when PersonAge > 30 and PersonAge <= 40 then '31 to 40'
			when PersonAge > 40 and PersonAge <= 50 then '41 to 50'
			when PersonAge > 50 and PersonAge <= 60 then '51 to 60'
			when PersonAge > 60 and PersonAge <= 70 then '61 to 70'
			when PersonAge > 70 and PersonAge <= 80 then '71 to 80'
			when PersonAge > 80 and PersonAge <= 90 then '81 to 90'
			when PersonAge > 90 and PersonAge <= 100 then '91 to 100'
			when PersonAge > 100 and PersonAge <= 110 then '100 to 110'
			when PersonAge > 110 and PersonAge <= 120 then '110 to 120'
			when PersonAge > 120 and PersonAge <= 130 then '120 to 130'
			when PersonAge > 130 then '> 130'
			else NULL
		end as PersonAge_Group

		from
			OpenCorona.dbo.HighCostDrugs
			
		where FinancialYear = '201920') as a

group by
	PersonAge_Group

order by
	PersonAge_Group

