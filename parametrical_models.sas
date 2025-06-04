/* 1. MODELE BEZ ZMIENNYCH OBJAŚNIAJĄCYCH */

/* Model wykładniczy */
proc lifereg data=final_data;
    model YearsAtCompany*Attrition(0) = / dist=exponential;
    ods output FitStatistics=exp_fit_novar;
run;

/* Model Weibulla */
proc lifereg data=final_data;
    model YearsAtCompany*Attrition(0) = / dist=weibull;
    ods output FitStatistics=weib_fit_novar;
run;

/* Model gamma */
proc lifereg data=final_data;
    model YearsAtCompany*Attrition(0) = / dist=gamma maxiter=100;
    ods output FitStatistics=gamma_fit_novar;
run;

/* Model log-logistyczny */
proc lifereg data=final_data;
    model YearsAtCompany*Attrition(0) = / dist=llogistic;
    ods output FitStatistics=llog_fit_novar;
run;

/* Model logarytmiczno-normalny */
proc lifereg data=final_data;
    model YearsAtCompany*Attrition(0) = / dist=lnormal;
    ods output FitStatistics=lnorm_fit_novar;
run;

/* 2. MODELE ZE WSZYSTKIMI ZMIENNYMI OBJAŚNIAJĄCYMI */

/* Model wykładniczy ze wszystkimi zmiennymi */
proc lifereg data=final_data;
    class BusinessTravel Department EducationField Gender JobRole MaritalStatus OverTime;
    model YearsAtCompany*Attrition(0) = Age BusinessTravel DailyRate Department DistanceFromHome 
          Education EducationField EnvironmentSatisfaction Gender HourlyRate JobInvolvement 
          JobLevel JobRole JobSatisfaction MaritalStatus MonthlyIncome MonthlyRate 
          NumCompaniesWorked OverTime PercentSalaryHike PerformanceRating RelationshipSatisfaction 
          StockOptionLevel TotalWorkingYears TrainingTimesLastYear WorkLifeBalance 
          YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager 
          / dist=exponential;
    ods output FitStatistics=exp_fit_all;
run;

/* Model Weibulla ze wszystkimi zmiennymi */
proc lifereg data=final_data;
    class BusinessTravel Department EducationField Gender JobRole MaritalStatus OverTime;
    model YearsAtCompany*Attrition(0) = Age BusinessTravel DailyRate Department DistanceFromHome 
          Education EducationField EnvironmentSatisfaction Gender HourlyRate JobInvolvement 
          JobLevel JobRole JobSatisfaction MaritalStatus MonthlyIncome MonthlyRate 
          NumCompaniesWorked OverTime PercentSalaryHike PerformanceRating RelationshipSatisfaction 
          StockOptionLevel TotalWorkingYears TrainingTimesLastYear WorkLifeBalance 
          YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager 
          / dist=weibull;
    ods output FitStatistics=weib_fit_all;
run;

/* Model gamma ze wszystkimi zmiennymi */
proc lifereg data=final_data;
    class BusinessTravel Department EducationField Gender JobRole MaritalStatus OverTime;
    model YearsAtCompany*Attrition(0) = Age BusinessTravel DailyRate Department DistanceFromHome 
          Education EducationField EnvironmentSatisfaction Gender HourlyRate JobInvolvement 
          JobLevel JobRole JobSatisfaction MaritalStatus MonthlyIncome MonthlyRate 
          NumCompaniesWorked OverTime PercentSalaryHike PerformanceRating RelationshipSatisfaction 
          StockOptionLevel TotalWorkingYears TrainingTimesLastYear WorkLifeBalance 
          YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager 
          / dist=gamma maxiter=100;
    ods output FitStatistics=gamma_fit_all;
run;

