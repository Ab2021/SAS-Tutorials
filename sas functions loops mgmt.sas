/* Using the keyword _NULL_ as the dataset name causes SAS to execute the DATA step */
/*  without writing observations to a dataset */

data _null_; 
Var1 = "Funny Day";
 Var2= "smile";
 Put VAR1 VAR2; run;
 
 
/*  End= option with if condition */
 proc sort data=sashelp.cars(keep=make) nodupkey out=new;
 by make;
 run;
 
/*  The concatenation operator (||) joins character strings */

 data new1(keep= var);
 set new end= isLast;
 if isLast = 1 then var="'"||compress(Make)||"'";
 else var="'"||compress(Make)||"',";
 run;
 
 
/**************  Functions ***********/

/* Character/String Functions */

/* scan fn */
/* The SCAN function returns the nth word of a character value. It is used to extract words from a  */
/* character value when the relative order of words is known, but their starting positions are not. */
/* Extract first name and last name from name */
data xyz(drop=name);
format first_nm last_nm;
 set sashelp.baseball;
 first_nm=compress(scan(Name,2,','));
 last_nm=compress(scan(Name,1,','));
 run;
 
/* Example 2: Finding All Words in a String */

data all;
   length word $20;
   drop string;
   string = ' The quick brown fox jumps over the lazy dog.   ';
   do until(word=' ');
      count+1;
      word = scan(string, count);
      output;
   end;
run;
/* The SUBSTR function is used to extract substring for string or replace characters in a string */
data xyz;
 set sashelp.baseball;
div_abr=substr(division,1,2);
 run;



/* CAT Function */
/* Does not remove leading or trailing blanks, and returns a concatenated character string. */
data _null_;
   x='  The 2002 Olym'; 
   y='pic Arts Festi';
   z='  val included works by D  ';
   a='ale Chihuly.';
   result=cat(x,y,z,a);
   put result $char.; 
run;


/* CATS Function */
/* Removes leading and trailing blanks, and returns a concatenated character string. */
/* 	CATT Function */
/* Removes trailing blanks, and returns a concatenated character string. */
/* 	CATX Function */
/* Removes leading and trailing blanks, inserts delimiters, and returns a concatenated character string. */

/*
Function	Equivalent Code
CAT(OF X1-X4)	X1||X2||X3||X4
CATS(OF X1-X4)	TRIM(LEFT(X1))||TRIM(LEFT(X2))||TRIM(LEFT(X3))||
TRIM(LEFT(X4))
CATT(OF X1-X4)	TRIM(X1)||TRIM(X2)||TRIM(X3)||TRIM(X4)
CATX(SP, OF X1-X4)	TRIM(LEFT(X1))||SP||TRIM(LEFT(X2))||SP||
TRIM(LEFT(X3))||SP||TRIM(LEFT(X4))
*/

data _null_;
   separator='%%$%%';
   x='The Olympic  '; 
   y='   Arts Festival ';
   z='   includes works by ';
   a='Dale Chihuly.';
   result=catx(separator,x,y,z,a);
   put result $char.; 
run;


/* COMPRESS Function */
/* Returns a character string with specified characters removed from the original string. */

/* LEFT Function */
/* Left-aligns a character string. */

/* TRIM Function */
/* Removes trailing blanks from a character string, and returns one blank if the string is missing. */

/* COMPBL Function */
/* Removes multiple blanks from a character string. */
data _null_;
string='125    E Main St';
length address $10;
address=compbl(string);
put address;	/*O/p: 125 E Main */
run;


/*
FIND Function
Searches for a specific substring of characters within a character string.
The FIND function searches string for the first occurrence of the specified substring,
 and returns the position of that substring. If the substring is not found in string, FIND returns a value of 0.
Comparisons
•	The FIND function searches for substrings of characters in a character string, whereas the FINDC function searches for individual characters in a character string.
•	The FIND function and the INDEX function both search for substrings of characters in a character string. However, the INDEX function does not have the modifiers nor the startpos arguments.

*/

/*
INDEX Function
Searches a character expression for a string of characters, and returns the position of the string's
first character for the first occurrence of the string.
INDEX(source,excerpt)
Tip:	Enclose a literal string of characters in quotation marks.
Tip:	Both leading and trailing spaces are considered part of the excerpt argument. To remove trailing spaces, include the TRIM function with the excerpt variable inside the INDEX function.
*/

data _null_;
   length a b $14;
   a='ABC.DEF (X=Y)';
   b='X=Y';
   q=index(a,b);
   w=index(a,trim(b));
   put q= w=;
run;

/* SAS writes the following output to the log: */
/* q=0 w=10 */

/* LENGTH Function */
/* Returns the length of a non-blank character string, 
excluding trailing blanks, and returns 1 for a blank character string. */

