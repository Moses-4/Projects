libname College "/home/u62181646/Stats 521/Project 1";
run;
/* Library was created for the project data using the libname command and
 under the name College*/

proc import datafile = "/home/u62181646/Stats 521/Project 1/CollegeDistanceWest.xls" 
DBMS = xls out = CollegeDistanceWest replace ; 
run;
/* The CollegeDistanceWest excel data was imported and renamed using the proc
import procedure.*/

data CollegeDistanceWest0;
	set CollegeDistanceWest;
proc format;
	Value gender		0="Male"
						1="Female";
						
	Value homeowner		0="No"
						1="Yes";
	
	Value urbanarea		0="No"
						1="Yes";
						
	Value highincome	0=">$25,000"
						1="<=$25,000";
run;
proc print data=collegedistancewest0;
format female gender. ownhome homeowner. urban urbanarea. incomehi highincome.;
run;
/* The set satatement was used to work with the exisitng data and data step 
was used to add more to the exisitng data. The Proc format procedure and Value
were used to change the categorical values of 0 and 1 to their actual values. 
A proc print statment was used to print the data I created and the format procedure
formatted the data for the variables to the ones I created in the value step.*/

data CollegeDistanceWest1;
	set CollegeDistanceWest0;
	tuition=compress(tuition,".");
	dist=compress(dist,".");
run;
proc print data=collegedistancewest1;
format female gender. ownhome homeowner. urban urbanarea. incomehi highincome.;
run;
/* A compress function was used so the decimal would be removed of some of the
numeric variables.*/

data CollegeDistanceWest2;
	set CollegeDistanceWest1;
	label female="Gender"
		  bytest="Test Score"
		  ownhome="Home owner"
		  urban="School in Urban Area"
		  stwmfg="State Hourly Wage"
		  dist="Distance From College"
		  tuition="Average state Tuition"
		  ed="Completed School Years"
		  incomehi="Family Income Per Year";
		  format stwmfg dollar6.2;
		  format tuition dollar8.; 
run;
proc print data=collegedistancewest2 label;
format female gender. ownhome homeowner. urban urbanarea. incomehi highincome.;
run;
/* a label statement was used to change the names of the variables and variables
with a money value were formatted using the dollar format.*/ 

proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var bytest;
run;

proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var stwmfg;
run;

proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var dist;
run;

proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var tuition;
run;

proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var ed;
run;
/* proc means statements were ran on each numeric variable to get descriptive 
statistics. The maxdec procedure allowed for just one integer after the 
decimal point.*/

proc freq data=collegedistancewest2;
tables female;
format female gender.;
run;

proc freq data=collegedistancewest2;
tables ownhome;
format ownhome homeowner.;
run;

proc freq data=collegedistancewest2;
tables urban;
format urban urbanarea.;
run;

proc freq data=collegedistancewest2;
tables incomehi;
format incomehi highincome.;
run;

proc freq data=collegedistancewest2;
tables female*ownhome;
format female gender. ownhome homeowner.;
run;
/* one and two way frequency tables were ran on categorical variables using
the proc freq statement. For one way frequency tables, the tables statement
follwed by a single variable were used. For two way frequency tables, two 
variables with an asterik in the middle is used.*/ 

proc univariate data=collegedistancewest2 noprint;
histogram bytest;
histogram bytest/kernel;
run;

proc univariate data=collegedistancewest2 noprint;
histogram stwmfg;
histogram stwmfg/kernel;
run;

proc univariate data=collegedistancewest2 noprint;
histogram dist;
histogram dist/kernel;
run;

proc univariate data=collegedistancewest2 noprint;
histogram tuition;
histogram tuition/kernel;
run;

proc univariate data=collegedistancewest2 noprint;
histogram ed;
histogram ed/kernel;
run;
/* To create histogram and density plots for each numeric variable, the proc
univariate with histogram and histogram/kernel statements were used.*/

proc print data=collegedistancewest2 label;
var bytest ownhome urban stwmfg dist tuition ed incomehi;
ID female;
where stwmfg>10.00 and ed>15 and dist>5;
format female gender. ownhome homeowner. urban urbanarea. incomehi highincome.;
run;
/* A partial output of the finalized data was made by setting parameters
of which data would be displayed.*/

/* Below a ods step was used to export the charts and tables to a microsoft
word document*/
ods rtf file= "/home/u62181646/Stats 521/Project 1/Project 1.sas.rtf" style=EGDefault;
proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var bytest;
run;
proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var stwmfg;
run;
proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var dist;
run;
proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var tuition;
run;
proc means maxdec=1 data=collegedistancewest2 N Mean STDDEV Max Min Range;
var ed;
run;
proc freq data=collegedistancewest2;
tables female;
run;
proc freq data=collegedistancewest2;
tables ownhome ;
run;
proc freq data=collegedistancewest2;
tables urban;
run;
proc freq data=collegedistancewest2;
tables incomehi;
run;
proc freq data=collegedistancewest2;
tables female*ownhome;
run;
proc univariate data=collegedistancewest2 noprint;
histogram bytest;
histogram bytest/kernel;
run;
proc univariate data=collegedistancewest2 noprint;
histogram stwmfg;
histogram stwmfg/kernel;
run;
proc univariate data=collegedistancewest2 noprint;
histogram dist;
histogram dist/kernel;
run;
proc univariate data=collegedistancewest2 noprint;
histogram tuition;
histogram tuition/kernel;
run;
proc univariate data=collegedistancewest2 noprint;
histogram ed;
histogram ed/kernel;
run;
proc print data=collegedistancewest2 label;
var bytest ownhome urban stwmfg dist tuition ed incomehi;
ID female;
where stwmfg>10.00 and ed>15 and dist>5;
format female gender. ownhome homeowner. urban urbanarea. incomehi highincome.;
run;
ods rtf close;