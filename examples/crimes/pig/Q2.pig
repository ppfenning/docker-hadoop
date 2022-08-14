crimes = LOAD 'hdfs://namenode:9000/pig-in/crimes/part-*'
using org.apache.pig.piggybank.storage.CSVExcelStorage()
as (
	num:int,
	id:chararray,
	case_number:chararray,
	date_string:chararray,
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
	longitude:float,
    date_time:DateTime,
	month:int,
    day:int,
    hr:int,
    min:int,
    cal_date:DateTime,
    time:DateTime,
    dow:chararray
);

-- get needed columns
crimes = FOREACH crimes GENERATE district, hr, min;
crimes = FILTER crimes BY district is not null
                       AND hr < 24
                       AND min < 60;
-- problem
x = GROUP crimes BY district;
x = FOREACH x GENERATE group as district,
                                FLOOR(AVG(crimes.hr)) as avg_hr,
                                FLOOR(AVG(crimes.min)) as avg_min;
x = FOREACH x GENERATE district,
                       ToDate(CONCAT((chararray)avg_hr, ':', (chararray)avg_min), 'HH:mm') as avg_time;
x = FOREACH x GENERATE district,
                       ToString(avg_time, 'HH:mm') as avg_time;
x = ORDER x BY district;
STORE x INTO 'hdfs://namenode:9000/pig-out/Q2/' USING PigStorage('\t','-schema');
