-- load data
crimes = LOAD '/data/Chicago_Crimes.csv'
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
STORE Q1 INTO 'pigout/Q1' USING PigStorage (',');

-- Q2

-- Q3
A = FILTER crimes BY (primary_type == 'HOMICIDE')
                  AND (arrest == 'True')
                  AND (domestic == 'True');
B = GROUP A ALL;
Q3 = FOREACH B GENERATE COUNT(A);
STORE Q3 INTO 'pigout/Q3' USING PigStorage (',');

-- Q4

-- Q5

-- Q6

-- Q7

-- Q8

-- Q9

-- Q10