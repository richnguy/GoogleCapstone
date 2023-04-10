-- Import Data *
-- For each CSV file:
-- Task > Import Data.. > Flat Source File > Browse > CSV file > Advance > start_station_name + end_station_name > OutputColumnWidth : 255 > Next > Destination: SQL Server > Next > Finish



-- Combine Data Tables

SELECT * INTO bikedata_v01

FROM

(
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-03]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-04]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-05]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-06]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-07]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-08]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-09]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-10]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-11]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2022-12]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2023-01]
UNION ALL
SELECT * FROM [Capstone_Cyclistic].[dbo].[2023-02]
) AS T1

-- Newly Created Table: bikedata_v01

SELECT 
	* 
FROM 
	bikedata_v01

-- Query Returned 5,829,084 Recorded Trips

-- Remove Unwanted Columns

ALTER TABLE 
	bikedata_v01
DROP COLUMN
	start_station_name,
	start_station_id,
	end_station_name,
	end_station_id,
	start_lat,
	start_lng,
	end_lat,
	end_lng

-- Check For NULL values

SELECT 
	*
FROM 
	bikedata_v01
WHERE
	ride_id IS NULL OR
	rideable_type IS NULL OR
	started_at IS NULL OR
	ended_at IS NULL OR
	ride_length IS NULL OR
	ride_date IS NULL OR
	ride_month IS NULL OR
	ride_year IS NULL OR
	start_time IS NULL OR
	end_time IS NULL OR
	day_of_week IS NULL OR
	member_casual IS NULL

-- No NULL values

-- Check For Trips If ride_length < 1 Minute 

SELECT
	ride_length
FROM
	bikedata_v01
WHERE
	ride_length < '0:01:00'

-- Query Returned 35,202 recorded trips

-- Remove Recorded Trips with < 1 ride_length

DELETE FROM 
	bikedata_v01
WHERE
	ride_length < '0:01:00'

-- Check Updated Table

SELECT 
	* 
FROM 
	bikedata_v01

-- Query Returned 5,793,882 Recorded Trips

-- Update day_of_week values with Day (E.g. 1 = Monday) using CASE WHEN

UPDATE 
	bikedata_v01
SET
	day_of_week =
		CASE
			WHEN day_of_week = '1' THEN 'Monday'
			WHEN day_of_week = '2' THEN 'Tuesday'
			WHEN day_of_week = '3' THEN 'Wednesday'
			WHEN day_of_week = '4' THEN 'Thursday'
			WHEN day_of_week = '5' THEN 'Friday'
			WHEN day_of_week = '6' THEN 'Saturday'
			WHEN day_of_week = '7' THEN 'Sunday'
			END
WHERE
	day_of_week IN ('1', '2', '3', '4', '5', '6', '7')

--Display member_casual: casual vs members

SELECT
	count(CASE WHEN member_casual = 'member' THEN 1 else null end) as annual,
	count(CASE WHEN member_casual = 'casual' THEN 1 else null end) as casual
FROM
	bikedata_v01

	--3,443,558 annuals, 2,350,324 casuals

--Display ride_month: casual vs members
SELECT
	count(CASE WHEN ride_month = '3' THEN 1 else null end) as Mar_2022,
	count(CASE WHEN ride_month = '4' THEN 1 else null end) as Apr_2022,
	count(CASE WHEN ride_month = '5' THEN 1 else null end) as May_2022,
	count(CASE WHEN ride_month = '6' THEN 1 else null end) as Jun_2022,
	count(CASE WHEN ride_month = '7' THEN 1 else null end) as Jul_2022,
	count(CASE WHEN ride_month = '8' THEN 1 else null end) as Aug_2022,
	count(CASE WHEN ride_month = '9' THEN 1 else null end) as Sept_2022,
	count(CASE WHEN ride_month = '10' THEN 1 else null end) as Oct_2022,
	count(CASE WHEN ride_month = '11' THEN 1 else null end) as Nov_2022,
	count(CASE WHEN ride_month = '12' THEN 1 else null end) as Dec_2022,
	count(CASE WHEN ride_month = '1' THEN 1 else null end) as Jan_2023,
	count(CASE WHEN ride_month = '2' THEN 1 else null end) as Feb_2023
FROM
	bikedata_v01
WHERE
	member_casual = 'member'
