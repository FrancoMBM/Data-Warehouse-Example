

--****************************************Creating fake data in order to update into SCDs*************************************************************
VACUUM; 

create schema maintenance;

select * from stage.crime_stage where "OFFENSE_CODE_GROUP" is not null order by "OCCURRED_ON_DATE"  desc limit 50;
select * from stage.weather_stage order by datetime desc limit 5; 
select * from stage.moon_stage order by datetime desc limit 5;


create table maintenance.crime_stage_load as select * from (select * from stage.crime_stage where "OFFENSE_CODE_GROUP" is not null order by "OCCURRED_ON_DATE"  desc limit 50) a;
drop table maintenance.crime_stage_load;

create table maintenance.weather_stage_load as select * from (select * from stage.weather_stage order by datetime desc limit 50) b;
create table maintenance.moon_stage_load as select * from (select * from stage.moon_stage order by datetime desc limit 50) c;




drop table maintenance.weather_stage_load;
drop table maintenance.moon_stage_load;


-- For crime, there will be new offense codes -- weill be adding for 2018 warehouse contains data from 2015-2017

--- Updating records by setting up to 2018 and some additional changes to trigger SCDs 

select * from maintenance.crime_stage_load 

-- Updating Some Dates


update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2017-11-30 00:00:00' where "INCIDENT_NUMBER" = 'I192082751';  
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-03 00:00:00' where "INCIDENT_NUMBER" = 'I192082577';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-04 00:00:00' where "INCIDENT_NUMBER" = 'I192079582';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-05 00:00:00' where "INCIDENT_NUMBER" = 'I192078648';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-06 00:00:00' where "INCIDENT_NUMBER" = 'I192078645' and "OFFENSE_CODE" = 3301;
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-07 05:00:00' where "INCIDENT_NUMBER" = 'I192078645' and "OFFENSE_CODE" = 1402;

update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-08 00:00:00' where "INCIDENT_NUMBER" = 'I192078642';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-09 00:00:00' where "INCIDENT_NUMBER" = 'I192078637';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-10 00:00:00' where "INCIDENT_NUMBER" = 'I192078638' and "OFFENSE_CODE" = 1402;
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-11 15:00:00' where "INCIDENT_NUMBER" = 'I192078638' and "OFFENSE_CODE" = 423;

update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-12 00:00:00' where "INCIDENT_NUMBER" = 'I192078636';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-13 00:00:00' where "INCIDENT_NUMBER" = 'I192078647';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-14 00:00:00' where "INCIDENT_NUMBER" = 'I192078628';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-15 00:00:00' where "INCIDENT_NUMBER" = 'I192078621';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-16 00:00:00' where "INCIDENT_NUMBER" = 'I192078622';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-17 00:00:00' where "INCIDENT_NUMBER" = 'I192078612';

update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-18 01:00:00' where "INCIDENT_NUMBER" = 'I192078613' and "OFFENSE_CODE" =3114;
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-19 00:00:00' where "INCIDENT_NUMBER" = 'I192078613'and "OFFENSE_CODE" = 802;

update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-20 00:00:00' where "INCIDENT_NUMBER" = 'I192078606';
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-21 00:00:00' where "INCIDENT_NUMBER" = 'I192078610' and "OFFENSE_CODE" = 1501;

update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-22 12:00:00' where "INCIDENT_NUMBER" = 'I192078602' and "OFFENSE_CODE" = 1501;
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-23 13:00:00' where "INCIDENT_NUMBER" = 'I192078602' and "OFFENSE_CODE" = 3125;
update maintenance.crime_stage_load set "OCCURRED_ON_DATE" = '2018-01-24 14:00:00' where "INCIDENT_NUMBER" = 'I192078602' and "OFFENSE_CODE" = 1504;


--- Update for SCD 2