/* LOWCASE Function */
/* Converts all letters in an argument to lowercase. */
/* In a DATA step, if the LOWCASE function returns a value to a variable that has not
 previously been assigned a length, then that variable is given the length of the argument. */

/* UPCASE Function */
/* Converts all letters in an argument to uppercase. */

/* PROPCASE Function */
/* Converts all words in an argument to proper case. */
/* The PROPCASE function copies a character argument and converts all uppercase letters to lowercase letters. It then converts to uppercase the first character of a word that is preceded by a blank, 
forward slash, hyphen, open parenthesis, period, or tab. PROPCASE returns the value that is altered. */

data _null_;
   input place $ 1-40;
   name=propcase(place);
   put name;
   datalines;
INTRODUCTION TO THE SCIENCE OF ASTRONOMY
VIRGIN ISLANDS (U.S.)
SAINT KITTS/NEVIS
WINSTON-SALEM, N.C.
;

run;

/* SAS writes the following output to the log: */
/* Introduction To The Science Of Astronomy */
/* Virgin Islands (U.S.) */
/* Saint Kitts/Nevis */
/* Winston-Salem, N.C. */


/* STRIP Function */
/* Returns a character string with all leading and trailing blanks removed. */

/* Comparisons */
/* The following list compares the STRIP function with the TRIM function: */
/* •	For strings that are blank, the STRIP function return a string with a length of zero, whereas the TRIM function returns a single blank. */
/* •	For strings that lack leading blanks but have at least one non-blank character, the STRIP and TRIM functions return the same value. */

data lengthn;
   input string $char8.;
   original = '*' || string || '*';
   stripped = '*' || strip(string) || '*';
   datalines;
abcd
 abcd
  abcd
    abcdefgh
x y z
;
run;

proc print data=lengthn;
run;

/* TRIM Function */
/* Removes trailing blanks from a character string, and returns one blank if the string is missing. */
/* If the argument is blank, TRIM returns one blank. */


/* TRANSLATE Function */
/* Replaces specific characters in a character string. */
/* In a DATA step, if the TRANSLATE function returns a value to a variable that has not
 previously been assigned a length, then that variable is given the length of the first argument */

data _null_;
x=translate('XYZVW','AB','VW');
put x;	 
run;

/* TRANWRD Function */
/* Replaces all occurrences of a substring in a character string. */
/* The TRANWRD function replaces all occurrences of a given substring within a character string. The TRANWRD function does not remove trailing blanks in the target string and the replacement string. */

/* Comparisons :
 The TRANSLATE function converts every occurrence of a user-supplied character to another character.
 TRANSLATE can scan for more than one character in a single call. In doing this scan, however, 
 TRANSLATE searches for every occurrence of any of the individual characters within a string. 
 That is, if any letter (or character) in the target string is found in the source string, 
 it is replaced with the corresponding letter (or character) in the replacement string. */

/* The TRANWRD function differs from TRANSLATE in that TRANWRD scans for substrings 
and replaces those substrings with a second substring. */


/* eg:

name=tranwrd(name, "Mrs.", "Ms.");
name=tranwrd(name, "Miss", "Ms.");
put name;

Values	Results
Mrs.  Joan Smith	Ms.  Joan Smith
Miss Alice Cooper	Ms. Alice Cooper 

*/

/* Removing Repeated Commas */

data _null_;
   mytxt='If you exercise your power to vote,,,then your opinion will be heard,,';
   newtext=tranwrd(mytxt, ',,,', ',');
   newtext2=tranwrd(newtext, ',,' , '.');
   put // mytxt= / newtext= / newtext2=;
run;


/*** 	Date and Time Functions: ***/

/* DATEPART Function */
/* Extracts the date from a SAS datetime value. */

data _null_;
conn='01feb94:8:45'dt;
servdate=datepart(conn);
put servdate worddate.;	 
run;



/* DAY Function */
/* Returns the day of the month from a SAS date value. */

data _null_;
now='05may97'd;
d=day(now);
put d;	 
run;


/* MONTH Function */
/* Returns the month from a SAS date value. */
data _null_;
date='25jan94'd;
m=month(date);
put m;	 
run;


/* YEAR Function */
/* Returns the year from a SAS date value. */

data _null_;
date='25dec97'd;
y=year(date);
put y;	
run;



/* INTCK Function */
/* Returns the count of the number of interval boundaries between two dates, two times, or two datetime values. */

/* INTCK(interval, start-from, increment) */

/* Types of intervals: 
http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a003065889.htm#a003065892 
*/

data _null_;
qtr=intck('qtr','10jan95'd,'01jul95'd);
put qtr;	 
run;
data _null_;
year=intck('year','31dec94'd,
     '01jan95'd);
put year;	 
run;
data _null_;
year=intck('year','01jan94'd,
     '31dec94'd);
