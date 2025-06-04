libname dane "C:\Users\antek\analiza_czasu_trwania\ProjektACT";

proc means data=dane.hr_analytics n min max mean median p25 p75;
   var MonthlyIncome;
run;

data dane.hr_analytics;
    set dane.hr_analytics;
    if MonthlyIncome <= 2911 then Income_group = 1;               /* Low income */
    else if 2912 <= MonthlyIncome <= 8380 then Income_group = 2; /* Medium income */
    else if MonthlyIncome >= 8381 then Income_group = 3;         /* High income */
run;
data dane.Final_data;
    set dane.hr_analytics;
run;



proc means data=dane.hr_analytics;
var Age; 
run;


data dane.hr_analytics;
set dane.hr_analytics;
if Age < 30 then Age_group = 1;          /* Young employees */
else if 30 <= Age < 45 then Age_group = 2;  /* Middle-aged employees */
else if Age >= 45 then Age_group = 3;     /* Older employees */
run;

/* Update Final_data with the new age groups */
data dane.Final_data;
    set dane.hr_analytics;
run;

/* test on age_Group */
proc phreg data=dane.Final_data;
class Age_group;
model YearsAtCompany*Attrition(0)= Age_group / ties=efron;
run;


proc means data=dane.hr_analytics min max mean median;
var YearsAtCompany; 
run;



/* Update Final_data with the new groups */
data dane.Final_data;
    set dane.hr_analytics;
run;


proc means data=dane.hr_analytics min max mean median;
var NumCompaniesWorked;
run;

data dane.hr_analytics;
set dane.hr_analytics;
if NumCompaniesWorked <= 1 then NumCompaniesWorked_group = 1;      /* Limited experience */
else if 2 <= NumCompaniesWorked <= 4 then NumCompaniesWorked_group = 2;  /* Typical range */
else if NumCompaniesWorked >= 5 then NumCompaniesWorked_group = 3;       /* High mobility */
run;

data dane.Final_data;
    set dane.hr_analytics;
run;


/* all variables */
/* Age_group BusinessTravel_p YearsWithCurrManager_przedzialy YSLP_przedzialy YearsInCurrentRole_przedzialy */
/*       TotalWorkingYears_przedzialy PercentSalaryHike_przedzialy DistanceFromHome_przedzialy   */
/*       WorkLifeBalance TrainingTimesLastYear StockOptionLevel RelationshipSatisfaction */
/*       PerformanceRating OverTime NumCompaniesWorked_group MonthlyRate Income_group MaritalStatus */
/*       JobSatisfaction JobLevel JobInvolvement HourlyRate Gender EnvironmentSatisfaction */
/*       Education */


proc phreg data=dane.Final_data;
class Age_group BusinessTravel_p YearsWithCurrManager_przedzialy YSLP_przedzialy YearsInCurrentRole_przedzialy
      TotalWorkingYears_przedzialy PercentSalaryHike_przedzialy DistanceFromHome_przedzialy Income_group 
      WorkLifeBalance TrainingTimesLastYear TotalWorkingYears StockOptionLevel RelationshipSatisfaction
      PerformanceRating OverTime NumCompaniesWorked_group MaritalStatus JobSatisfaction JobLevel JobInvolvement Gender EnvironmentSatisfaction/ param=ref ref=first;
model YearsAtCompany*Attrition(0)= Age_group BusinessTravel_p YearsWithCurrManager_przedzialy YSLP_przedzialy YearsInCurrentRole_przedzialy
      TotalWorkingYears_przedzialy PercentSalaryHike_przedzialy DistanceFromHome_przedzialy 
      WorkLifeBalance TrainingTimesLastYear StockOptionLevel RelationshipSatisfaction
      PerformanceRating OverTime NumCompaniesWorked_group MonthlyRate Income_group MaritalStatus
      JobSatisfaction JobLevel JobInvolvement HourlyRate Gender EnvironmentSatisfaction
      Education / ties=efron;
run;

/* variables to keep based on p value /
Age_group 
BusinessTravel_p 
YearsWithCurrManager_przedzialy 
YearsInCurrentRole_przedzialy 
TotalWorkingYears_przedzialy 
DistanceFromHome_przedzialy 
WorkLifeBalance 
TrainingTimesLastYear 
StockOptionLevel 
RelationshipSatisfaction 
OverTime 
NumCompaniesWorked_group 
Income_group 
JobSatisfaction 
JobLevel 
JobInvolvement 
Gender 
/* EnvironmentSatisfaction  */

proc phreg data=dane.Final_data;
   class Age_group BusinessTravel_p YearsWithCurrManager_przedzialy 
         YearsInCurrentRole_przedzialy TotalWorkingYears_przedzialy 
         DistanceFromHome_przedzialy WorkLifeBalance StockOptionLevel 
         RelationshipSatisfaction OverTime NumCompaniesWorked_group 
         JobSatisfaction JobLevel JobInvolvement EnvironmentSatisfaction 
         Gender Income_group / param=ref ref=first;
   
   model YearsAtCompany*Attrition(0) = 
         Age_group BusinessTravel_p YearsWithCurrManager_przedzialy 
         YearsInCurrentRole_przedzialy TotalWorkingYears_przedzialy 
         DistanceFromHome_przedzialy WorkLifeBalance StockOptionLevel 
         RelationshipSatisfaction OverTime NumCompaniesWorked_group 
         JobSatisfaction JobLevel JobInvolvement EnvironmentSatisfaction 
         Gender Income_group / ties=efron;
run;


