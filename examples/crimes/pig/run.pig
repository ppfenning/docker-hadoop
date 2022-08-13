crimes = LOAD 'hdfs://namenode:9000/pig-in/crimes/part-*'
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
	longitude:float,
	location:chararray
);

-- Q1
A = GROUP crimes BY primary_type;
B = FOREACH A GENERATE group as primary_type,COUNT($1) as cnt;
C = ORDER B BY cnt DESC;
Q1 = LIMIT C 1;
STORE Q1 INTO 'hdfs://namenode:9000/pig-out/Q1/' USING PigStorage('\t','-schema');

-- Q2
A = FOREACH crimes GENERATE district,
                            ToDate(date, 'MM/dd/yyyy hh:mm:ss a') as date_time:DateTime;
B = FOREACH A GENERATE district,
                       date_time,
                       GetHour(date_time) as dt_hr:int,
                       GetMinute(date_time) as dt_min:int;
C = GROUP B BY district;
Q2 = FOREACH C GENERATE group as district,
                        AVG(B.dt_hr) as avg_hr:int,
                        AVG(B.dt_min) as avg_min:int;
--STORE Q2 INTO 'hdfs://namenode:9000/pig-out/Q2/' USING PigStorage('\t','-schema');

-- Q3
A = FILTER crimes BY (primary_type == 'HOMICIDE')
                  AND (arrest == 'True')
                  AND (domestic == 'True');
B = GROUP A ALL;
Q3 = FOREACH B GENERATE COUNT(A);
STORE Q3 INTO 'hdfs://namenode:9000/pig-out/Q3/' USING PigStorage('\t','-schema');

-- Q4

-- Q5

-- Q6

-- Q7

-- Q8

-- Q9

-- Q10