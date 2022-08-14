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
crimes = FOREACH crimes GENERATE primary_type, arrest, domestic;
crimes = FILTER crimes BY (primary_type == 'HOMICIDE')
                     AND (arrest == 'True')
                     AND (domestic == 'True');
-- problem
x = GROUP crimes ALL;
x = FOREACH x GENERATE COUNT($1) as domestic_homocide_arrests;
STORE x INTO 'hdfs://namenode:9000/pig-out/Q3/' USING PigStorage('\t','-schema');