/* Age_group */
proc phreg data=dane.Final_Data;
model YearsAtCompany*Attrition(0)= Age_group / ties=efron;
strata Age_group;
baseline out=zb_lls_Age_group loglogs=lls / method=pl;
run;
proc gplot data=zb_lls_Age_group ;
plot lls*YearsAtCompany=Age_group;
symbol1 I=join color=blue line=1 value=none;
symbol2 I=join color=red line=1 value=none;
symbol3 I=join color=green line=1 value=none;
run;




/* Businesstravel_p */
proc phreg data=dane.Final_Data;
model YearsAtCompany*Attrition(0)= BusinessTravel_p / ties=efron;
strata BusinessTravel_p;
baseline out=zb_lls_BusinessTravel_p loglogs=lls / method=pl;
run;
proc gplot data=zb_lls_BusinessTravel_p ;
plot lls*YearsAtCompany=BusinessTravel_p;
symbol1 I=join color=blue line=1 value=none;
symbol2 I=join color=red line=1 value=none;
symbol3 I=join color=green line=1 value=none;
run;

proc phreg data=dane.Final_Data;
class BusinessTravel_p;
model YearsAtCompany*Attrition(0)= BusinessTravel_p / ties=efron;
output out=R_Sch_s
(keep = YearsAtCompany BusinessTravel_p BusinessTravel_p_RS)
ressch= BusinessTravel_p_RS;
run;

goptions reset=all;
goptions htext=1.5 ;
option nodate nonumber;
axis1 order=(-1 0 1)
label= ( angle=90 'Schoenfeld residuals');
axis2 order=(0 20 40 60 80 100)
label= ('t');
legend1 label=none;
proc gplot data=R_Sch_s;
plot BusinessTravel_p_RS*YearsAtCompany / vaxis=axis1 haxis=axis2;
symbol1 v=point i=sm90s width=1 c=blue;
run;


/* Building a macro  */

%macro phreg_analysis(variable=);

/* Shorten variable name for output datasets if needed */
%let shortvar = %substr(&variable, 1, %sysfunc(min(24, %length(&variable))));

/* First check number of distinct values in the variable */
proc sql noprint;
select count(distinct &variable) into :n_levels
from dane.Final_Data;
quit;

/* PHREG analysis with log-log survival plots */
proc phreg data=dane.Final_Data;
model YearsAtCompany*Attrition(0)= &variable / ties=efron;
strata &variable;
baseline out=zb_lls_&shortvar loglogs=lls / method=pl;
run;

/* Plot log-log */
proc gplot data=zb_lls_&shortvar;
plot lls*YearsAtCompany=&variable;
%if &n_levels <= 3 %then %do;
    symbol1 I=join color=blue line=1 value=none;
    symbol2 I=join color=red line=1 value=none;
    symbol3 I=join color=green line=1 value=none;
%end;
%else %if &n_levels <= 8 %then %do;
    symbol1 I=join color=blue line=1 value=none;
    symbol2 I=join color=red line=1 value=none;
    symbol3 I=join color=green line=1 value=none;
    symbol4 I=join color=black line=1 value=none;
    symbol5 I=join color=purple line=1 value=none;
    symbol6 I=join color=orange line=1 value=none;
    symbol7 I=join color=brown line=1 value=none;
    symbol8 I=join color=gray line=1 value=none;
%end;
%else %do;
    symbol1 I=none color=blue pointlabel=("#&variable") value=dot;
%end;
run;

/* PHREG analysis for Schoenfeld residuals */
proc phreg data=dane.Final_Data;
class &variable;
model YearsAtCompany*Attrition(0)= &variable / ties=efron;
output out=R_Sch_&shortvar
(keep = YearsAtCompany &variable RS_&shortvar)
ressch= RS_&shortvar;
run;

/* Plot Schoenfeld residuals */
goptions reset=all;
goptions htext=1.5;
option nodate nonumber;
axis1 order=(-1 0 1)
label=(angle=90 'Schoenfeld residuals');
axis2 order=(0 to 100 by 20)
label=('t');

proc gplot data=R_Sch_&shortvar;
plot RS_&shortvar*YearsAtCompany / vaxis=axis1 haxis=axis2;
symbol1 v=point i=sm90s width=1 c=blue;
run;

%mend phreg_analysis;


%phreg_analysis(variable=Age_group);
%phreg_analysis(variable=BusinessTravel_p);
%phreg_analysis(variable=YearsWithCurrManager_przedzialy);
%phreg_analysis(variable=YearsInCurrentRole_przedzialy);
%phreg_analysis(variable=TotalWorkingYears_przedzialy);
%phreg_analysis(variable=DistanceFromHome_przedzialy);
%phreg_analysis(variable=WorkLifeBalance);
%phreg_analysis(variable=TrainingTimesLastYear);
%phreg_analysis(variable=StockOptionLevel);
%phreg_analysis(variable=RelationshipSatisfaction);
%phreg_analysis(variable=OverTime);
%phreg_analysis(variable=NumCompaniesWorked_group);
%phreg_analysis(variable=Income_group);
%phreg_analysis(variable=JobSatisfaction);
%phreg_analysis(variable=JobLevel);
%phreg_analysis(variable=JobInvolvement);
%phreg_analysis(variable=EnvironmentSatisfaction);



/* building the model form variables that fit the proportional hazards assumption */


proc phreg data=dane.Final_data;
    class 
        Age_group
        TotalWorkingYears_przedzialy
        RelationshipSatisfaction
       	Income_group
       	EnvironmentSatisfaction
       	WorkLifeBalance
       	
        / param=ref ref=first;
    
    model YearsAtCompany*Attrition(0) = 
        Age_group
        TotalWorkingYears_przedzialy
        RelationshipSatisfaction
       	Income_group
       	EnvironmentSatisfaction
       	WorkLifeBalance
        / ties=efron;
run;