update maintenance.crime_stage_load set "OFFENSE_DESCRIPTION" = 'DIW - DRUGS' where "OFFENSE_CODE" = 727; 
update maintenance.crime_stage_load set "OFFENSE_DESCRIPTION" = 'Assault' where  "OFFENSE_CODE" = 802; 
update maintenance.crime_stage_load set "OFFENSE_DESCRIPTION" = 'Concealed Weapon' where "OFFENSE_CODE" = 1501; 
update maintenance.crime_stage_load set "OFFENSE_DESCRIPTION" = 'Stray Bullet' where  "OFFENSE_CODE" = 2662; 
update maintenance.crime_stage_load set "OFFENSE_DESCRIPTION" = 'Refused Medical Assistance' where  "OFFENSE_CODE" = 3006; 
update maintenance.crime_stage_load set "OFFENSE_DESCRIPTION" = 'Robbery - Alley' where "OFFENSE_CODE" = 301; 
update maintenance.crime_stage_load set "OFFENSE_DESCRIPTION" = 'Drug Distribution' where "OFFENSE_CODE" = 1843; 




---- Update for SCD 3:


update maintenance.crime_stage_load set  "DISTRICT" = 'B103' where "DISTRICT" = 'B3'; -- 11 rows updated
update maintenance.crime_stage_load set  "DISTRICT" = 'C106' where "DISTRICT" = 'C6'; -- 3 rows updated


--- Update for Weather SCD 1

select * from maintenance.weather_stage_load; 

update maintenance.weather_stage_load set datetime = '2018-01-01 06:02:00', humidity = 25 where temperature = 283.94; -- windspeed sensor was brokken so adusted data accordinly, lowered humidity on 11 records
update maintenance.weather_stage_load set datetime = '2017-11-30 00:00:00', humidity = 29 where temperature = 286.02;
update maintenance.weather_stage_load set datetime = '2018-01-03 03:02:00', humidity = 39 where temperature = 282.17;
update maintenance.weather_stage_load set datetime = '2018-01-04 08:02:00', humidity = 40 where temperature = 284.65;
update maintenance.weather_stage_load set datetime = '2018-01-05 12:02:00', humidity = 20 where temperature = 283.99;


update maintenance.weather_stage_load set datetime = '2018-01-06 13:02:00', humidity = 33 where temperature = 283.53;
update maintenance.weather_stage_load set datetime = '2018-01-07 16:02:00', humidity = 32 where temperature = 283.98;
update maintenance.weather_stage_load set datetime = '2018-01-08 14:02:00', humidity = 40 where temperature = 283.66;
update maintenance.weather_stage_load set datetime = '2018-01-09 01:02:00', humidity = 33 where temperature = 283.08;
update maintenance.weather_stage_load set datetime = '2018-01-10 05:02:00', humidity = 35 where temperature = 279.81;
update maintenance.weather_stage_load set datetime = '2018-01-11 11:02:00', humidity = 30 where temperature  = 278.07;


select * from maintenance.weather_stage_load;


select count(*) from warehouse.weather w  where humidity_level = 'Low'; -- 14 records with low humidity on original Dimension

--- SCD 0


update maintenance.moon_stage_load set datetime = '2018-01-01 06:00:00' where date = '12/26/2017'; 
update maintenance.moon_stage_load set datetime = '2017-11-30 00:00:00' where date = '12/18/2017'; 
update maintenance.moon_stage_load set datetime = '2018-01-03 03:00:00' where date = '12/10/2017';
update maintenance.moon_stage_load set datetime = '2018-01-04 08:00:00' where date = '12/03/2017';
update maintenance.moon_stage_load set datetime = '2018-01-05 12:00:00' where date = '11/26/2017';

select * from maintenance.moon_stage_load msl ;

-- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/, April 17 2023

--- Creating changes by updating some records


/* 1. Truncating Staging Tables -- optional since now I will work with speciall tables, 
	this is to risk 'accidents' but should be truncate and load in prod. Here, all will be safely replaced by
	the maitenence's schema tables until is time to deal with dimensions anf fact tables*/


--truncate table stage.crime_stage;
--truncate table stage.weather_stage;
--truncate table stage.moon_stage;


---------------------------------------------------Preload Transformations----------------------------------------------------------

---------------------------------------------------Setting up the crime stage table-------------------------------------------------