put year;	 
run;
data _null_;
semi=intck('semiyear','01jan95'd,
     '01jan98'd);
put semi;
run;	 
data _null_;
weekvar=intck('week2.2','01jan97'd,
     '31mar97'd);
put weekvar;	 
run;

data _null_;
wdvar=intck('weekday7w','01jan97'd,
     '01feb97'd);
put wdvar;	 
run;
data _null_;
y='year';
date1='1sep1991'd;
date2='1sep2001'd;
newyears=intck(y,date1,date2);
put newyears;	
run;

data _null_;
y=trim('year     ');
date1='1sep1991'd + 300;
date2='1sep2001'd - 300;
newyears=intck(y,date1,date2);
put newyears;	
run;


/* DATDIF Function */
/* Returns the number of days between two dates after 
computing the difference between the dates according to specified day count conventions. */


/* YRDIF Function */
/* Returns the difference in years between two dates. */

/* INTNX Function */
/* Increments a date, time, or datetime value by a given time interval, and returns a date, time, or datetime value. */
/* INTNX(interval, start-from, increment ,'alignment') */

	/* parameters definition */
	/* 'alignment' */
	/* controls the position of SAS dates within the interval.
 	You must enclose alignment in quotation marks. Alignment can be one of these values: */

	/* BEGINNING B */
	/* specifies that the returned date or datetime value is aligned to the beginning of the interval. */

	/* 	MIDDLE M */
	/* specifies that the returned date or datetime value is aligned to the midpoint of the interval, 
	which is the average of the beginning and ending alignment values. */
	
	/* 	END E */
	/* specifies that the returned date or datetime value is aligned to the end of the interval. */
	
	/* 	SAME */
	/* specifies that the date that is returned has the same alignment as the input date. */


/*
 Types of intervals: 
 http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a003065889.htm#a003065892 
 */
data _null_;
x=intnx('week', '17oct03'd, 6);
put x date9.;
run;
/* INTNX returns the value 23NOV2003. */

data _null_;
intnx('week', '15mar2000'd, 1, 'same');         
intnx('dtweek', '15mar2000:8:45'dt, 1, 'same'); /* returns 22MAR00:08:45:00 */
intnx('year', '15mar2000'd, 5, 'same');        
run;

data _null_;
date1=intnx('month','01jan95'd,5,'beginning');
put date1 / date1 date7.;	
run; 
data _null_;
date2=intnx('month','01jan95'd,5,'middle');
put date2 / date2 date7.;
run;	 
data _null_;
date3=intnx('month','01jan95'd,5,'end');
put date3 / date3 date7.;	 
run;	 
data _null_;
date4=intnx('month','01jan95'd,5,'sameday');
put date4 / date4 date7.;	 
run;	 
data _null_;
date5=intnx('month','15mar2000'd,5,'same');
put date5 / date5 date9.;	 
run;	 
data _null_;
interval='month';
date='1sep2001'd;
align='m';
date4=intnx(interval,date,2,align);
put date4 / date4 date7.;	
run;	 
data _null_;
x1='month     ';
x2=trim(x1);
date='1sep2001'd + 90;
date5=intnx(x2,date,2,'m');
put date5 / date5 date7.;	
run;	 



/* Conversion Functions: */
/* PUT Function */
/* Returns a value using a specified format. */
/* Use PUT to convert a numeric value to a character value. You cannot use the PUT function
 to change the type of a variable in a data set from numeric to character. */

/* Using PUT and INPUT Functions */
data _null_;
numdate=122591;
chardate=put(numdate,z6.);
sasdate=input(chardate,mmddyy6.);
put chardate sasdate;
run;

/* INPUT Function */
/* The INPUT function enables you to convert the value of source by using a specified informat. The informat determines whether the result is numeric or character.
 Use INPUT to convert character values to numeric values or other character values. */


/* LAG Function */
/* Returns values from a queue. */
data one;
   input x @@;
   y=lag1(x);
   z=lag2(x);
   datalines;
1 2 3 4 5 6
;
run;

proc print data=one;
   title 'LAG Output';
run;

/* Generating Multiple Lagged Values in BY-Groups */
data old;
  input start end;
datalines;
1 1
1 2
1 3
1 4
1 5
1 6
1 7
2 1
2 2
3 1
3 2
3 3
3 4
3 5
;
run;
data new(drop=i count);
  set old;
  by start;

  /* Create and assign values to three new variables.  Use ENDLAG1-      */
  /* ENDLAG3 to store lagged values of END, from the most recent to the  */
  /* third preceding value.                                              */   
  array x(*) endlag1-endlag3;
  endlag1=lag1(end);
  endlag2=lag2(end);
  endlag3=lag3(end);

  /* Reset COUNT at the start of each new BY-Group */
  if first.start then count=1;

  /* On each iteration, set to missing array elements   */
  /* that have not yet received a lagged value for the  */
  /* current BY-Group.  Increase count by 1.            */   
  do i=count to dim(x);
    x(i)=.;
  end;
  count + 1;
