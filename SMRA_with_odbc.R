#######Access to SMRA using odbc package###############
#Name: SMRA access R
#Date: 1/12/2017
#Author: Emily Moore.
#Desc: R code to set up an ODBC link to the SMRA database usin odbc
#########################################################################################################

#1.Load the odbc package.
#N.B. if you don't already have it installed, go to 'Packages' in the 'Files, plots, etc.' pane and
#select install.  Type odbc in the pop up and it will be installed.
#or use: install.packages("odbc")
library(odbc)

#2.Set up the connection
#Username and p/w will be the ones you use to connect to Stats Platform via SPSS - likely your BI login
SMRA <- suppressWarnings(
                      dbConnect(odbc(), dsn="SMRA",
                              uid=.rs.askForPassword("SMRA Username:"), 
                              pwd=.rs.askForPassword("SMRA Password:")))
#3. USEFUL CODE
#Show all tables/views available - n.b. this is a large output so have restricted it to the first 50.
#it does take a while to run.
dbListTables(SMRA)[1:50]
###list schema
odbcListObjects(SMRA)
odbcListObjectTypes(SMRA)

###list views in ANALYSIS schema
dbListTables(SMRA, schema="ANALYSIS")

###to see column names 
odbcPreviewObject(SMRA, table="ANALYSIS.SMR01_PI", rowLimit=0)


###query example
####Very basic query limited to 10 rows
SMR01 <- dbGetQuery(SMRA,statement="select LINK_NO, CIS_MARKER 
                    from ANALYSIS.SMR01_PI 
                    where rownum <= 10")

###limit on age and sex/
SMR01 <- dbGetQuery(SMRA,statement="SELECT AGE_IN_YEARS, SEX, LOCATION 
                    FROM ANALYSIS.SMR01_PI 
                    WHERE AGE_IN_YEARS>100 AND SEX=1  AND rownum <= 10")

#####

SMR_Join <- dbGetQuery(SMRA,
                  statement="SELECT T1.UPI_NUMBER,  T1.LOCATION, T1.SPECIALTY, 
                     T1.ADMISSION_TYPE, T1.ADMISSION_DATE, T1.DISCHARGE_DATE, 
                      T1.MAIN_CONDITION, T2.DATE_OF_DEATH
                      FROM 
                      ANALYSIS.SMR01_PI T1 
                      LEFT JOIN
                      ANALYSIS.GRO_DEATHS_C T2   
                      ON T1.UPI_NUMBER = T2.UPI_NUMBER 
                      WHERE rownum<=100")

