


-----------------------------Creating a Neighborhood Column base on District and filtering columns that will not be used ----------------------------------
 


create table stage.crime_stage_filtered as select * from (select "INCIDENT_NUMBER" as incident_number, "OFFENSE_CODE" as offense_code,"OFFENSE_CODE_GROUP" as offense_code_group,
"OFFENSE_DESCRIPTION" as offense_description, "DISTRICT" as district, case when "DISTRICT" = 'A1' then 'Downtown'
		    when "DISTRICT" = 'A15' then 'Charlestown'
		    when "DISTRICT" = 'A7' then 'East Boston'
		    when "DISTRICT" = 'B2' then 'Roxbury'
		    when "DISTRICT" = 'B3' then 'Mattapan'
		    when "DISTRICT" = 'C11' then 'Dorchester'
		    when "DISTRICT" = 'C6' then 'South Boston'
		    when "DISTRICT" = 'D14' then 'Brighton'
		    when "DISTRICT" = 'D4' then 'South End'
		    when "DISTRICT" = 'E13' then 'Jamaica Plain'
		    when "DISTRICT" = 'E18' then 'Hyde Park'
		    when "DISTRICT" = 'E5' then 'West Roxbury'
		    when "DISTRICT" = 'External' then 'External'
		    when "DISTRICT" is NULL then NULL
			end neighborhood, cast("OCCURRED_ON_DATE" as timestamp) as datetime,
		    "YEAR" as year, 
		    case when cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) >= 1 and cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) <= 3 then 'Q1'
			when cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) >= 4 and cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer)<= 6 then 'Q2' 
			when cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) >= 6 and cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) <= 9 then 'Q3'
			when cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) >= 10 and cast(split_part("OCCURRED_ON_DATE", '-', 2)as integer) <= 12 then 'Q4'
			end quarter,
		    "MONTH" as month, cast(split_part(split_part("OCCURRED_ON_DATE", '-', 3), ' ', 1)as integer) as day,
		    "DAY_OF_WEEK" as day_of_week, "HOUR" as hour,
			"STREET" as street, "Lat" as latitude, "Long" as longitude
			
from  stage.crime_stage) stg;

select * from stage.crime_stage_filtered;

   

--drop table stage.crime_stage_filtered ;



---https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/, April 10 2023
---https://www.postgresqltutorial.com/postgresql-string-functions/postgresql-split_part/, April 10 2023
---https://bpdnews.com/districts, April 11 2023
---https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-change-column-type/, April 16 2023

-------------------------------------- Setting up Weather Stage Table -----------------------------------

select distinct  on (weather_description) * from stage.weather_stage;
select distinct weather_description from stage.weather_stage;


------------------------------------ Creating Weather Stage Filtered table ---------------------------------------------------
/*Building new dates, and arragning categories for weather description*/


--drop table stage.weather_stage_filtered;

create table stage.weather_stage_filtered as select * from ( select cast(datetime as timestamp) as datetime, cast(split_part(datetime, '-', 1)as integer) as year, 
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
			wind_speed, wind_direction from stage.weather_stage) a;

select * from stage.weather_stage_filtered;

---https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-change-column-type/, April 10 2023
---https://www.postgresqltutorial.com/postgresql-string-functions/postgresql-split_part/, April 10 2023
---https://stackoverflow.com/questions/19947817/getting-error-function-to-datetimestamp-without-time-zone-unknown-does-not-ex, April 10 2023


------------------------------------ Setting up Moon Stage Table -------------------------------------------------



select cast(datetime as timestamp) from stage.moon_stage  where phase = 'New Moon'