create table maintenance.crime_stage_filtered_load as select * from (select "INCIDENT_NUMBER" as incident_number, "OFFENSE_CODE" as offense_code,"OFFENSE_CODE_GROUP" as offense_code_group,
"OFFENSE_DESCRIPTION" as offense_description, "DISTRICT" as district, case when "DISTRICT" = 'A1' then 'Downtown'
		    when "DISTRICT" = 'A15' then 'Charlestown'
		    when "DISTRICT" = 'A7' then 'East Boston'
		    when "DISTRICT" = 'A77' then 'East Boston'
		    when "DISTRICT" = 'A777' then 'East Boston'
		    when "DISTRICT" = 'B2' then 'Roxbury'
		    when "DISTRICT" = 'B103' then 'Mattapan'  -- Adding the modifications on the code
		    when "DISTRICT" = 'C11' then 'Dorchester'
		    when "DISTRICT" = 'C106' then 'South Boston' -- Adding the modifications on the code
		    when "DISTRICT" = 'D14' then 'Brighton'
		    when "DISTRICT" = 'D4' then 'South End'
		    when "DISTRICT" = 'E13' then 'Jamaica Plain'
		    when "DISTRICT" = 'E18' then 'Hyde Park'
		    when "DISTRICT" = 'E5' then 'West Roxbury'
		    when "DISTRICT" = 'External' then 'External'
		    when "DISTRICT" is NULL then NULL
			end neighborhood, cast("OCCURRED_ON_DATE" as timestamp) as datetime,
		    cast(split_part("OCCURRED_ON_DATE", '-', 1)as integer) as year, -- now I am modifiying so it needs to be cast
		    case when cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) >= 1 and cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) <= 3 then 'Q1'
			when cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) >= 4 and cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer)<= 6 then 'Q2' 
			when cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) >= 6 and cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) <= 9 then 'Q3'
			when cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) >= 10 and cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) <= 12 then 'Q4'
			end quarter,
		    cast(split_part("OCCURRED_ON_DATE", '-', 2) as integer) as month, cast(split_part(split_part("OCCURRED_ON_DATE", '-', 3), ' ', 1)as integer) as day,-- now I am modifiying so it needs to be cast
		    "DAY_OF_WEEK" as day_of_week, "HOUR" as hour,
			"STREET" as street, "Lat" as latitude, "Long" as longitude
from  maintenance.crime_stage_load) stg;

select * from maintenance.crime_stage_filtered_load ;


drop table maintenance.crime_stage_filtered_load;

---https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/, April 10 2023
---https://www.postgresqltutorial.com/postgresql-string-functions/postgresql-split_part/, April 10 2023
---https://bpdnews.com/districts, April 11 2023
---https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-change-column-type/, April 16 2023



-------------------------------------- Setting up Weather Stage Table ------------------------------------------------------------

drop table maintenance.weather_stage_filtered_load;

create table maintenance.weather_stage_filtered_load as select * from ( select cast(datetime as timestamp) as datetime, cast(split_part(datetime, '-', 1)as integer) as year, 
			cast(split_part(datetime, '-', 2) as integer) as month,
			cast(split_part(split_part(datetime, '-', 3), ' ', 1) as integer) as day, 
			cast(split_part(split_part(datetime, ':', 1), ' ', 2) as integer) as hour, 
			humidity,pressure, temperature, 
			case 
			when weather_description = 'thunderstorm' then 'stormy weather'
		    when weather_description = 'thunderstorm with heavy rain' then 'stormy weather'
			when weather_description = 'proximity thunderstorm' then 'stormy weather'
			when weather_description = 'thunderstorm with light rain' then 'stormy weather'
			when weather_description = 'heavy intensity drizzle' then 'rain'
			when weather_description = 'heavy intensity rain' then 'heavy rain'
			when weather_description = 'light rain' then 'light rain'
			when weather_description = 'freezing rain' then 'rain'
			when weather_description = 'thunderstorm with rain' then 'stormy weather'
			when weather_description = 'heavy snow' then 'heavy snow'
			when weather_description = 'light snow' then 'light snow'
			when weather_description = 'snow' then 'snow'
			when weather_description = 'pvery heavy rain' then 'heavy rain'
			when weather_description = 'light intensity drizzle' then 'light rain' 
			when weather_description = 'light rain and snow' then 'stormy weather'
			when weather_description = 'mist' then 'mist'
			when weather_description = 'moderate rain' then 'rain'
			when weather_description = 'overcast clouds' then 'cloudy'
			when weather_description = 'scattered clouds' then 'cloudy'
			when weather_description = 'drizzle' then 'light rain'
			when weather_description = 'dust' then 'dusty'
			when weather_description = 'broken clouds' then 'cloudy'
			when weather_description = 'fog' then 'mist'
			when weather_description = 'haze' then 'haze'
			when weather_description = 'squalls' then 'squalls'
			when weather_description = 'sky is clear' then 'clear skies'
			when weather_description = 'few clouds' then 'cloudy'
			end weather_description,
			wind_speed, wind_direction from maintenance.weather_stage_load) a;

