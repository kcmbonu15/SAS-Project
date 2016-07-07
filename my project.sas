libname target '/home/kelexmb247/';

goptions reset=global
         gunit=pct
         hsize= 10.625 in
         vsize= 8.5 in
         htitle=4
         htext=3
         vorigin=0 in
         horigin= 0 in
         cback=white border
         ctext=black 
         colors=(black blue green red yellow)
         ftext=swiss
         lfactor=3;
		

/*Data Contents*/

proc contents data=target.organics;
title 'Organics Data Contents';
run;
/* drop DemCluster and TargetAmt from the new dataset*/
data target.organics (drop=Demcluster TargetAmt);
set target.organics;
run;
/*Plot Historgrams of Continuous Variables to check the distribution for skewness*/
proc univariate data=target.organics noprint;
   histogram Demaffl; 
   title 'histogram for Demaffl';
run;

proc univariate data=target.organics noprint;
   histogram DemAge; 
   title 'histogram for Demage';
run;

proc univariate data=target.organics noprint;
   histogram promspend; 
   title 'histogram for promspend';
run;

proc univariate data=target.organics noprint;
   histogram promtime; 
   title 'histogram for promtime';
run;

/*check for extreme values for numerical variables*/
ODS SELECT EXTREMEVALUES;          
ODS select MissingValues;

PROC UNIVARIATE Data=target.organics NEXTRVAL=10; 
VAR DemAffl DemAge PromSpend PromTime; 
RUN;

/* Create Pie Charts for each nominal variable */
goptions reset=all cback=white border htitle=12pt htext=10pt;
proc gchart data=target.organics;
 pie DemClusterGroup DemGender DemReg DemTVReg PromClass TargetBuy
/ other=0
 value=none
 percent=arrow
 slice=arrow
 noheading
 plabel=(font='Albany AMT/bold' h=1.3 color=depk);
run;
/* Check for the levels in each of the nominal variables */
/*Missing Values for Categorical Variables*/
PROC freq Data=target.organics;
table DemClusterGroup DemGender DemReg DemTVReg PromClass TargetBuy;
RUN;

/*step 3 */
/* Create dummy variables for categorical or nominal variables*/
DATA target.organics;
 set target.organics;
if DemClusterGroup='A' then DemClusterGroup_A=1; else
DemClusterGroup_A = 0;
if DemClusterGroup='B' then DemClusterGroup_B=1; else
DemClusterGroup_B = 0;
if DemClusterGroup='C' then DemClusterGroup_C=1; else
DemClusterGroup_C = 0;
if DemClusterGroup='D' then DemClusterGroup_D=1; else
DemClusterGroup_D = 0;
if DemClusterGroup='E' then DemClusterGroup_E=1; else
DemClusterGroup_E = 0;
if DemClusterGroup='F' then DemClusterGroup_F=1; else
DemClusterGroup_F = 0;
if DemClusterGroup='U' then DemClusterGroup_U=1; else
DemClusterGroup_U = 0;
if DemGender='F' then DemGender_F=1; else DemGender_F = 0;
if DemGender='M' then DemGender_M=1; else DemGender_M = 0;
if DemGender='U' then DemGender_U=1; else DemGender_U = 0;
if DemReg='Midlands' then DemReg_Midlands=1; else DemReg_Midlands = 0;
if DemReg='North' then DemReg_North=1; else DemReg_North = 0;
if DemReg='Scottish' then DemReg_Scottish=1; else DemReg_Scottish = 0;
if DemReg='South East' then DemReg_South_East=1; else
DemReg_South_East = 0;
if DemReg='South West' then DemReg_South_West=1; else
DemReg_South_West = 0;
if DemTVReg='Border' then DemTVReg_Border=1; else DemTVReg_Border = 0;
if DemTVReg='C Scotland' then DemTVReg_C_Scotland=1; ELSE
DemTVReg_C_Scotland = 0;
if DemTVReg='East' then DemTVReg_East=1; else DemTVReg_East = 0;
if DemTVReg='London' then DemTVReg_London=1; else DemTVReg_London = 0;
if DemTVReg='Midlands' then DemTVReg_Midlands=1; else
DemTVReg_Midlands = 0;
if DemTVReg='N East' then DemTVReg_N_East=1; else DemTVReg_N_East = 0;
if DemTVReg='N Scot' then DemTVReg_N_Scot=1; else DemTVReg_N_Scot = 0;
if DemTVReg='N West' then DemTVReg_N_West=1; else DemTVReg_N_West = 0;
if DemTVReg='S & S East' then DemTVReg_S_n_S_East=1; else
DemTVReg_S_n_S_East = 0;
if DemTVReg='S West' then DemTVReg_S_West=1; else DemTVReg_S_West = 0;
if DemTVReg='Ulster' then DemTVReg_Ulster=1; else DemTVReg_Ulster = 0;
if DemTVReg='Wales & West' then DemTVReg_Wales_n_West=1; else
DemTVReg_Wales_n_West = 0;
if DemTVReg='Yorkshire' then DemTVReg_Yorkshire=1; else
DemTVReg_Yorkshire = 0;
if PromClass='Gold' then PromClass_Gold=1; else PromClass_Gold = 0;
if PromClass='Platinum' then PromClass_Platinum=1; else
PromClass_Platinum = 0;
if PromClass='Silver' then PromClass_Silver=1; else PromClass_Silver =
0;
if PromClass='Tin' then PromClass_Tin=1; else PromClass_Tin = 0;
if TargetBuy='n' then TargetBuy_n=1; else TargetBuy_n = 0;
if TargetBuy='y' then TargetBuy_y=1; else TargetBuy_y = 0;
run;

