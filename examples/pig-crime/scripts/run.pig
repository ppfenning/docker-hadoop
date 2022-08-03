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
DUMP Q1;

-- Q2

-- Q3

A = FILTER crimes BY (primary_type == 'HOMICIDE')
                  AND (arrest == 'True')
                  AND (domestic == 'True');
B = GROUP A ALL;
Q3 = FOREACH B GENERATE COUNT(A);
DUMP Q3;
-- Q4

-- Q5

-- Q6

-- Q7

-- Q8

-- Q9

-- Q10