select * from maintenance.weather_stage_filtered_load;


---https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-change-column-type/, April 10 2023
---https://www.postgresqltutorial.com/postgresql-string-functions/postgresql-split_part/, April 10 2023
---https://stackoverflow.com/questions/19947817/getting-error-function-to-datetimestamp-without-time-zone-unknown-does-not-ex, April 10 2023

------------------------------------ Setting up Moon Stage Table --------------------------------------------------------------

--- Creating view for moon_stage: - just a view since transformation are minimal
 
 
 create or replace view  maintenance.moon_stage_v_load as select * from 
 ( select datetime, cast(split_part(cast(datetime as varchar), '-', 1)as integer) as year, 
cast(split_part(cast(datetime as varchar), '-', 2)as integer) as month,
cast(split_part( split_part(cast(datetime as varchar), '-', 3), ' ', 1) as integer ) as day,
cast(split_part(split_part(cast(datetime as varchar), ' ',2), ':', 1) as integer) as hour,
phase, phaseid, timezone from maintenance.moon_stage_load) a;

select * from maintenance.moon_stage_v_load;

 -- Source: https://www.timescale.com/blog/how-to-create-lots-of-sample-time-series-data-with-postgresql-generate_series/, April 16 2023
--- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-add-column/, April 16 2023
--- https://stackoverflow.com/a/15766129, April 16 2023
--- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-rename-column/, April 16 2023
--- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-change-column-type/. April 16 2023
--- https://www.postgresql.org/docs/current/dml-insert.html#:~:text=You%20can%20insert%20multiple%20rows,row%2C%20or%20many%20rows)%3A, April 16 2023
--- https://stackoverflow.com/questions/6256610/updating-table-rows-in-postgres-using-subquery, April 16 2023
---https://www.postgresqltutorial.com/postgresql-string-functions/postgresql-split_part/, April 10 2023



create table maintenance.joint_data_full_load as select  * from (select crime_stage_filtered_load.incident_number, crime_stage_filtered_load.offense_code, crime_stage_filtered_load.offense_code_group, crime_stage_filtered_load.offense_description, crime_stage_filtered_load.district, crime_stage_filtered_load.neighborhood,
crime_stage_filtered_load.datetime, crime_stage_filtered_load.year, crime_stage_filtered_load.quarter, crime_stage_filtered_load.month, crime_stage_filtered_load.day, crime_stage_filtered_load.hour, crime_stage_filtered_load.street, crime_stage_filtered_load.latitude,
crime_stage_filtered_load.longitude, weather_stage_filtered_load.humidity, weather_stage_filtered_load.pressure, weather_stage_filtered_load.temperature, weather_stage_filtered_load.weather_description, weather_stage_filtered_load.wind_speed, 
weather_stage_filtered_load.wind_direction, moon_stage_v_load.phase, moon_stage_v_load.phaseid, moon_stage_v_load.timezone,
case
when temperature >= 299 and temperature <= 308 then 'High'
when temperature < 299 and temperature  >= 285 then 'Mild'
when temperature < 285 and temperature >= 274 then 'Cold'
when temperature < 274 then 'Very Cold'
end as temperature_level,
case 
when pressure < 1009 then 'Low'
when pressure >= 1009 then 'High'
end as pressure_level, 
case 
when humidity > 50 and humidity <= 60 then 'Medium'	
when humidity >= 40 and humidity <= 50 then 'Low'
when humidity > 60 then 'High'
when humidity < 40 then 'Very Low'
end as humidity_level
from maintenance.crime_stage_filtered_load
left join maintenance.weather_stage_filtered_load on 
(crime_stage_filtered_load.year,crime_stage_filtered_load.month, crime_stage_filtered_load.day) =  (weather_stage_filtered_load.year,weather_stage_filtered_load.month,crime_stage_filtered_load.day)
left join maintenance.moon_stage_v_load on
(crime_stage_filtered_load.year,crime_stage_filtered_load.month) =  (moon_stage_v_load.year,moon_stage_v_load.month)) a
where humidity is not null and pressure is not null and temperature is not null and weather_description is not null and wind_speed is not null and 
wind_direction is not null and phaseid is not null and timezone is not null and temperature_level is not null and pressure_level is not null and humidity_level is not null; 