/* Step 4* Missing values for continuous variables*/
proc means data=target.organics mean;
var DemAffl DemAge PromSpend PromTime;
run;

/** You need to do missing value imputation.by replacing missing values with thier means values**/

Data target.organics;
set target.organics;
/** Imputing Interval(Continous) variables with their mean values **/
if missing(DemAffl) then DemAffl = 8.7118323;
if missing(DemAge) then DemAge = 53.7962731;
if missing(PromTime) then PromTime = 6.5646051;

/** Creating new category for missing values in categorical variables */

if missing(DemClusterGroup) then DemClusterGroup_Missing = 1; else
DemClusterGroup_Missing = 0;
if missing(DemGender) then DemGender_Missing = 1; else
DemGender_Missing = 0;
if missing(DemReg) then DemReg_Missing = 1; else DemReg_Missing = 0;
if missing(DemTVReg) then DemTVReg_Missing = 1; else DemTVReg_Missing
= 0;

run;

/*** Step 5 ***/
/*** Creating a randomm sampling of Training and Validation data ***/
data target.ran_60_percent ;
set target.organics;
n=ranuni(12456);
proc sort data=target.ran_60_percent;
 by n ;
 data target.train target.valid;
 set target.ran_60_percent nobs=nobs;
 if _n_<=.6*nobs then output target.train;
 else output target.valid;
 run;
  DATA target.train(DROP = n); set target.train;RUN;
DATA target.valid(DROP = n); set target.valid;RUN;

/*** Step 6 ***/
/** Stepwise logistic regression **/
PROC LOGISTIC DATA= target.train;
MODEL TargetBuy = DemAffl DemAge PromSpend PromTime DemClusterGroup_A
DemClusterGroup_B DemClusterGroup_C
DemClusterGroup_D DemClusterGroup_E
DemClusterGroup_F DemClusterGroup_U
DemGender_F DemGender_M DemGender_U
DemReg_Midlands DemReg_North
DemReg_Scottish DemReg_South_East DemReg_South_West
DemTVReg_Border DemTVReg_C_Scotland
DemTVReg_East DemTVReg_London DemTVReg_Midlands
DemTVReg_N_East DemTVReg_N_Scot
DemTVReg_N_West DemTVReg_S_n_S_East
DemTVReg_S_West DemTVReg_Ulster
DemTVReg_Wales_n_West DemTVReg_Yorkshire
PromClass_Gold PromClass_Platinum
PromClass_Silver PromClass_Tin
DemClusterGroup_Missing DemGender_Missing
DemReg_Missing DemTVReg_Missing/Selection=stepwise;
RUN;
/** Exporting data sets to my folder using the export tab**/
/*** Step 8 ***/
data target.organics; 
set target.organics;
PromSpend_log = log(PromSpend+1); 
PromTime_log = log(PromTime+1);
run;

goptions reset=global 
     gunit=pct  
     hsize= 10.625 in 
     vsize= 8.5 in 
     htitle=4  
     htext=3 
     vorigin=0 in 
     horigin= 0 in 
	cback=white border 
	ctext=black 
	colors=(black blue green red yellow) 
	ftext=swiss 
	lfactor=3;
proc univariate data=target.organics noprint; 
histogram PromSpend_log PromTime_log; 
run;
 
/*** Step 9 ***/
/*** Creating a randomm sampling of Training and Validation data ***/
data target.ran_60_percent ;
set target.organics;
n=ranuni(123456);
proc sort data=target.ran_60_percent;
 by n ;
 data target.train2 target.valid2;
 set target.ran_60_percent nobs=nobs;
 if _n_<=.6*nobs then output target.train2;
 else output target.valid2;
 run;

 DATA target.train2(DROP = n); set target.train2;RUN;
DATA target.valid2(DROP = n); set target.valid2;RUN;

/** Second stepwise logistic regression with transformed varables**/
PROC LOGISTIC DATA= target.train2; 
MODEL TargetBuy = DemAffl DemAge PromSpend_log PromTime_log 
DemClusterGroup_A DemClusterGroup_B DemClusterGroup_C 
DemClusterGroup_D DemClusterGroup_E DemClusterGroup_F 
DemClusterGroup_U DemGender_F DemGender_M DemGender_U
DemReg_Midlands DemReg_North DemReg_Scottish DemReg_South_East 
DemReg_South_West DemTVReg_Border DemTVReg_C_Scotland DemTVReg_East 
DemTVReg_London DemTVReg_Midlands DemTVReg_N_East DemTVReg_N_Scot 
DemTVReg_N_West DemTVReg_S_n_S_East DemTVReg_S_West DemTVReg_Ulster 
DemTVReg_Wales_n_West DemTVReg_Yorkshire PromClass_Gold PromClass_Platinum 
PromClass_Silver PromClass_Tin DemClusterGroup_Missing DemGender_Missing 
DemReg_Missing DemTVReg_Missing/Selection=stepwise;
RUN;

/** Exporting data sets to my folder using the export tab**/

