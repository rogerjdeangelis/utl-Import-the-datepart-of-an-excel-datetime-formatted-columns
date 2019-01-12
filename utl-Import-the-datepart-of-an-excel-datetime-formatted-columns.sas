Import the datepart of an excel datetime formatted columns

I assume the dates are numeric but displayed in with excel formats

 Formated             1/11/2019    1/11/2019 13:30
 Underlying values     43476        43476.741

The excel 'INT' function will convert an excel datetime to a date

The op finally indicated that the original  date and datetime values
were in excel.. It is important that programmers limit the number
of data transformations. Work wit the excel file using passthru?

github
https://tinyurl.com/yah8fzaj
https://github.com/rogerjdeangelis/utl-Import-the-datepart-of-an-excel-datetime-formatted-columns

related to
https://communities.sas.com/t5/New-SAS-User/text-input/m-p/525400


PROBLEM
=======

Import the datepart of an excel datetime formatted columns

The INT function in excel will convert a datetime value tyo a date value

INPUT
=====

%utlfkil(d:/xls/have.xlsx);
libname xel "d:/xls/have.xlsx";

data xel.have ;
  retain key;
  do dteTym=datetime() to datetime()+5*24*60*60 by 24*60*60;
     key+1;
     dte=datepart(dteTym);
     format dte date9. dteTym datetime18.0;
     output;
  end;
  stop;
run;quit;

libname xel clear;

EXCEL INPUT (underlying numbers shown, but formatted values appear in excel)
Do not reformat the sheet to show the underlying numbers.

d:/xls/have.xlsx

+-------------------------------------------+
|    A       |     B      |    C            |
|-------------------------------------------+
|  KEY       |   DTE      |   DTETYM        |
+------------+------------+-----------------+
|   1        | 1/11/2019  | 1/11/2019 13:00 | ** Excel does not show the 13:00 but the value is a datetime
|real value  |  43476     | 43476.741       | ** and the undelying number has the decimals. Reformat in excel
|------------+------------+-----------------+ ** if you want to see the 13:00
|   2        | 1/12/2019  | 1/11/2019 13:00 |
|real value  |  43477     | 43477.741       |
+------------+------------+-----------------+
|   3        | 1/13/2019  | 1/11/2019 13:00 |
|real value  |  43478     | 43478.741       |
+------------+------------+-----------------+


EXAMPLE OUTPUT
--------------

WORK.WANT total obs=6

 KEY       DTE        DTETYM   ** we get just the datepart

  1     11JAN2019    11JAN2019
  2     12JAN2019    12JAN2019
  3     13JAN2019    13JAN2019
  4     14JAN2019    14JAN2019
  5     15JAN2019    15JAN2019
  6     16JAN2019    16JAN2019


SAS undelying numbers

 WORK.WANT total obs=6

 KEY     DTE     DTETYM

  1     21560     21560
  2     21561     21561
  3     21562     21562
  4     21563     21563
  5     21564     21564
  6     21565     21565

PROCESS
=======

proc sql dquote=ansi;
 connect to excel
    (Path="d:/xls/have.xlsx" );
    create
        table want as
    select
        key
       ,dte  format=date9.
       ,dteTym format=date9.
        from connection to Excel
        (
         Select
            key
           ,dte    as dte
           ,int(dteTym)   as dteTym
         from
           have
        );
    disconnect from Excel;
Quit;

OUTPUT
======
see above



