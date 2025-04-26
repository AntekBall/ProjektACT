libname dane "/home/act/";

/* Cox model bedzie niedlugo, jakis bazowy */
proc phreg data=dane.hr_analytics; class BusinessTravel;
model YearsAtCompany*Attrition(0)= BusinessTravel / ties=efron;
run;

proc contents data=dane.hr_analytics;
run;

proc means data=dane.hr_analytics;
var DistanceFromHome; run;

data dane.hr_analytics;
set dane.hr_analytics;
if DistanceFromHome<3 then DistanceFromHome_przedzialy=1;
if 3<=DistanceFromHome<10 then DistanceFromHome_przedzialy=2; if 10<=DistanceFromHome<20 then
DistanceFromHome_przedzialy=3; if DistanceFromHome>=20 then DistanceFromHome_przedzialy=4; run;

proc means data=dane.hr_analytics;
var NumCompaniesWorked; run;

proc means data=dane.hr_analytics;
var PercentSalaryHike; run;

data dane.hr_analytics;
set dane.hr_analytics;
if PercentSalaryHike<15 then PercentSalaryHike_przedzialy=1;
if 15<=PercentSalaryHike<20 then PercentSalaryHike_przedzialy=2;
if PercentSalaryHike>=20 then PercentSalaryHike_przedzialy=3;
run;

proc means data=dane.hr_analytics;
var TotalWorkingYears; run;

data dane.hr_analytics;
set dane.hr_analytics;
if TotalWorkingYears<5 then TotalWorkingYears_przedzialy=1;
if 5<=TotalWorkingYears<11 then TotalWorkingYears_przedzialy=2;
if 11<=TotalWorkingYears<20 then TotalWorkingYears_przedzialy=3;
if TotalWorkingYears>=20 then TotalWorkingYears_przedzialy=4;
run;

proc means data=dane.hr_analytics;
var YearsInCurrentRole; run;

data dane.hr_analytics;
set dane.hr_analytics;
if YearsInCurrentRole<4 then YearsInCurrentRole_przedzialy=1;
if 4<=YearsInCurrentRole<10 then YearsInCurrentRole_przedzialy=2;
if 10<=YearsInCurrentRole then YearsInCurrentRole_przedzialy=3;
run;

proc means data=dane.hr_analytics;
var YearsSinceLastPromotion; run;

data dane.hr_analytics;
set dane.hr_analytics;
if YearsSinceLastPromotion<2 then YSLP_przedzialy=1;
if 2<=YearsSinceLastPromotion<7 then YSLP_przedzialy=2;
if 7<=YearsSinceLastPromotion then YSLP_przedzialy=3;
run;

proc means data=dane.hr_analytics;
var YearsWithCurrManager; run;

data dane.hr_analytics;
set dane.hr_analytics;
if YearsWithCurrManager<4 then YearsWithCurrManager_przedzialy=1;
if 4<=YearsWithCurrManager<9 then YearsWithCurrManager_przedzialy=2;
if 9<=YearsWithCurrManager then YearsWithCurrManager_przedzialy=3;
run;

data dane.hr_analytics;
set dane.hr_analytics;
if BusinessTravel = "Non-Travel" then BusinessTravel_p=1;
if BusinessTravel = "Travel_Rarely" then BusinessTravel_p=2;
if BusinessTravel = "Travel_Frequently" then BusinessTravel_p=3;
run;

/* Create Final_data from the cleaned hr_analytics */
data dane.Final_data;
    set dane.hr_analytics;
run;