UNION
SELECT
	count(CASE WHEN ride_month = '3' THEN 1 else null end) as Mar_2022,
	count(CASE WHEN ride_month = '4' THEN 1 else null end) as Apr_2022,
	count(CASE WHEN ride_month = '5' THEN 1 else null end) as May_2022,
	count(CASE WHEN ride_month = '6' THEN 1 else null end) as Jun_2022,
	count(CASE WHEN ride_month = '7' THEN 1 else null end) as Jul_2022,
	count(CASE WHEN ride_month = '8' THEN 1 else null end) as Aug_2022,
	count(CASE WHEN ride_month = '9' THEN 1 else null end) as Sept_2022,
	count(CASE WHEN ride_month = '10' THEN 1 else null end) as Oct_2022,
	count(CASE WHEN ride_month = '11' THEN 1 else null end) as Nov_2022,
	count(CASE WHEN ride_month = '12' THEN 1 else null end) as Dec_2022,
	count(CASE WHEN ride_month = '1' THEN 1 else null end) as Jan_2023,		
	count(CASE WHEN ride_month = '2' THEN 1 else null end) as Feb_2023
FROM
	bikedata_v01
WHERE
	member_casual = 'casual'

----- There appears to be incorrect format of ride_year and ride_month data columns. Colummns are swapped for some unknown reasons ( July, Aug, Oct, Nov, Dec, Jan, Feb)
----- Fix ride_month columns

UPDATE bikedata_v01
SET
	ride_month = '7'
WHERE
	ride_date LIKE '%2022-07%'

UPDATE bikedata_v01
SET
	ride_month = '8'
WHERE
	ride_date LIKE '%2022-08%'

UPDATE bikedata_v01
SET
	ride_month = '9'
WHERE
	ride_date LIKE '%2022-09%'

UPDATE bikedata_v01
SET
	ride_month = '10'
WHERE
	ride_date LIKE '%2022-10%'

UPDATE bikedata_v01
SET
	ride_month = '11'
WHERE
	ride_date LIKE '%2022-11%'

UPDATE bikedata_v01
SET
	ride_month = '12'
WHERE
	ride_date LIKE '%2022-12%'

UPDATE bikedata_v01
SET
	ride_month = '1'
WHERE
	ride_date LIKE '%2023-01%'

UPDATE bikedata_v01
SET
	ride_month = '2'
WHERE
	ride_date LIKE '%2023-02%'

-- Fix ride_year

UPDATE bikedata_v01
SET
	ride_year = '2022'
WHERE
	ride_date LIKE '%2022%'

UPDATE bikedata_v01
SET
	ride_year = '2023'
WHERE
	ride_date LIKE '%2023%'

--Check updated table

SELECT 
	top 100 *
FROM
	bikedata_v01

--Display day_of_week
SELECT
	member_casual,
	count(CASE WHEN day_of_week = 'Monday' THEN 1 ELSE null end) as Monday,
	count(CASE WHEN day_of_week = 'Tuesday' THEN 1 ELSE null end) as Tuesday,
	count(CASE WHEN day_of_week = 'Wednesday' THEN 1 ELSE null end) as Wednesday,
	count(CASE WHEN day_of_week = 'Thursday' THEN 1 ELSE null end) as Thursday,
	count(CASE WHEN day_of_week = 'Friday' THEN 1 ELSE null end) as Friday,
	count(CASE WHEN day_of_week = 'Saturday' THEN 1 ELSE null end) as Saturday,
	count(CASE WHEN day_of_week = 'Sunday' THEN 1 ELSE null end) as Sunday
FROM
	bikedata_v01
GROUP BY
	member_casual


UNION
	SELECT
	count(CASE WHEN day_of_week = 'Monday' THEN 1 ELSE null end) as Monday,
	count(CASE WHEN day_of_week = 'Tuesday' THEN 1 ELSE null end) as Tuesday,
	count(CASE WHEN day_of_week = 'Wednesday' THEN 1 ELSE null end) as Wednesday,
	count(CASE WHEN day_of_week = 'Thursday' THEN 1 ELSE null end) as Thursday,
	count(CASE WHEN day_of_week = 'Friday' THEN 1 ELSE null end) as Friday,
	count(CASE WHEN day_of_week = 'Saturday' THEN 1 ELSE null end) as Saturday,
	count(CASE WHEN day_of_week = 'Sunday' THEN 1 ELSE null end) as Sunday
FROM
	bikedata_v01
WHERE
	 member_casual = 'casual'

-- Final Table
SELECT
	*
FROM
	ridedata_v01