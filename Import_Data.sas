/* tutaj wstawcie swoja sciezke */
LIBNAME Dane 'C:/Users/antek/analiza_czasu_trwania/ProjektACT';

/* Generated Code (IMPORT) */
/* Source File: WA_Fn-UseC_-HR-Employee-Attrition.csv */
/* Source Path: C:/Users/antek/analiza_czasu_trwania/ProjektACT */


%web_drop_table(Dane.hr_analytics);

/* tu tez */
FILENAME REFFILE 'C:/Users/antek/analiza_czasu_trwania/ProjektACT/WA_Fn-UseC_-HR-Employee-Attrition.csv';

PROC IMPORT DATAFILE=REFFILE
    DBMS=CSV
    OUT=Dane.hr_analytics;
    GETNAMES=YES;
RUN;

PROC CONTENTS DATA=Dane.hr_analytics; RUN;

%web_open_table(Dane.hr_analytics);