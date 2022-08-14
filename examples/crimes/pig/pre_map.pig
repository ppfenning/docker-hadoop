-- load data
crimes = LOAD 'hdfs://namenode:9000/data/Chicago_Crimes.csv'
using org.apache.pig.piggybank.storage.CSVExcelStorage()
as (
	num:int,
	id:chararray,
	case_number:chararray,
	date:chararray,
	block:chararray,
	iucr:chararray,
	primary_type:chararray,
	description:chararray,
	location_description:chararray,
	arrest:chararray,
	domestic:chararray,
	beat:chararray,
	district:float,
	ward:float,
	community_area:float,
	fbi_code:chararray,
	x_coordinate:chararray,
	y_coordinate:chararray,
	year:int,
	updated_on:chararray,
	latitude:float,
	longitude:float
);
-- skip header
crimes = FILTER crimes by $0>1;
-- datetime
crimes = FOREACH crimes GENERATE *, ToDate(date, 'MM/dd/yyyy hh:mm:ss a') as date_time:DateTime;
-- get month, day, hr, min (have year)
crimes = FOREACH crimes GENERATE *,
                                 GetMonth(date_time) as month,
                                 GetDay(date_time) as day,
                                 GetHour(date_time) as hr,
                                 GetMinute(date_time) as min
                                 ;
-- date time parts
crimes =  FOREACH crimes GENERATE *,
                                  ToDate(CONCAT((chararray)year,'-', (chararray)month,'-',(chararray)day), 'yyyy-MM-dd') as cal_date,
                                  ToDate(CONCAT((chararray)hr,':', (chararray)min), 'HH:mm') as time;
crimes = FOREACH crimes GENERATE *,
                                 ToString( cal_date, 'EEE' ) as DOW;
-- store for later
STORE crimes INTO 'hdfs://namenode:9000/pig-in/crimes/' USING PigStorage (',');
