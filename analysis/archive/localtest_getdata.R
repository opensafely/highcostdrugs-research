##
## How to access OS SQL server via project pipelines,
## including tests on a windows machine
##

# # # # # # # # # # # # # # # # # # # # # # # # 
#### create local environment variable     ####
# # # # # # # # # # # # # # # # # # # # # # # # 

## only do this bit if you want to test your DB connection locally ##

## 1. install the appropriate ODBC driver. 
## go here: https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver15
## you will need to restart your machine

## 2. define the connection to the dummy database

## the dummy database connection details are as follows:

driver = 'ODBC Driver 17 for SQL Server'
server = 'covid.ebmdatalab.net,1433'
database = 'OPENCoronaExport' 
username = 'SA'
password = 'ahsjdkaJAMSHDA123['

## convert this to a string
dbconn_string = paste0(
  'DRIVER={',driver,'}',
  ';SERVER=',server,
  ';DATABASE=',database,
  ';UID=',username,
  ';PWD=',password
)

## 3. add this string to your environment:

## either paste the following string into an .Renviron file in 
## the current directory or you default home directory
paste0("OPENSAFELY_FULL_DATABASE_URL=",dbconn_string)
## and then restart your R session

## or submit this line:
Sys.setenv(OPENSAFELY_FULL_DATABASE_URL=dbconn_string)
## (you shouldn't need to restart R)

## for more details, see https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html


# # # # # # # # # # # # # # # # # # # # # # # # 
#### install required packages             ####
# # # # # # # # # # # # # # # # # # # # # # # # 

## install the odbc R package
install.packages('odbc')



# # # # # # # # # # # # # # # # # # # # # # # # 
#### create connection to DB and query it  ####
# # # # # # # # # # # # # # # # # # # # # # # # 

## use the environment variable created above to connect to the dummy server

## 1. read in environment variable
dbconn_string <- Sys.getenv(x = "OPENSAFELY_FULL_DATABASE_URL")

## 2. create the connection using the connection string
dbconn <-  odbc::dbConnect(
  drv = odbc::odbc(),
  .connection_string = dbconn_string
)

## 3. now you can query the database with SQL
Test <- odbc::dbGetQuery(dbconn, "SELECT 
                                    DrugName, 
                                    DerivedSNOMEDFromName, 
                                    DerivedVTM,
                                    DerivedVTMName,
                                    count(Patient_ID) as Num_Issues
                                  FROM OpenCorona.dbo.HighCostDrugs
                                  GROUP BY
                                    DrugName, 
                                    DerivedSNOMEDFromName, 
                                    DerivedVTM,
                                    DerivedVTMName")
