proc lifetest data=dane.Final_data method=pl plots=(s, ls, lls);
time YearsAtCompany*Attrition(0);
run;

proc lifetest data=dane.Final_data method=lt plots=(s,h);
time YearsAtCompany*Attrition(0);
strata Gender;
run;
proc lifetest data=dane.Final_data method=pl plots=(s);
time YearsAtCompany*Attrition(0);
strata Gender;
run;
data dane.Final_data;
    set dane.Final_data; 
    proc rank data=dane.Final_data out=dane.Final_data_ranks groups=5;
        var Age;
        ranks age_przedzialy;
    run;

data work.dane_final;
    set dane.Final_data_ranks;
    select (age_przedzialy);
        when (0) age_przedzialy_label = 1; 
        when (1) age_przedzialy_label = 2; 
        when (2) age_przedzialy_label = 3; 
        when (3) age_przedzialy_label = 4; 
        when (4) age_przedzialy_label = 5; 
        otherwise age_przedzialy_label = .;
    end;
run;

proc print data=dane.Final_data_ranks;
run;

proc freq data=dane.Final_data_ranks;
    tables age_przedzialy;
run;

proc univariate data=dane.Final_data noprint;
    var Age;
    output out=work.Age_Ranges pctlpre=P_ pctlpts=0 to 100 by 20; /* Percentyle na granice przedzia³ów */
run;

proc print data=work.Age_Ranges;
run;

proc lifetest data=dane.Final_data_ranks method=lt plots=(s,h);
time YearsAtCompany*Attrition(0);
strata age_przedzialy;
run;
proc lifetest data=dane.Final_data_ranks method=pl plots=(s);
time YearsAtCompany*Attrition(0);
strata age_przedzialy;
run;
proc lifetest data=dane.Final_data_ranks method=lt plots=(s,h);
time YearsAtCompany*Attrition(0);
strata EducationField;
run;
proc lifetest data=dane.Final_data_ranks method=pl plots=(s);
time YearsAtCompany*Attrition(0);
strata EducationField;
run;
proc rank data=dane.Final_data_ranks out=dane.Final_data_ranks1 groups=5;
    var MonthlyIncome;
    ranks MonthlyIncome_przedzialy;
run;

proc univariate data=dane.Final_data_ranks1 noprint;
    var MonthlyIncome;
    output out=work.ranges pctlpre=P_ pctlpts=0 to 100 by 20; 
run;

proc print data=work.ranges;
    var P_0 P_20 P_40 P_60 P_80 P_100;
run;

proc print data=dane.Final_data_ranks1;
    var MonthlyIncome MonthlyIncome_przedzialy;
run;

proc lifetest data=dane.Final_data_ranks1 method=lt plots=(s,h);
time YearsAtCompany*Attrition(0);
strata MonthlyIncome_przedzialy;
run;
proc lifetest data=dane.Final_data_ranks1 method=pl plots=(s);
time YearsAtCompany*Attrition(0);
strata MonthlyIncome_przedzialy;
run;

proc lifereg data=dane.Final_data_ranks1;
model YearsAtCompany*Attrition(0)= /dist=exponential;
run;
proc lifereg data=dane.Final_data_ranks1;
   class BusinessTravel Department EducationField JobRole;
   model YearsAtCompany*Attrition(0) = Age age_przedzialy BusinessTravel DailyRate Department DistanceFromHome Education EducationField EnvironmentSatisfaction Gender HourlyRate JobInvolvement JobLevel JobRole JobSatisfaction MaritalStatus MonthlyIncome MonthlyIncome_przedzialy MonthlyRate NumCompaniesWorked OverTime PercentSalaryHike PerformanceRating RelationshipSatisfaction StockOptionLevel TotalWorkingYears TrainingTimesLastYear WorkLifeBalance YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager / dist=exponential;
run;

proc lifereg data=dane.Final_data_ranks1;
   class BusinessTravel JobRole;
   model YearsAtCompany*Attrition(0) = BusinessTravel DistanceFromHome EnvironmentSatisfaction JobInvolvement JobRole JobSatisfaction MaritalStatus MonthlyIncome_przedzialy NumCompaniesWorked OverTime RelationshipSatisfaction TrainingTimesLastYear YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager / dist=exponential;
run;

proc contents data=dane.Final_data_ranks1; run;
proc print data=dane.Final_data_ranks1(obs=10); run;

data filtered_data;
   set dane.Final_data_ranks1;
   if YearsAtCompany > 0;
run;

proc lifereg data=filtered_data;
   class BusinessTravel JobRole;
   model YearsAtCompany*Attrition(0) = BusinessTravel DistanceFromHome EnvironmentSatisfaction JobInvolvement JobRole JobSatisfaction MaritalStatus MonthlyIncome_przedzialy NumCompaniesWorked OverTime RelationshipSatisfaction TrainingTimesLastYear YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager / dist=exponential;
run;

proc univariate data=filtered_data;
   var YearsAtCompany;
run;
proc means data=filtered_data nmiss;
run;

proc lifereg data=filtered_data;
   class BusinessTravel JobRole;
   model YearsAtCompany*Attrition(0) = BusinessTravel DistanceFromHome EnvironmentSatisfaction JobInvolvement JobRole JobSatisfaction MaritalStatus MonthlyIncome_przedzialy NumCompaniesWorked OverTime RelationshipSatisfaction TrainingTimesLastYear YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager / dist=weibull;
run;
proc lifereg data=filtered_data;
   class BusinessTravel JobRole;
   model YearsAtCompany*Attrition(0) = BusinessTravel DistanceFromHome EnvironmentSatisfaction JobInvolvement JobRole JobSatisfaction MaritalStatus MonthlyIncome_przedzialy NumCompaniesWorked OverTime RelationshipSatisfaction TrainingTimesLastYear YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager / dist=exponential;
run;