drop table maintenance.joint_data_full_load;

select * from maintenance.joint_data_full_load;

--- add case weather here --- update this fact table

select distinct on (datetime) * from  maintenance.joint_data_full_load;

------------------------------------------------------------------------Updating Date Dimension SDC 1 ------------------------------------------------------------

--select distinct on 

merge into warehouse.date d
using (select distinct on (datetime) * from maintenance.joint_data_full_load) c
on c.datetime = d.datetime
when matched then
  update set datetime = c.datetime,
  year = c.year,
  quarter = c.quarter,
  month = c.month,
  day = c.day,
  hour = c.hour
when not matched then
  insert (year, quarter, month, day, hour, datetime)
  VALUES (c.year, c.quarter, c.month, c.day, c.hour, c.datetime);


 select * from warehouse.date where year = 2018 order by datetime; -- only insert since matched only dates -- https://stackoverflow.com/a/42994480 merge cannot affect same row more than once once inserted
  
------------------------------------------------------------------------Updating Offense Dimension SCD 2---------------------------------------------------------

 select count(*) from warehouse.offense d;
 
merge into warehouse.offense d
using maintenance.crime_stage_filtered_load c
on (c.offense_code,c.offense_description ) = (d.offense_code, d.offense_description) 
when matched then
  do nothing
when not matched then
  insert (offense_code, offense_code_group, offense_description, effective_date, expiration_date, current_status)
  values(c.offense_code, c.offense_code_group, c.offense_description,cast(format('%s-01-01 00:00:000', c.year) as timestamp), 
 format('%s-01-01 00:00:000', c.year)::timestamp + interval '1 year', 'Changed');
  
 --https://stackoverflow.com/questions/45026903/cast-date-to-timestamp-in-pgsql, April 18 2023
 --https://database.guide/subtract-days-from-a-date-in-postgresql/, April 17 2023
 -- https://www.postgresql.org/docs/current/sql-merge.html, April 18 2023
  
select * from warehouse.offense where offense_code  = 727 or offense_code = 1843 or offense_code = 301 or offense_code = 1501 or offense_code = 1843 or offense_code = 3006 or offense_code = 802; 

select * from warehouse.offense;

select * from maintenance.crime_stage_filtered_load; -- Shows only one record went to the final stage dataset due to null filtering and preparation...
 
 
 
------------------------------------------------------------------------Updating Weather Dimension SCD1--------------------------------------------------------

select count(*) from warehouse.weather w  where humidity_level = 'Low'; -- 14 records with low humidity on original Dimension

select count(*) from warehouse.weather;


merge into warehouse.weather  d
using  (select distinct on (pressure_level, humidity_level, temperature_level, weather_description) * from maintenance.joint_data_full_load where humidity_level = 'Very Low') c
on (d.pressure_level, d.temperature_level, d.weather_description) = (c.pressure_level, c.temperature_level, c.weather_description) 
when matched then
  update set pressure_level = c.pressure_level,
  humidity_level = c.humidity_level,
  temperature_level = c.temperature_level,
  weather_description = c.weather_description
when not matched then
  insert (pressure_level, humidity_level, temperature_level, weather_description)
  values (c.pressure_level, c.humidity_level, c.temperature_level, c.weather_description);
 
