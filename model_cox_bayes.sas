libname dane "/home/u64248399"

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


/* Zmiana kolumny Attrition na numeryczną */
data dane.final_data;
  set dane.final_data;
  if Attrition = 'Yes' then Attrition_num = 1;
  else if Attrition = 'No' then Attrition_num = 0;
run;

data dane.final_data;
  set dane.final_data;
  if Attrition = 'Yes' then tmp = 1;
  else if Attrition = 'No' then tmp = 0;
  drop Attrition;
  rename tmp = Attrition;
run;



/* Stepwise */
proc phreg data=dane.final_data;
  /* Zmienne kategoryczne */
  class Age_group BusinessTravel_p YearsWithCurrManager_przedzialy YSLP_przedzialy YearsInCurrentRole_przedzialy
        TotalWorkingYears_przedzialy PercentSalaryHike_przedzialy DistanceFromHome_przedzialy Income_group 
        WorkLifeBalance TrainingTimesLastYear TotalWorkingYears StockOptionLevel RelationshipSatisfaction
        PerformanceRating OverTime NumCompaniesWorked_group MaritalStatus JobSatisfaction JobLevel JobInvolvement Gender 
        EnvironmentSatisfaction / param=ref ref=first;
  
  /* Model z doborem zmiennych stepwise */
  model YearsAtCompany*Attrition(0) = 
        Age_group 
        BusinessTravel_p 
        YearsWithCurrManager_przedzialy 
        YSLP_przedzialy 
        YearsInCurrentRole_przedzialy 
        TotalWorkingYears_przedzialy 
        PercentSalaryHike_przedzialy 
        DistanceFromHome_przedzialy 
        WorkLifeBalance 
        TrainingTimesLastYear 
        StockOptionLevel 
        RelationshipSatisfaction
        PerformanceRating 
        OverTime 
        NumCompaniesWorked_group 
        MonthlyRate 
        Income_group 
        MaritalStatus 
        JobSatisfaction 
        JobLevel 
        JobInvolvement 
        HourlyRate 
        Gender 
        EnvironmentSatisfaction
        Education 
        / selection=stepwise;
run;

/* Sprawdzenie unikalnych wartości w zmiennych */
proc freq data=dane.final_data;
  tables OverTime Gender;
run;

data dane.final_data;
set dane.final_data;
if Gender = 'Male' then Gender_num = 1;
if Gender = 'Female' then Gender_num = 0;
run;


data dane.final_data;
set dane.final_data;
if OverTime = 'Yes' then OverTime_num = 1;
if OverTime = 'No' then OverTime_num = 0;
run;


data dane.final_data_prepared;
set dane.final_data;
  /* Tworzymy interakcje z samym czasem */
  TotalWorkingYears_przedzialy_t = TotalWorkingYears_przedzialy * YearsAtCompany;
  NumCompaniesWorked_group_t = NumCompaniesWorked_group * YearsAtCompany;
  OverTime_t = OverTime_num * YearsAtCompany;
  YearsInCurrentRole_przedzialy_t = YearsInCurrentRole_przedzialy * YearsAtCompany;
  StockOptionLevel_t = StockOptionLevel * YearsAtCompany;
  YearsWithCurrManager_t = YearsWithCurrManager * YearsAtCompany;
  JobLevel_t = JobLevel * YearsAtCompany;
  JobInvolvement_t = JobInvolvement * YearsAtCompany;
  JobSatisfaction_t = JobSatisfaction * YearsAtCompany;
  Age_group_t = Age_group * YearsAtCompany;
  BusinessTravel_p_t = BusinessTravel_p * YearsAtCompany;
  RelationshipSatisfaction_t = RelationshipSatisfaction * YearsAtCompany;
  DistanceFromHome_przedzialy_t = DistanceFromHome_przedzialy * YearsAtCompany;
  TrainingTimesLastYear_t = TrainingTimesLastYear * YearsAtCompany;
  EnvironmentSatisfaction_t = EnvironmentSatisfaction * YearsAtCompany;
  Gender_t = Gender_num * YearsAtCompany;
run;

  /* Weryfikacja założenia proporcjonalnych hazardów */
proc phreg data=dane.final_data_prepared;
model YearsAtCompany*Attrition(0) = TotalWorkingYears_przedzialy_t TotalWorkingYears_przedzialy NumCompaniesWorked_group_t
NumCompaniesWorked_group OverTime_t OverTime_num YearsInCurrentRole_przedzialy_t YearsInCurrentRole_przedzialy
StockOptionLevel_t StockOptionLevel YearsWithCurrManager_t YearsWithCurrManager JobLevel_t JobLevel JobInvolvement_t JobInvolvement
JobSatisfaction_t JobSatisfaction Age_group_t Age_group BusinessTravel_p_t BusinessTravel_p RelationshipSatisfaction_t
RelationshipSatisfaction DistanceFromHome_przedzialy_t DistanceFromHome_przedzialy TrainingTimesLastYear_t TrainingTimesLastYear
EnvironmentSatisfaction_t EnvironmentSatisfaction Gender_t Gender_num ;

run;


proc phreg data=dane.final_data_prepared;
class TotalWorkingYears_przedzialy OverTime_num YearsInCurrentRole_przedzialy JobInvolvement Gender_num;
model YearsAtCompany*Attrition(0) = TotalWorkingYears_przedzialy OverTime_num YearsInCurrentRole_przedzialy 
JobInvolvement Gender_num TotalWorkingYears_przedzialy_t OverTime_t YearsInCurrentRole_przedzialy_t
JobInvolvement_t Gender_t;
bayes seed=123 nbi=1000 nmc=5000 coeffprior=normal diagnostics=all;
run;


proc phreg data=dane.final_data_prepared;
   model YearsAtCompany*Attrition(0) = TotalWorkingYears_przedzialy OverTime_num YearsInCurrentRole_przedzialy 
                                       JobInvolvement Gender_num;
   output out=martingale_data resmart=martingale_res;
run;

proc sgplot data=martingale_data;
   scatter x=DistanceFromHome y=martingale_res / markerattrs=(symbol=circlefilled);
   loess x=DistanceFromHome y=martingale_res / lineattrs=(color=red);
   xaxis label="Odległość od domu";
   yaxis label="Reszty martyngałowe";
   title "Reszty martyngałowe względem DistanceFromHome";
run;




