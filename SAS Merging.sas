
/* Data merging: */

/***************** 1.Concatenation */
data one;
infile cards;
input weeks $ numbers;
cards;
Week1 30
Week2 31
Week3 56
Week4 67
Week5 87
Week6 12
;run;


data two;
infile cards;
input weeks $ numbers;
cards;
Week7 35
Week8 38
Week9 5
Week10 68
Week11 43
Week12 98
;run;

/* concats the data set with the same variables name */
data cnct;
set one two;
run;

/* try changing the variable names to see the results */

/********* 2. Proc Append */
/* Append the observations of one dataset to another dataset to obtain a combined dataset */

/* If PROC APPEND cannot find the BASE=data set, SAS creates it */
/* If a DATA=data set is not specified, SAS uses the most recently created SAS data set */
/* If appending data sets with different variables or attributes, use the FORCE option. 
		 This option must be used to prevent a syntax error */
		
		
proc append base=one data=two Force; /* Force is optional if columns names are same, 
										column order does not matter if column name is same */
run;

proc print data=one;run;

/* changing column name in dataset two to showcase force option */
data three (rename=weeks=weeks1); 
format numbers weeks;
set two;run;
		
proc append base=one data=three Force; 
run;
proc print data=one;run;

/*********** Merging ****/
/*
Merge statement is used to combine the SAS datasets with related data
Always sort the dataset on the key before merging
*/

/* Observations are combined based on their relative position in each data set. 
 Values are overwritten from the second table if placed on same position*/

/* One to One Merging :less frequently used*/
/* Common variable numbers is overwritten in this 
if we had not renamed weeks column in two that would have been overwritten also*/
data four;
merge one two(rename=weeks=weeks1);
run;


/* Match Merging */
/* It combines observations from 2 or more datasets into a a single observation
 into a new dataset according to the values of a common variable */
/* Note: The datasets must be sorted by the variable you want to merge them with.
		The variable you want to use for merging must have same name in both the datasets */
	
	
/* IN= option tells SAS to create a flag that has either the value 0 or 1.
 If the observation does not come from the dataset, 
 then the flag returns 0. If the observation comes from the data set, 
 then the flag returns 1.
 Since the IN= option creates temporary variables,
 we need to create permanent variables so that we can see the flag in the dataset. 
 This is similar to the First. and last. concept */


Data A;
Input ID Name$ Height;
cards;
1 A 1
3 B 2
5 C 2
7 D 2
9 E 2
;
run;
Data B;
Input ID Name$ Weight;
cards;
2 A 2
4 B 3
5 C 4
7 D 5
;
run;

proc sort data = a;
by id;
run;
proc sort data = b;
by id;
run;	

data dummy;      
merge a (in=x) b(in=y);
by id;
a = x; /* optional , just see in the final dataset which records are from dataset a */
b = y; /* optional , just see in the final dataset which records are from dataset b */
run;	


/* If 'BY' Statement is NOT INCLUDED in MERGING? */
/*The BY Statement tells SAS to match records based on the common variable you specify. 
Without the 'BY' statement, it does not perform matching of records as seen in 1 to 1 Merging */



/* Joins */
/* Inner join */

Data dummy_i;
Merge A (IN = X) B (IN=Y);
by ID;
If X and Y;
run;
/* When using IN= option, SAS considers "If X and Y" equivalent to "If X=1 and Y=1". */


/* Left Join (Return all rows from the left table, and the matched rows from the right table) */
Data dummy_l;        
Merge A (IN = X) B (IN=Y);
by ID;
If X ;
run;
/* When you use IN= option, SAS considers "If X" equivalent to "If X=1". We can use either of the If statement. */

/* Full Join (Return all rows from the left table and from the right table) */
Data dummy_full;        
Merge A B;
by ID;
run;
/* Data Step Merge returns all observations from dataset A and B. */


/* Special Cases in merging :One-to-Many Merge  */
/*
 If primary key in both the tables (data sets) have duplicate values, 
 Data Step MERGE statement would return a maximum number of values in both the tables. 
 For example, Table 1 has 3 1's and Table 2 has 2 1's, Data Step Merge would return 3 1's.
*/

data a;
input id name1$ height;
cards;
1 a 1
3 b 2
5 a 2
5 b 3
7 d 2
9 e 2
;
run;
data b;
input id name$ weight;
cards;
2 a 2
4 b 3
5 d 4
5 e 5
5 f 6
7 f 5
;
run;

data c;
merge a (in=x) b(in=y);
by id;
if x;
proc print;
run;

/*
Important Reference : 
https://www.listendata.com/2015/01/sas-merging.html
https://stats.idre.ucla.edu/sas/modules/match-merging-data-files-in-sas/
*/