/* Model log-logistyczny ze wszystkimi zmiennymi */
proc lifereg data=final_data;
    class BusinessTravel Department EducationField Gender JobRole MaritalStatus OverTime;
    model YearsAtCompany*Attrition(0) = Age BusinessTravel DailyRate Department DistanceFromHome 
          Education EducationField EnvironmentSatisfaction Gender HourlyRate JobInvolvement 
          JobLevel JobRole JobSatisfaction MaritalStatus MonthlyIncome MonthlyRate 
          NumCompaniesWorked OverTime PercentSalaryHike PerformanceRating RelationshipSatisfaction 
          StockOptionLevel TotalWorkingYears TrainingTimesLastYear WorkLifeBalance 
          YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager 
          / dist=llogistic;
    ods output FitStatistics=llog_fit_all;
run;

/* Model logarytmiczno-normalny ze wszystkimi zmiennymi */
proc lifereg data=final_data;
    class BusinessTravel Department EducationField Gender JobRole MaritalStatus OverTime;
    model YearsAtCompany*Attrition(0) = Age BusinessTravel DailyRate Department DistanceFromHome 
          Education EducationField EnvironmentSatisfaction Gender HourlyRate JobInvolvement 
          JobLevel JobRole JobSatisfaction MaritalStatus MonthlyIncome MonthlyRate 
          NumCompaniesWorked OverTime PercentSalaryHike PerformanceRating RelationshipSatisfaction 
          StockOptionLevel TotalWorkingYears TrainingTimesLastYear WorkLifeBalance 
          YearsInCurrentRole YearsSinceLastPromotion YearsWithCurrManager 
          / dist=lnormal;
    ods output FitStatistics=lnorm_fit_all;
run;

/* 3. SPRAWDZENIE STRUKTURY DANYCH I TABELA PORÓWNAWCZA */

/* Sprawdzenie struktury zbiorów FitStatistics */
proc print data=exp_fit_novar;
    title 'Struktura zbioru FitStatistics - sprawdzenie';
run;

proc contents data=exp_fit_novar;
    title 'Opis struktury zbioru FitStatistics';
run;

/* Sprawdzenie unikalnych wartości w kolumnie Criterion */
proc freq data=exp_fit_novar;
    tables Criterion;
    title 'Unikalne wartości w kolumnie Criterion';
run;

/* Zbieranie kryteriów AIC dla wszystkich modeli - wersja diagnostyczna */
data all_aic;
    set exp_fit_novar(in=a)
        weib_fit_novar(in=b)
        gamma_fit_novar(in=c)
        llog_fit_novar(in=d)
        lnorm_fit_novar(in=e)
        exp_fit_all(in=f)
        weib_fit_all(in=g)
        gamma_fit_all(in=h)
        llog_fit_all(in=i)
        lnorm_fit_all(in=j);
    
    length Model $30 Typ $20;
    
    /* Diagnostyka - sprawdzenie wszystkich wartości */
    put 'Criterion=' Criterion ' Value=' Value;
    
    /* Próba różnych wariantów nazwy AIC */
    if upcase(Criterion) = 'AIC' or 
       upcase(Criterion) = 'AKAIKE (AIC)' or
       index(upcase(Criterion), 'AIC') > 0 then do;
        AIC = Value;
        
        if a then do; Model='Wykładniczy'; Typ='Bez zmiennych'; end;
        if b then do; Model='Weibulla'; Typ='Bez zmiennych'; end;
        if c then do; Model='Gamma'; Typ='Bez zmiennych'; end;
        if d then do; Model='Log-logistyczny'; Typ='Bez zmiennych'; end;
        if e then do; Model='Log-normalny'; Typ='Bez zmiennych'; end;
        if f then do; Model='Wykładniczy'; Typ='Ze zmiennymi'; end;
        if g then do; Model='Weibulla'; Typ='Ze zmiennymi'; end;
        if h then do; Model='Gamma'; Typ='Ze zmiennymi'; end;
        if i then do; Model='Log-logistyczny'; Typ='Ze zmiennymi'; end;
        if j then do; Model='Log-normalny'; Typ='Ze zmiennymi'; end;
        
        keep Model Typ AIC;
        output;
    end;
run;

proc sort data=all_aic;
    by AIC;
run;

proc print data=all_aic;
    title 'Porównanie modeli parametrycznych - kryterium AIC (mniejsze = lepsze)';
    var Model Typ AIC;
    format AIC 10.3;
run;
