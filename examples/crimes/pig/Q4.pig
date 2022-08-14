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
crimes = FOREACH crimes GENERATE primary_type, dow;
crimes = FILTER crimes BY (primary_type == 'THEFT');
-- problem
x = group crimes by dow;
x = FOREACH x GENERATE group as dow, COUNT($1) as cnt;
x = ORDER x BY cnt DESC;
x = LIMIT x 1;
STORE x INTO 'hdfs://namenode:9000/pig-out/Q4/' USING PigStorage('\t','-schema');