select * from stage.moon_s`tage ms 

select datetime from stage.moon_stage order by datetime limit 1;
select datetime from stage.moon_stage order by datetime desc limit 1;

drop table stage.moon_stage_interpolated

--- Creating view for moon_stage:
 
 
 create or replace view  stage.moon_stage_v as select * from 
 ( select datetime, cast(split_part(cast(datetime as varchar), '-', 1)as integer) as year, 
cast(split_part(cast(datetime as varchar), '-', 2)as integer) as month,
cast(split_part( split_part(cast(datetime as varchar), '-', 3), ' ', 1) as integer ) as day,
cast(split_part(split_part(cast(datetime as varchar), ' ',2), ':', 1) as integer) as hour,
phase, phaseid, timezone from stage.moon_stage) a;

select * from stage.moon_stage_v;
 


 -- Source: https://www.timescale.com/blog/how-to-create-lots-of-sample-time-series-data-with-postgresql-generate_series/, April 16 2023
--- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-add-column/, April 16 2023
--- https://stackoverflow.com/a/15766129, April 16 2023
--- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-rename-column/, April 16 2023
--- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-change-column-type/. April 16 2023
--- https://www.postgresql.org/docs/current/dml-insert.html#:~:text=You%20can%20insert%20multiple%20rows,row%2C%20or%20many%20rows)%3A, April 16 2023
--- https://stackoverflow.com/questions/6256610/updating-table-rows-in-postgres-using-subquery, April 16 2023
---https://www.postgresqltutorial.com/postgresql-string-functions/postgresql-split_part/, April 10 2023

----------------------------------------Creating Dimensions and Fact Tables ------------------------------------------------------------


select crime_stage_filtered.incident_number, crime_stage_filtered.offense_code, crime_stage_filtered.offense_code_group, crime_stage_filtered.offense_description, crime_stage_filtered.district as district, crime_stage_filtered.neighborhood,
crime_stage_filtered.datetime, crime_stage_filtered.year, crime_stage_filtered.quarter, crime_stage_filtered.month, crime_stage_filtered.day, crime_stage_filtered.hour, crime_stage_filtered.street, crime_stage_filtered.latitude,
crime_stage_filtered.longitude, weather_stage_filtered.humidity, weather_stage_filtered.pressure, weather_stage_filtered.temperature, weather_stage_filtered.weather_description, weather_stage_filtered.wind_speed, 
weather_stage_filtered.wind_direction, moon_stage_v.phase, moon_stage_v.phaseid, moon_stage_v.timezone from stage.crime_stage_filtered
left join stage.weather_stage_filtered on 
(crime_stage_filtered.year,crime_stage_filtered.month, crime_stage_filtered.day, crime_stage_filtered.hour) =  (weather_stage_filtered.year,weather_stage_filtered.month, weather_stage_filtered.day, weather_stage_filtered.hour)
left join stage.moon_stage_v on
(crime_stage_filtered.year,crime_stage_filtered.month, crime_stage_filtered.day) =  (moon_stage_v.year,moon_stage_v.month, moon_stage_v.day)



--- Source https://stackoverflow.com/questions/17466663/join-postgres-table-on-two-columns



-------------------------------------------------------- Creating Joint Table (All Tables together) --------------------------------------------------------------

create table stage.joint_data_full as select * from (select crime_stage_filtered.incident_number, crime_stage_filtered.offense_code, crime_stage_filtered.offense_code_group, crime_stage_filtered.offense_description, crime_stage_filtered.district, crime_stage_filtered.neighborhood,
crime_stage_filtered.datetime, crime_stage_filtered.year, crime_stage_filtered.quarter, crime_stage_filtered.month, crime_stage_filtered.day, crime_stage_filtered.hour, crime_stage_filtered.street, crime_stage_filtered.latitude,
crime_stage_filtered.longitude, weather_stage_filtered.humidity, weather_stage_filtered.pressure, weather_stage_filtered.temperature, weather_stage_filtered.weather_description, weather_stage_filtered.wind_speed, 
weather_stage_filtered.wind_direction, moon_stage_v.phase, moon_stage_v.phaseid, moon_stage_v.timezone, 
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
when humidity >= 40 and humidity <= 60 then 'Medium'	
when humidity < 50 then 'Low'
when humidity > 60 then 'High'
end as humidity_level
from stage.crime_stage_filtered
left join stage.weather_stage_filtered on 
(crime_stage_filtered.year,crime_stage_filtered.month, crime_stage_filtered.day, crime_stage_filtered.hour) =  (weather_stage_filtered.year,weather_stage_filtered.month, weather_stage_filtered.day, weather_stage_filtered.hour)
left join stage.moon_stage_v on
(crime_stage_filtered.year,crime_stage_filtered.month, crime_stage_filtered.day) =  (moon_stage_v.year,moon_stage_v.month, moon_stage_v.day)) a;



select * from stage.joint_data_full;
--drop table stage.joint_data_full;



----------------------------------------- Filtering the Joint Table in order to get the appropiate year (2015-2017)--------------------------------------
--- 

create table stage.joint_data as select * from (select * from stage.joint_data_full where year >= 2015 and year <= 2017 and
phaseid is not null and humidity is not null and pressure is not null and temperature is not null 
and street is not null and neighborhood is not null and district is not null and latitude is not null and longitude is not null) a;

select * from stage.joint_data where phaseid = 1 or phaseid = 2 or phaseid = 3 or phaseid = 4;

select count(*) from stage.joint_data where phaseid = 1 or phaseid = 2 or phaseid = 3 or phaseid = 4;

drop table stage.joint_data;

select count(*) from stage.joint_data where phaseid is not null and humidity is not null 
and pressure is not null and temperature is not null and street is not null and district is not null and 
latitude is not null and longitude is not null;


select * from stage.joint_data where street is null or district is null;

create index weather_idx on stage.joint_data(temperature_level, pressure_level, humidity_level);
create index weather_idx_desc on stage.joint_data(weather_description);

--**************************************************** Creating Date Dimension *******************************************************--

drop table warehouse.date;

create table warehouse.date (dateID serial primary key, year int, quarter varchar, month int, day int, hour int, datetime timestamp);


insert into warehouse.date(year, quarter, month, day, hour, datetime) 
select distinct cast(year as int) as year, quarter, cast(month as int) as month, cast(day as int) as day, cast(hour as int) as hour, datetime from stage.joint_data;


select  * from warehouse.date;



--*************************************************** Creating Offense Dimension ***********************************************--

drop table warehouse.offense;

create table warehouse.offense (offenseID serial primary key, offense_code bigint, offense_code_group varchar, 
offense_description varchar, effective_date timestamp, expiration_date timestamp, current_status varchar);


insert into warehouse.offense(offense_code, offense_code_group, offense_description, effective_date, expiration_date) 
select distinct  offense_code, offense_code_group, offense_description,
case when year = 2015 then cast('2015-01-01 00:00:00.000' as timestamp)
when year = 2016 then cast('2016-01-01 00:00:00.000' as timestamp)
when year = 2017 then cast('2017-01-01 00:00:00.000' as timestamp)
end as effective_date,
case when year = 2015 then cast('2015-01-01 00:00:00.000' as timestamp) + interval '1 year'
when year = 2016 then cast('2016-01-01 00:00:00.000' as timestamp)  + interval '1 year'
when year = 2017 then cast('2017-01-01 00:00:00.000' as timestamp)  + interval '1 year'
end as expiration_date
from stage.joint_data;




/* If offense code, offense code group and (possibly) offense code description remain unchanged from prevous cycle, 
  then that is "Unchanged", any other case is "Chenged"*. So when new data comes and for same offense code, check the timestamp, is that timestamp between range?
 if yes then check if there is a change and record it. Finally grab the year on which ned data came and create interval based on that.*/

update warehouse.offense 
set current_status = 'Unchanged';

select * from warehouse.offense



select datetime, year, offense_code from stage.joint_data where offense_code  = 3002


SELECT date '2022-10-12' - 7;

---https://database.guide/subtract-days-from-a-date-in-postgresql/, April 17 2023
--- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-update/, April 17 2023

--****************************************************Creating Weather Dimension*******************************************************--


create table warehouse.weather (weather_record_id serial primary key, weather_description varchar, temperature_level varchar, 
pressure_level varchar, humidity_level varchar);

insert into warehouse.weather(weather_description , temperature_level, 
pressure_level,humidity_level)
select distinct weather_description, 
temperature_level,pressure_level, humidity_level
from stage.joint_data;


--weather_timestamp timestamp

select * from warehouse.weather



drop table warehouse.weather;

-- https://www.maximum-inc.com/what-is-atmospheric-pressure-and-how-is-it-measured/#:~:text=A%20barometric%20reading%20below%2029.80,with%20warm%20air%20and%20rainstorms, April 17 2023

select * from warehouse.weather where weather_record_id  is null;

--***************************************************Creating Lunar Phase Dimension***********************************************************************--

DROP TABLE warehouse.lunar_phase;

CREATE TABLE warehouse.lunar_phase (
	moon_cycle_id serial primary key,
	phaseid integer,
	phase varchar,
	timezone varchar
);


insert into warehouse.lunar_phase (phaseid, phase, timezone) 
select distinct phaseid, phase, timezone from stage.joint_data
where phase is not null and phaseid is not null 
and timezone is not null;

select * from warehouse.lunar_phase lp ;


select distinct phaseid, phase, timezone from stage.joint_data
where phase is not null and phaseid is not null 
and timezone is not null;
--**************************************Creating weather_date Dimension************************************************--

drop table warehouse.weather_date;

create table warehouse.weather_date (weather_date_id serial primary key, year int, season varchar, month int, day int, hour int, datetime timestamp);


insert into warehouse.weather_date(year, season, month, day, hour, datetime) 
select distinct cast(year as int) as year, 
case
	when month = 3 and day >= 21 then 'Spring'
	when month = 4 then 'Spring'
	when month = 5 then 'Spring'
	when month = 6 and day < 21 then 'Spring'
	when month = 6 and day >= 21 then 'Summer'
	when month = 7 then 'Summer'
	when month = 8 then 'Summer'
	when month = 9 and day < 21 then 'Summer'
	when month = 9 and day >= 21 then 'Fall'
	when month = 10 then 'Fall'
	when month = 11 then 'Fall'
	when month = 12 and day < 21 then 'Fall'
	when month = 12 and day >= 21 then 'Winter'
	when month = 1 then 'Winter'
	when month = 2 then 'Winter'
	when month = 3 and day < 21 then 'Winter'
end as season,
cast(month as int) as month, cast(day as int) as day, cast(hour as int) as hour , datetime from stage.joint_data;



select  * from warehouse.weather_date wd ;


----------------Creating location Dimension-------------------------

drop table warehouse.location;

create table warehouse.location (location_id serial primary key, neighborhood varchar, street varchar, current_district_name varchar);

insert into warehouse.location(neighborhood,street, current_district_name)
select distinct neighborhood, street, district from stage.joint_data where 
neighborhood is not null and street is not null and district is not null;


select * from warehouse.location where location_id is null;

/* When new data comes, It is imperative to check if there has been any change to the discrict/neighborhood name pair. If there is another combination of those,
 * for example C7 - Mattapan changed to C11 Mattapan to not cause confisuion with another city which this deparment is sharing data with. This means that now there needs to be
 * an update of the current neihborhood/district pair and create new columnn for previous data*/

----------------Creating crime_details Fact Table-----------------------------------
 

create table warehouse.crime_details (crime_details_id serial primary key, 
offenseID int not null, dateID int not null, moon_cycle_id int not null,
location_id int not null,weather_record_id int not null, latitude numeric, 
longitude numeric, seriousness_rank int);

drop table warehouse.crime_details;
truncate table warehouse.crime_details;



insert into warehouse.crime_details (offenseID, dateID,moon_cycle_id,location_id,weather_record_id,latitude, longitude, seriousness_rank) select distinct on (stage.joint_data.year, stage.joint_data.month, stage.joint_data.day, stage.joint_data.hour, 
stage.joint_data.offense_code, stage.joint_data.district)
offense.offenseID, date.dateID, lunar_phase.moon_cycle_id, location.location_id, weather.weather_record_id,
joint_data.latitude, joint_data.longitude, case 
when joint_data.offense_code_group = 'Aggravated Assault' then 3
when joint_data.offense_code_group = 'Aircraft' then 5
when joint_data.offense_code_group = 'Arson' then 4
when joint_data.offense_code_group = 'Assembly or Gathering Violations' then 10
when joint_data.offense_code_group = 'Auto Theft' then 7
when joint_data.offense_code_group = 'Auto Theft Recovery' then 7
when joint_data.offense_code_group = 'Ballistics' then 4
when joint_data.offense_code_group = 'Biological Threat' then 5
when joint_data.offense_code_group = 'Bomb Hoax' then 8
when joint_data.offense_code_group = 'Burglary - No Property Taken' then 8
when joint_data.offense_code_group = 'Commercial Burglary' then 7
when joint_data.offense_code_group = 'Confidence Games' then 9
when joint_data.offense_code_group = 'Counterfeiting' then 8
when joint_data.offense_code_group = 'Drug Violation' then 8
when joint_data.offense_code_group = 'Embezzlement' then 7
when joint_data.offense_code_group = 'Evading Fare' then 10
when joint_data.offense_code_group = 'Explosives' then 3
when joint_data.offense_code_group = 'Fire Related Reports' then 4
when joint_data.offense_code_group = 'Firearm Discovery' then 5
when joint_data.offense_code_group = 'Firearm Violations' then 5
when joint_data.offense_code_group = 'Fraud' then 7
when joint_data.offense_code_group = 'Gambling' then 10
when joint_data.offense_code_group = 'HOME INVASION' then 5
when joint_data.offense_code_group = 'HUMAN TRAFFICKING' then 2
when joint_data.offense_code_group = 'HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE' then 2
when joint_data.offense_code_group = 'Harassment' then 5
when joint_data.offense_code_group = 'Harbor Related Incidents' then 7
when joint_data.offense_code_group = 'Homicide' then 1
when joint_data.offense_code_group = 'INVESTIGATE PERSON' then 7
when joint_data.offense_code_group = 'Investigate Person' then 7
when joint_data.offense_code_group = 'Investigate Property' then 8
when joint_data.offense_code_group = 'Landlord/Tenant Disputes' then 9
when joint_data.offense_code_group = 'Larceny' then 7
when joint_data.offense_code_group = 'Larceny From Motor Vehicle' then 6
when joint_data.offense_code_group = 'License Plate Related Incidents' then 10
when joint_data.offense_code_group = 'License Violation' then 9
when joint_data.offense_code_group = 'Liquor Violation' then 8
when joint_data.offense_code_group = 'Manslaughter' then 4
when joint_data.offense_code_group = 'Medical Assistance' then 4
when joint_data.offense_code_group = 'Missing Person Located' then 4
when joint_data.offense_code_group = 'Missing Person Reported' then 4
when joint_data.offense_code_group = 'Motor Vehicle Accident Response' then 8
when joint_data.offense_code_group = 'Offenses Against Child / Family' then 3
when joint_data.offense_code_group = 'Operating Under the Influence' then 7
when joint_data.offense_code_group = 'Other' then 5
when joint_data.offense_code_group = 'Other Burglary' then 8
when joint_data.offense_code_group = 'Phone Call Complaints' then 9
when joint_data.offense_code_group = 'Police Service Incidents' then 7
when joint_data.offense_code_group = 'Prisoner Related Incidents' then 7
when joint_data.offense_code_group = 'Property Found' then 8
when joint_data.offense_code_group = 'Property Lost' then 8
when joint_data.offense_code_group = 'Property Related Damage' then 8
when joint_data.offense_code_group = 'Prostitution' then 6
when joint_data.offense_code_group = 'Recovered Stolen Property' then 8
when joint_data.offense_code_group = 'Residential Burglary' then 6
when joint_data.offense_code_group = 'Robbery' then 5
when joint_data.offense_code_group = 'Restraining Order Violations' then 7
when joint_data.offense_code_group = 'Search Warrants' then 7
when joint_data.offense_code_group = 'Service' then 9
when joint_data.offense_code_group = 'Simple Assault' then 6
when joint_data.offense_code_group = 'Towed' then 10
when joint_data.offense_code_group = 'Vandalism' then 7
when joint_data.offense_code_group = 'Verbal Disputes' then 9
when joint_data.offense_code_group = 'Violations' then 5
when joint_data.offense_code_group = 'Warrant Arrests' then 6
when joint_data.offense_code_group = 'Disorderly Conduct' then 9
when joint_data.offense_code_group = 'Criminal Harassment' then 4
when joint_data.offense_code_group is null then null end as
seriousness_rank
from stage.joint_data
left join warehouse.location 
on
((joint_data.district, joint_data.street, joint_data.neighborhood)) = ((location.current_district_name, location.street, location.neighborhood))
left join warehouse.date on
(cast(joint_data.year as int),cast(joint_data.month as int),cast(joint_data.day as int),cast(joint_data.hour as int)) =  (date.year,date.month, date.day, date.hour)
left join warehouse.weather
on 
((joint_data.temperature_level,joint_data.pressure_level,joint_data.humidity_level )) = ((weather.temperature_level, weather.pressure_level, weather.humidity_level))
left join warehouse.offense
on 
(joint_data.offense_code, joint_data.offense_code_group, joint_data.offense_description) = (offense.offense_code, offense.offense_code_group, offense.offense_description)
left join warehouse.lunar_phase
on 
((joint_data.phaseid, joint_data.phase, joint_data.timezone))=((lunar_phase.phaseid, lunar_phase.phase, lunar_phase.timezone))where  weather.weather_record_id is not null and location.location_id is not null;


VACUUM;



select * from warehouse.crime_details where seriousness_rank is not null;

select count(*) from warehouse.crime_details;

select * from pg_stat_all_tables

select distinct * from stage.lunar_phase where timezone is null

select count(*) from warehouse.date;
select count(*) from warehouse.location;
select count(*) from warehouse.offense o;
select  count(*) from warehouse.weather w ;
select * from warehouse.lunar_phase lp; 

-----Sources: https://stackoverflow.com/questions/16913969/postgres-distinct-but-only-for-one-column. April 6 2023
-----https://stackoverflow.com/questions/13908249/mysql-removing-duplicate-columns-on-left-join-3-tables. April 6 2023
-----https://stackoverflow.com/questions/6083132/postgresql-insert-into-select. April 6 2023


--- year, quarter, month, day and hour -- will be used to join to date and get the offense ID foreign key


create index attrib_idx2 on warehouse.crime_details(latitude,longitude,seriousness_rank);
create index ky_idx on warehouse.crime_details(offenseid, location_id, weather_record_id, moon_cycle_id, dateid);

-- sources:
--https://www.postgresql.org/docs/current/indexes-multicolumn.html, April 22 2023
--https://www.postgresqltutorial.com/postgresql-indexes/postgresql-create-index/, April 22 2023

----------------------------------------------- creating fact table Offense_Type_Count ----------------------------------------------------


create table warehouse.offense_type_count (offense_type_count_id serial primary key, 
offenseID int not null,location_id int not null, weather_date_id int not null, weather_record_id int not null, 
moon_cycle_id int not null,offense_code_count numeric);

drop table warehouse.offense_type_count;
truncate table warehouse.offense_type_count;

select * from warehouse.offense_type_count ;
select * from warehouse.weather_date wd ;



select count(*) from warehouse.weather_date wd ; -- 2877
select count(*) from warehouse.offense wd ; -- 491
select count(*) from warehouse.location ; -- 2991
select count(*) from warehouse.weather w  ; --100

insert into warehouse.offense_type_count (offenseID, location_id, weather_date_id,weather_record_id,moon_cycle_id, offense_code_count) 
select distinct on (stage.joint_data.year, stage.joint_data.month, stage.joint_data.day, stage.joint_data.hour, stage.joint_data.offense_code, stage.joint_data.district)
offense.offenseID,location.location_id,weather_date.weather_date_id,weather.weather_record_id,lunar_phase.moon_cycle_id, 
count(offense.offense_code) as offense_code_count
from stage.joint_data 
left join warehouse.weather_date
on
(cast(joint_data.year as int),cast(joint_data.month as int),cast(joint_data.day as int),cast(joint_data.hour as int)) =  (weather_date.year,weather_date.month, weather_date.day, weather_date.hour)
left join warehouse.location 
on
((joint_data.district, joint_data.street, joint_data.neighborhood)) = ((location.current_district_name, location.street, location.neighborhood))
left join warehouse.offense
on 
(joint_data.offense_code, joint_data.offense_code_group, joint_data.offense_description) = (offense.offense_code, offense.offense_code_group, offense.offense_description)
left join warehouse.weather
on 
((joint_data.temperature_level,joint_data.pressure_level,joint_data.humidity_level, joint_data.weather_description)) = ((weather.temperature_level, weather.pressure_level, weather.humidity_level, weather.weather_description))
left join warehouse.lunar_phase
on 
((joint_data.phaseid, joint_data.phase, joint_data.timezone))=((lunar_phase.phaseid, lunar_phase.phase, lunar_phase.timezone))
group by lunar_phase.moon_cycle_id, stage.joint_data.year,stage.joint_data.month,stage.joint_data.hour,stage.joint_data.day, 
weather.weather_record_id,offense.offenseID,stage.joint_data.offense_code,weather_date.weather_date_id, location.location_id,stage.joint_data.district;



select * from warehouse.offense_type_count where moon_cycle_id = 3; -- from here I could aggregate using sums - do not want to loose information by stop relating tables

select count(*) from warehouse.offense_type_count;


-------------------------------------------------- Creating Weather_Facts Fact Table ---------------------------------------------------------------------------------

create table warehouse.weather_facts (weather_facts_id serial primary key, weather_record_id int not null, weather_date_id int not null, offense_id int not null,
pressure numeric, humidity numeric, windspeed numeric, temperature numeric );


select count(*) from warehouse.weather_facts;

insert into warehouse.weather_facts(weather_record_id ,weather_date_id ,offense_id, pressure, humidity, windspeed, temperature )
select distinct on (stage.joint_data.year, stage.joint_data.month, stage.joint_data.day, stage.joint_data.hour) 
weather.weather_record_id, weather_date.weather_date_id, offense.offenseID, stage.joint_data.pressure, 
stage.joint_data.humidity, stage.joint_data.wind_speed , stage.joint_data.temperature
from stage.joint_data 
left join warehouse.weather
on
((joint_data.temperature_level,joint_data.pressure_level,joint_data.humidity_level, joint_data.weather_description)) = ((weather.temperature_level, weather.pressure_level, weather.humidity_level, weather.weather_description))
left join warehouse.offense 
on
((joint_data.offense_code, joint_data.offense_code_group, joint_data.offense_description)) = ((offense.offense_code, offense.offense_code_group, offense.offense_description))
left join warehouse.weather_date
on
(cast(joint_data.year as int),cast(joint_data.month as int),cast(joint_data.day as int),cast(joint_data.hour as int)) =  ((weather_date.year,weather_date.month, weather_date.day, weather_date.hour))
where  weather.weather_record_id is not null
group by stage.joint_data.year, stage.joint_data.month, stage.joint_data.day, stage.joint_data.hour, offense.offenseID, weather.weather_record_id, weather_date.weather_date_id, stage.joint_data.pressure, 
stage.joint_data.humidity, stage.joint_data.wind_speed , stage.joint_data.temperature
;


drop table warehouse.weather_facts;

select offense_id, avg(temperature) from warehouse.weather_facts group by offense_id;
select * from warehouse.weather_facts;
--truncate table warehouse.weather_facts;








--------------- Inline View used for creating first fact table-------------------------------------------

select distinct on (year, month, day, hour) offense.offenseID,
date.dateID, cast(joint_data.year as int), cast(joint_data.month as int), 
cast(joint_data.day as int), cast(joint_data.hour as int), joint_data.latitude, joint_data.longitude, case 
when joint_data.offense_code_group = 'Aggravated Assault' then 3
when joint_data.offense_code_group = 'Aircraft' then 5
when joint_data.offense_code_group = 'Arson' then 4
when joint_data.offense_code_group = 'Assembly or Gathering Violations' then 10
when joint_data.offense_code_group = 'Auto Theft' then 7
when joint_data.offense_code_group = 'Auto Theft Recovery' then 7
when joint_data.offense_code_group = 'Ballistics' then 4
when joint_data.offense_code_group = 'Biological Threat' then 5
when joint_data.offense_code_group = 'Bomb Hoax' then 8
when joint_data.offense_code_group = 'Burglary - No Property Taken' then 8
when joint_data.offense_code_group = 'Commercial Burglary' then 7
when joint_data.offense_code_group = 'Confidence Games' then 9
when joint_data.offense_code_group = 'Counterfeiting' then 8
when joint_data.offense_code_group = 'Drug Violation' then 8
when joint_data.offense_code_group = 'Embezzlement' then 7
when joint_data.offense_code_group = 'Evading Fare' then 10
when joint_data.offense_code_group = 'Explosives' then 3
when joint_data.offense_code_group = 'Fire Related Reports' then 4
when joint_data.offense_code_group = 'Firearm Discovery' then 5
when joint_data.offense_code_group = 'Firearm Violations' then 5
when joint_data.offense_code_group = 'Fraud' then 7
when joint_data.offense_code_group = 'Gambling' then 10
when joint_data.offense_code_group = 'HOME INVASION' then 5
when joint_data.offense_code_group = 'HUMAN TRAFFICKING' then 2
when joint_data.offense_code_group = 'HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE' then 2
when joint_data.offense_code_group = 'Harassment' then 5
when joint_data.offense_code_group = 'Harbor Related Incidents' then 7
when joint_data.offense_code_group = 'Homicide' then 1
when joint_data.offense_code_group = 'INVESTIGATE PERSON' then 7
when joint_data.offense_code_group = 'Investigate Person' then 7
when joint_data.offense_code_group = 'Investigate Property' then 8
when joint_data.offense_code_group = 'Landlord/Tenant Disputes' then 9
when joint_data.offense_code_group = 'Larceny' then 7
when joint_data.offense_code_group = 'Larceny From Motor Vehicle' then 6
when joint_data.offense_code_group = 'License Plate Related Incidents' then 10
when joint_data.offense_code_group = 'License Violation' then 9
when joint_data.offense_code_group = 'Liquor Violation' then 8
when joint_data.offense_code_group = 'Manslaughter' then 4
when joint_data.offense_code_group = 'Medical Assistance' then 4
when joint_data.offense_code_group = 'Missing Person Located' then 4
when joint_data.offense_code_group = 'Missing Person Reported' then 4
when joint_data.offense_code_group = 'Motor Vehicle Accident Response' then 8
when joint_data.offense_code_group = 'Offenses Against Child / Family' then 3
when joint_data.offense_code_group = 'Operating Under the Influence' then 7
when joint_data.offense_code_group = 'Other' then 5
when joint_data.offense_code_group = 'Other Burglary' then 8
when joint_data.offense_code_group = 'Phone Call Complaints' then 9
when joint_data.offense_code_group = 'Police Service Incidents' then 7
when joint_data.offense_code_group = 'Prisoner Related Incidents' then 7
when joint_data.offense_code_group = 'Property Found' then 8
when joint_data.offense_code_group = 'Property Lost' then 8
when joint_data.offense_code_group = 'Property Related Damage' then 8
when joint_data.offense_code_group = 'Prostitution' then 6
when joint_data.offense_code_group = 'Recovered Stolen Property' then 8
when joint_data.offense_code_group = 'Residential Burglary' then 6
when joint_data.offense_code_group = 'Robbery' then 5
when joint_data.offense_code_group = 'Restraining Order Violations' then 7
when joint_data.offense_code_group = 'Search Warrants' then 7
when joint_data.offense_code_group = 'Service' then 9
when joint_data.offense_code_group = 'Simple Assault' then 6
when joint_data.offense_code_group = 'Towed' then 10
when joint_data.offense_code_group = 'Vandalism' then 7
when joint_data.offense_code_group = 'Verbal Disputes' then 9
when joint_data.offense_code_group = 'Violations' then 5
when joint_data.offense_code_group = 'Warrant Arrests' then 6
when joint_data.offense_code_group is null then null end as
seriousness_rank
from stage.joint_data 
left join warehouse.date on
(cast(joint_data.year as int),cast(joint_data.month as int),cast(joint_data.day as int),cast(joint_data.hour as int)) =  (date.year,date.month, date.day, date.hour)
left join warehouse.offense
on 
(joint_data.offense_code,joint_data.offense_description) = (offense.offense_code,offense.offense_description)
;
--- leaving offense_code_group outside of join on because has some nulls derived from select distinct. Also, description and code are more than enough to match dimension


select * from (select joint_data.latitude, joint_data.longitude, 
from stage.joint_data ) a where seriousness_rank is null;


select distinct offense_code_group  from stage.joint_data; 
 
