proc import datafile="/home/u62181646/Stats 521/Project 2/SeatBelts.xls"
dbms=xls out= Seatbelt replace;
run;
/* Importing the Seatbelt data using proc import*/

libname Seatbelt "/home/u62181646/Stats 521/Project 2";
run;
/* A library was created to store the data with the libname step*/

data Seatbelt0;
	set Seatbelt;
proc format;
	Value Speedlimit	1=">=70"
						0="<70";
						
	Value Ageover		1=">=21"
						0="<21";
	
	Value BloodLevel	1="<=0.08%"
						0=">0.08%";
						
	Value Enforcement	1="Primary"
						0="Not Primary";
run;
proc print data=Seatbelt0;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
/* The values of categorical variables were changed to match their
description using proc format and reformatted with the format statement.*/

data Seatbelt1;
	set Seatbelt0;
	label state="State"
		  year="Year"
		  vmt="Traffic Miles/Year"
		  fatalityrate="Fatality Rate"
		  sb_useage="Seat Belt Use"
		  speed70="Speed"
		  drinkage21="Drink Age"
		  income="Income"
		  age="Age"
		  ba08="Blood Alcohol Level"
		  primary="Enforcement";
		  format vmt comma7.;
		  format income dollar8.; 
run;
proc print data=Seatbelt1 label;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
/* Label statement was used to rename column names. Values were adjusted
so that they would have a dollar sign or commas using the format statment.*/

data Seatbelt2;
	set Seatbelt1;
age=round(age,0.1);
fatalityrate=round(fatalityrate,0.001);
run;
proc print data=Seatbelt2 label ;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
/* Values that had to many decimal points were rounded using the
round(variable,how many places).*/

proc sql;
 	CREATE TABLE Highest_fatality as
 	SELECT state,
 		   year,
 		   fatalityrate
 	FROM Seatbelt2
 	GROUP BY state
 	HAVING fatalityrate=max(fatalityrate);
 quit;
/* proc sql was used to filter the dataset to get the highest fatality rate
in each state regardless of year. create table= creates a table that can be used
in data step. select= chooses variables to use. from= gets data from.
group by= step is associated with having step. orders ascending data by 
that variable. Having= finds specific data.*/

proc sort data=Highest_fatality out=Seatbelt3 NODUPKEY;
by state;
run;
/* proc sort was used to eliminate duplicate states with same fatality 
rate from the proc sql table created.*/

proc print data=Seatbelt3 label noobs;
var State Year fatalityrate;
run;

proc sql;
 	CREATE TABLE Seatbelt4 as
 	SELECT *
 	FROM Seatbelt
 	WHERE year >=1990 and SUBSTR(state,1,1)="C";
quit;
 
proc print data=Seatbelt4 noobs;
var state year sb_useage;
run;
/* proc sql was used to select all the data within the parameters 
of the where statement.*/

proc transpose data=Seatbelt4
               out=seatbelt5
               (drop=_label_);
   by state;
   id year;
   var sb_useage;
run;
proc print data=seatbelt5 noobs;
run;
/* proc transpose allowed for the var (sb_useage) to be converted from a
column to a row and changed the column headings to years using the id
statement. by statement included the state variable but it wasnt transposed.*/

proc means maxdec=1 data=Seatbelt2 N Mean STDDEV Max Min NMISS;
var vmt;
run;
proc means data=Seatbelt0 N Mean STDDEV Max Min NMISS;
var fatalityrate;
run;
proc means maxdec=1 data=Seatbelt2 N Mean STDDEV Max Min NMISS;
var sb_useage;
run;
proc means maxdec=1 data=Seatbelt2 N Mean STDDEV Max Min NMISS;
var income;
run;
proc means maxdec=1 data=Seatbelt2 N Mean STDDEV Max Min NMISS;
var age;
run;
/* proc means was used to get statistical information for each numeric
variable.*/

proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class state;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class speed70;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class drinkage21;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class ba08;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class primary;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
/* proc means was used to get statistics of each numeric variables by 
each categorical variables.*/
 
proc univariate data=Seatbelt2 noprint;
histogram vmt;
histogram vmt/kernel;
run;
proc univariate data=Seatbelt2 noprint;
histogram fatalityrate;
histogram fatalityrate/kernel;
run;
proc univariate data=Seatbelt2 noprint;
histogram sb_useage;
histogram sb_useage/kernel;
run;
proc univariate data=Seatbelt2 noprint;
histogram income;
histogram income/kernel;
run;
proc univariate data=Seatbelt2 noprint;
histogram age;
histogram age/kernel;
run;
/* proc univariate step was used to create histograms and density plots
for numeric variables.*/

proc print data=Seatbelt2 label;
var year vmt fatalityrate sb_useage speed70 drinkage21 income age ba08 primary;
ID state;
where sb_useage>0.5 and age>35 and income>28000;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
/* This creates a partial output of a dataset*/

/* ods procedure below outputs results to a pdf document*/

ods pdf file="/home/u62181646/Stats 521/Project 2/Project 2.sas.pdf";
proc means maxdec=1 data=Seatbelt2 N Mean STDDEV Max Min NMISS;
var vmt;
run;
proc means data=Seatbelt0 N Mean STDDEV Max Min NMISS;
var fatalityrate;
run;
proc means maxdec=1 data=Seatbelt2 N Mean STDDEV Max Min NMISS;
var sb_useage;
run;
proc means maxdec=1 data=Seatbelt2 N Mean STDDEV Max Min NMISS;
var income;
run;
proc means maxdec=1 data=Seatbelt2 N Mean STDDEV Max Min NMISS;
var age;
run;

proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class state;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class speed70;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class drinkage21;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class ba08;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
proc means maxdec=1 data=Seatbelt2 N Mean Max Min NMISS ;
var vmt fatalityrate sb_useage income age;
class primary;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;

proc univariate data=Seatbelt2 noprint;
histogram vmt;
histogram vmt/kernel;
run;
proc univariate data=Seatbelt2 noprint;
histogram fatalityrate;
histogram fatalityrate/kernel;
run;
proc univariate data=Seatbelt2 noprint;
histogram sb_useage;
histogram sb_useage/kernel;
run;
proc univariate data=Seatbelt2 noprint;
histogram income;
histogram income/kernel;
run;
proc univariate data=Seatbelt2 noprint;
histogram age;
histogram age/kernel;
run;

proc print data=Seatbelt2 label;
var year vmt fatalityrate sb_useage speed70 drinkage21 income age ba08 primary;
ID state;
where sb_useage>0.5 and age>35 and income>28000;
format speed70 Speedlimit. drinkage21 Ageover. ba08 BloodLevel. 
primary Enforcement.;
run;
ods pdf close;