select * from warehouse.weather w;
 
------------------------------------------------------------------------Updating lunar_phase Dimension --------------------------------------------------------

--

merge into warehouse.lunar_phase d
using (select distinct on (datetime) * from maintenance.joint_data_full_load) c
on (c.phaseid , c.phase, c.timezone)  = (d.phaseid , d.phase, d.timezone)
when matched then
do nothing
when not matched then
  insert (phaseid, phase, timezone)
  values (c.phaseid, c.phase, c.timezone);

 
 select * from warehouse.lunar_phase;
 
------------------------------------------------------------------------Updating location Dimension SCD3 ---------------------------------------------------------


--- Alter Adding extra column previous_district_name if new district is not found on Dimension populate with current district name

select not exists (select current_district_name from warehouse.location where current_district_name in ('B103'));
select not exists (select current_district_name from warehouse.location where current_district_name in ('C106'));
alter table warehouse.location add column previous_district_name_2022 varchar;

-- add values from current_district_name for now
update warehouse.location 
set previous_district_name_2022 =  current_district_name;	


--- Apply the merge pg_catalog.pg_prepared_statements 
merge into warehouse.location d
using (select distinct on (district, neighborhood, street) * from maintenance.joint_data_full_load) c
on (c.neighborhood, c.street) = (d.neighborhood, d.street)
when matched then
update set current_district_name = c.district
when not matched then
do nothing; -- or insert, depending on the model



select * from warehouse.location where current_district_name  = 'B103' or current_district_name  = 'C106';



select * from warehouse.location;

-- Sources:
--https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-exists/, April 22 2023


----------------- Answering Bussiness question 1 Which districs are more prone to crime and at what time of day?  ------------------

CREATE extension tablefunc;

(select location.current_district_name,location.neighborhood, date.hour, count(crime_details_id) number_of_offenses from warehouse.crime_details 
left join warehouse.location 
on 
crime_details.location_id = location.location_id
left join warehouse.date
on 
crime_details.dateid = date.dateid
group by date.hour ,location.neighborhood,location.current_district_name order by number_of_offenses desc);


select * from crosstab('select hour, neighborhood, number_of_offenses from  (select location.current_district_name,location.neighborhood, date.hour, count(crime_details_id) number_of_offenses from warehouse.crime_details 
left join warehouse.location 
on 
crime_details.location_id = location.location_id
left join warehouse.date
on 
crime_details.dateid = date.dateid
group by location.current_district_name,location.neighborhood, date.hour order by number_of_offenses desc) a order by 1' )
as (Hour integer,"Brighton" bigint, "Charlestown" bigint, "Dorchester" bigint, "Downtown" bigint, "East Boston" bigint, "Hyde Park" bigint,
"Jamaica Plain" bigint, "Mattapan" bigint, "Roxbury" bigint, "South Boston" bigint, "South End" bigint, "West Roxbury" bigint);
  
----- Another option

select * from crosstab('select neighborhood, hour, number_of_offenses from  (select location.current_district_name,location.neighborhood, date.hour, count(crime_details_id) number_of_offenses from warehouse.crime_details 
left join warehouse.location 
on 
crime_details.location_id = location.location_id
left join warehouse.date
on 
crime_details.dateid = date.dateid
group by location.current_district_name,location.neighborhood, date.hour order by number_of_offenses desc) a order by 1' )
as (neighborhood varchar,"1" bigint, "2" bigint, "3" bigint, "4" bigint, "5" bigint, "6" bigint,
"7" bigint, "8" bigint, "9" bigint, "10" bigint, "11" bigint, "12" bigint, "13" bigint, "14" bigint, 
"15" bigint, "16" bigint, "17" bigint, "18" bigint, "19" bigint, "20" bigint, "21" bigint, "22" bigint, "23" bigint, "0" bigint);


-- https://learnsql.com/blog/creating-pivot-tables-in-postgresql-using-the-crosstab-function/, April 18 2023
--https://stackoverflow.com/questions/52486821/postgresql-crosstab-month-rows-and-day-columns-error-rowid-datatype-does-not-m, April 2018 2023
--https://www.postgresql.org/docs/current/tablefunc.html, April 18 2023
--https://www.youtube.com/watch?v=4p-G7fGhqRk&t=2435s, April 18 2023 