run;


/* Retain Statements */
/* The RETAIN statement simply copies retaining values by telling
 the SAS not to reset the variables to missing at the beginning of each iteration of the DATA step.
 If you would not use retain statement then SAS would return missing at the beginning of each iteration. */

/* The retain statement keeps the value once assigned. */

data abcd;
input x y;
cards;
1 25
1 28
1 27
2 23
2 35
2 34
3 25
3 29
;
run;

/* Example 1:
Cumulative Score

Suppose you need to calculate cumulative score. 
In financial data, we generally need to calculate cumulative score year to date.
*/
data aaa;
set abcd;
retain z 0;
z = z + y;
run;
/* Example 2:
Generate Serial Number by Group
Suppose you have a grouping variable say "region" and you need to generate a row index number by region.
*/

proc sort data = abcd;
by x;
run;

data aaa;
set abcd;
retain z;
if first.x then z = 1;
else z = z + 1;
by x;
run;

/******** DO LOOPS : 

There are four forms of the DO statement:
1.	The DO statement designates a group of statements that are to be executed as a unit, usually as a part of IF-THEN/ELSE statements.

*/
data _null_;
years=10;

if years>5 then
  do;
    months=years*12;
    put years= months=;
  end;
run;
/*
2.	The iterative DO statement executes a group of statements repetitively based on the value of an index variable. If you specify an UNTIL clause or a WHILE clause, then the execution of the statements is also based on the condition that you specify in the clause.
The iterative DO loop executes the statements between DO and END repetitively based on the value of an index variable.
DO index-variable = start TO stop <BY increment>;
*/
data _null_;
k=18; n=11;
do i=k+2 to n-1 by -2;
   put i;
end;
run;
/*
		The following example uses an UNTIL clause to set a flag, and then it checks the flag during each iteration of the loop:
flag=0;
do i=1 to 10 until(flag);
  ...SAS statements...
  if expression then flag=1;
end;
The following loop executes as long as I is within the range of 10 to 0 and MONTH is equal to JAN.
do i=10 to 0 by -1 while(month='JAN');
   ...SAS statements...
end;

3.	The DO UNTIL statement executes a group of statements repetitively until the condition that you specify is true. The condition is checked after each iteration of the loop.
n=0;*/
data _null_;
do while(n<5);
  put n=;
  n+1;
end;
run;
/*
4.	The DO WHILE statement executes a group of statements repetitively as long as the condition that you specify remains true. The condition is checked before each iteration of the loop.
*/
data _null_;
n=0;
do until(n>=5);
  put n=;
  n+1;
end;
run;
/*
Example 1: Using Various Forms of the Iterative DO Statement
•	These iterative DO statements use a list of items for the value of start:
•	do month='JAN','FEB','MAR';
•	do count=2,3,5,7,11,13,17;
•	do i=5;
•	do i=var1, var2, var3;
•	do i='01JAN2001'd,'25FEB2001'd,'18APR2001'd;
•	These iterative DO statements use the start TO stop syntax:
•	do i=1 to 10;
•	do i=1 to exit;
•	do i=1 to x-5;
•	do i=1 to k-1, k+1 to n;
•	do i=k+1 to n-1;
•	These iterative DO statements use the BY increment syntax:
•	do i=n to 1 by -1;
•	do i=.1 to .9 by .1, 1 to 10 by 1,
•	   20 to 100 by 10;
•	do count=2 to 8 by 2;
•	These iterative DO statements use WHILE and UNTIL clauses:
•	do i=1 to 10 while(x<y);
•	do i=2 to 20 by 2 until((x/3)>y);
•	do i=10 to 0 by -1 while(month='JAN');
•	In this example, the DO loop is executed when I=1 and I=2; the WHILE condition is evaluated when I=3, and the DO loop is executed if the WHILE condition is true.
DO I=1,2,3 WHILE (condition);

Controlling DO Loops:

The LEAVE statement stops processing the current DO loop and resumes with the next statement after the DO loop. With the LEAVE statement, you have the option of specifying a label for the DO statement:

do i=1 to n by m;
   ...more SAS statements... 
   if i=10 then leave;
end;
if i=10 then put 'EXITED LOOP';
*/


/* If you have nested DO loops and you want to skip out of more than one loop, you can specify the label of the loop that you want to leave. 
For example, the following LEAVE statement causes execution to skip to the last PUT statement: */

data _null_; 
do i=1 to 10;
  do j=1 to 10;
    if j=5 
    then do; 
    	leave ; 
    end;
    put i= j=;
  end;
end;
put 'this statement executes next';
return;
run;

