/*********************** Data Access Steps *****************/

/* SAS reads data line by line while reading from input file */
/* We can Create data in the the datastep itself either by using datalines or cards statement */


/* Multiple lines input */

Data Address;
length Lname FName $ 20
City $ 25 State $2
Phone $8 ;
infile datalines dlm=',';
input Lname $ FName $ ;
input City $ State $ ; input Phone $;
datalines;
Farr, Sue 
Anaheim, CA 
869-7008 
Anderson, Kay B. 
Chicago, IL 
483-3321 
Tennenbaum, Mary Ann 
Jefferson, MO 
589-9030
;
run;

/* Mixed Record Types */
/* single trailing allows sas to operate on data while reading in the input buffer */
/* use case of datalines and Single trailing */
data abc;
 length city number $16. minutes charge 8;
 infile datalines firstobs=2 _infile_=phonebuff;
 input @; /*  in this case of single trailing, SAS holds all of input line data, operates to compress the data to remove '<>' */
/*  input city number @; *//*  in this case of single trailing, SAS holds only city and number columns of input line data, operates on rest of data */
 _infile_ = compress(phonebuff, '<>');
  input city number minutes charge;
  /* input minutes charge; */ /*  This will change as per the number of columns are held initially */
 put city= number= minutes= charge=;
datalines;
City Number Minutes Charge
Jackson 415-555-2384 <25> <2.45>
Jefferson 813-555-2356 <15> <1.62>
Joliet 913-555-3223 <65> <10.32>
;/* This semi colon must be placed belo the last data only, as the last data may not be properly read by SAS */
run;

/* READING PAST THE END OF A LINE */
/* By default, if the INPUT statement tries to read past the end of the current input data record, it then moves the input */
/* pointer to column 1 of the next record to read the remaining values. This default behavior is governed by the */
/* "FLOWOVER" option and a message is written to the SAS log. This is useful in reading data that flows over into */
/* several lines of input. */
/* Example: Read a file of pet names and 6 readings per animal. */
data readings;
 infile datalines;
 input Name $ R1-R6;/*  R1-R6 is amethod of defining variable like an array */
 datalines;
Gus 22 44 55
33 32 14
Gaia 24 22 23
31 76 31
;
run;
/********** Steps to Import an XLSX or CSV or TXT file *****************/


/* https://blogs.sas.com/content/sgf/2020/03/10/accessing-excel-files-using-libname-xlsx/ */
/******* First step: ***********/
/* Importing excel files placed on unix using Libname & XLSX engine */

libname abc XLSX "/home/abhishek200219940/sasuser.v94/multi_sheet.xlsx";

proc print data=abc.sheet2(obs=10);/* Take sample 10rows */
run;

/* creates a dataset 'test' in work library from the sheet 2 of the file*/
data test;
set abc.sheet2;
run;
/* proc contnets descibes the dataset properties i.e. column attributes, no of obsevations */
/* , create date etc. */
proc contents data=test 
out=test2 /* {optional} 'out=' will create a new dataset named test2, 
else the proc content will only be displayed on results window */
;
run;



/********** 2nd Step *********/
/* https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/proc/n18jyszn33umngn14czw2qfw7thc.htm  */
/* Proc Import step mostly used in our programs */

proc import datafile= "/home/abhishek200219940/sasuser.v94/multi_sheet.xlsx"
out=Imp_sas
dbms=XLSX /* depends on file type */
replace;/*{optional} will replace the dataset 'Imp_sas', if already resent */
sheet="Sheet2"; /* Sheet to be selected in case of multiple sheets present */
getnames=yes; /* gets the name of column headers when set to "Yes" */
datarow=10;/*{optional} sets the row from which records are to be fetched */
run;

/* importing csv file */
proc import datafile="/home/abhishek200219940/sasuser.v94/datafile.csv.csv"
out= two_imp
dbms=csv
replace;
run;

/* Through filename statement , although less frequently used and formats needs to be verified and defined*/
filename stdata "/home/abhishek200219940/sasuser.v94/datafile.csv.csv" lrecl=200;
/* lrecl defines the max width(number of characters in a line), sas can read */
proc import datafile=stdata
        dbms=dlm
        out=datafile
        replace;
     delimiter=','; /*  as this is an csv file , we use delimiter as ',' */
     getnames=yes;
run;

/********* 3rd Step *********/
/* File informats and formats have to be explicitly defined,  */
/* as number of variable/columns increase  , the task becomes difficult, */
/* can be use for smaller variable files */
data a;
 infile '/home/abhishek200219940/sasuser.v94/datafile.csv.csv' dlm=',' dsd truncover;
 input year_financial :$9. GPP :8. ;
run;

/******************* Exporting DATA into XLSX,CSV,txt *****/

/* Proc Export */
/* https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/proc/n0ku4pxzx3d2len10ozjgyjbrpl9.htm */
/* Similar in function to Proc import with some options being different */

proc export data= datafile
outfile= "/home/abhishek200219940/sasuser.v94/datafil1.xlsx"
dbms=XLSX REPLACE;
Sheet="New";/* creates a sheet "New", or may overwrite if already present */
Putnames=yes;/* put headers into output file */
run;

/* Exporting files using filename statement, can be used for .txt type of files */
/* Seldomly used */
filename phonebk2 "/home/abhishek200219940/sasuser.v94/abc26.txt";
data _null_;
 file phonebk2;
 input line $80.;
 put line;
 datalines;
E00973 1400 E09872 2003 E73150 2400 
E45671 4500 E34805 1980
;
run;
/* output */
/* NOTE: The file PHONEBK2 is: */
/*        Filename=/home/abhishek200219940/sasuser.v94/abc26.txt, */
/*        Owner Name=abhishek200219940,Group Name=oda, */
/*        Access Permission=-rw-r--r--, */
/*        Last Modified=28May2021:12:16:27 */

/* Renaming Multiple columns */
/* Syntax: dataset(Rename= (Old_name_variable1 = new_name_variable1 Old_name_variable2= new_name_variable2)) */
data test;
set abc.sheet2 (RENAME = (Team = Team_Name nError= Error_n));
run;