--------------- Answering Bussiness Question 2 How does crime vary between seasons, quarters, months weeks, or days? ---------------------------------------------

select * from warehouse.crime_details cd ;
select * from warehouse.date;
select * from warehouse.weather_facts;

-- Exploring patterns

select day, sum(number_of_incidents), case when day >= 1 and day <= 15 then 'first_half' else 'second_half' end as month_half
from (select year, season, quarter, month, day, sum(offense_count) as number_of_incidents, 
dense_rank() over(partition by season, quarter, month order by sum(offense_count) desc)
from (select count(a.offenseid) as offense_count, a.seriousness_rank, a.year, b.season, a.quarter, a.month, a.day
from
(select crime_details.offenseid, crime_details.seriousness_rank, date.year, date.quarter, date.month, 
date.day, date.datetime
from warehouse.crime_details
left join warehouse."date" 
on crime_details.dateid = date.dateid order by date.datetime desc) a
inner join 
(select weather_facts.offense_id, weather_date.season, weather_date.datetime 
from warehouse.weather_facts
left join warehouse.weather_date 
on weather_facts.weather_date_id = weather_date.weather_date_id order by weather_date.datetime desc) b
on a.datetime = b.datetime group by a.year,b.season, a.quarter, a.month, a.day,a.seriousness_rank, a.offenseid) c
group by year, season, quarter, month, day) d group by rollup(month_half, day); -- second Half of month is more prone to incidents



select season,sum(number_of_incidents)
from (select year, season, quarter, month, day, sum(offense_count) as number_of_incidents, 
dense_rank() over(partition by season, quarter, month order by sum(offense_count) desc)
from (select count(a.offenseid) as offense_count, a.seriousness_rank, a.year, b.season, a.quarter, a.month, a.day
from
(select crime_details.offenseid, crime_details.seriousness_rank, date.year, date.quarter, date.month, 
date.day, date.datetime
from warehouse.crime_details
left join warehouse."date" 
on crime_details.dateid = date.dateid order by date.datetime desc) a
inner join 
(select weather_facts.offense_id, weather_date.season, weather_date.datetime 
from warehouse.weather_facts
left join warehouse.weather_date 
on weather_facts.weather_date_id = weather_date.weather_date_id order by weather_date.datetime desc) b
on a.datetime = b.datetime group by a.year,b.season, a.quarter, a.month, a.day,a.seriousness_rank, a.offenseid) c
group by year, season, quarter, month, day) d group by rollup(season); 


select quarter,sum(number_of_incidents)
from (select year, season, quarter, month, day, sum(offense_count) as number_of_incidents, 
dense_rank() over(partition by season, quarter, month order by sum(offense_count) desc)
from (select count(a.offenseid) as offense_count, a.seriousness_rank, a.year, b.season, a.quarter, a.month, a.day
from
(select crime_details.offenseid, crime_details.seriousness_rank, date.year, date.quarter, date.month, 
date.day, date.datetime
from warehouse.crime_details
left join warehouse."date" 
on crime_details.dateid = date.dateid order by date.datetime desc) a
inner join 
(select weather_facts.offense_id, weather_date.season, weather_date.datetime 
from warehouse.weather_facts
left join warehouse.weather_date 
on weather_facts.weather_date_id = weather_date.weather_date_id order by weather_date.datetime desc) b
on a.datetime = b.datetime group by a.year,b.season, a.quarter, a.month, a.day,a.seriousness_rank, a.offenseid) c
group by year, season, quarter, month, day) d group by rollup(quarter); 

select month,sum(number_of_incidents)
from (select year, season, quarter, month, day, sum(offense_count) as number_of_incidents, 
dense_rank() over(partition by season, quarter, month order by sum(offense_count) desc)
from (select count(a.offenseid) as offense_count, a.seriousness_rank, a.year, b.season, a.quarter, a.month, a.day
from
(select crime_details.offenseid, crime_details.seriousness_rank, date.year, date.quarter, date.month, 
date.day, date.datetime
from warehouse.crime_details
left join warehouse."date" 
on crime_details.dateid = date.dateid order by date.datetime desc) a
inner join 
(select weather_facts.offense_id, weather_date.season, weather_date.datetime 
from warehouse.weather_facts
left join warehouse.weather_date 
on weather_facts.weather_date_id = weather_date.weather_date_id order by weather_date.datetime desc) b
on a.datetime = b.datetime group by a.year,b.season, a.quarter, a.month, a.day,a.seriousness_rank, a.offenseid) c
group by year, season, quarter, month, day) d group by rollup(month); 

--Sources: https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-rollup/, April 24 2023




---------------- Answering Bussiness  Question 3 Is there a relationship between weather and crime? Are hot days more likely? to cause violent crime to rise? Are hidden weather features that may also be related to crime? ------------------

select * from warehouse.offense;

select distinct count(*) from warehouse.crime_details cd ;

select * from warehouse.crime_details;

select * from warehouse.weather w ;

select weather.temperature_level,weather.pressure_level, weather.humidity_level, count(crime_details.crime_details_id) as offense_count, 
rank() over(partition by temperature_level, pressure_level order by count(crime_details.crime_details_id) desc) as ranking
from warehouse.crime_details 
left join warehouse.weather 
on (crime_details.weather_record_id) = (weather.weather_record_id) where seriousness_rank  <= 5
group by weather.temperature_level,weather.pressure_level, weather.humidity_level
; -- Temperature and humidity partitioned


select weather.temperature_level,weather.pressure_level, weather.humidity_level, count(crime_details.crime_details_id) as offense_count, 
rank() over(partition by humidity_level order by count(crime_details.crime_details_id) desc) as ranking
from warehouse.crime_details 
left join warehouse.weather 
on (crime_details.weather_record_id) = (weather.weather_record_id) where seriousness_rank  <= 5
group by weather.temperature_level,weather.pressure_level, weather.humidity_level
; -- humidity partitioned

-- https://www.postgresql.org/docs/current/tutorial-window.html, April 22 2023 -- Good posgres documentation page


---------------------------------- Answering Bussiness Question 5 : Are there any other hidden patterns that may be influencing crime in the city?  --------------------------------------------------------

select * from warehouse.offense_type_count;
select * from warehouse.lunar_phase;
select * from warehouse.weather_date;

select weather_date.season,lunar_phase.phase, sum(offense_type_count.offense_code_count) as number_of_offenses,
rank() over(partition by season order by sum(offense_type_count.offense_code_count) desc) as ranking from 
warehouse.offense_type_count
left join warehouse.weather_date 
on
offense_type_count.weather_date_id = weather_date.weather_date_id
left join warehouse.lunar_phase
on
offense_type_count.moon_cycle_id = lunar_phase.moon_cycle_id
group by lunar_phase.phase, weather_date.season
;



select * from crosstab('select season, phase, number_of_offenses from 
(select weather_date.season,lunar_phase.phase, sum(offense_type_count.offense_code_count) as number_of_offenses,
rank() over(partition by season order by sum(offense_type_count.offense_code_count) desc) as ranking from 
warehouse.offense_type_count
left join warehouse.weather_date 
on
offense_type_count.weather_date_id = weather_date.weather_date_id
left join warehouse.lunar_phase
on
offense_type_count.moon_cycle_id = lunar_phase.moon_cycle_id
group by lunar_phase.phase, weather_date.season) a order by 1')
as(season varchar,"New Moon" numeric , "First Quarter" numeric, "Full Moon" numeric, "Last Quarter" numeric);

-- https://learnsql.com/blog/creating-pivot-tables-in-postgresql-using-the-crosstab-function/, April 18 2023
--https://stackoverflow.com/questions/52486821/postgresql-crosstab-month-rows-and-day-columns-error-rowid-datatype-does-not-m, April 2018 2023
--https://www.postgresql.org/docs/current/tablefunc.html, April 18 2023
--https://www.youtube.com/watch?v=4p-G7fGhqRk&t=2435s, April 18 2023  





