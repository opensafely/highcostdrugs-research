##
## How to access OS SQL server via project pipelines,
##

# # # # # # # # # # # # # # # # # # # # # # # # 
#### create connection to DB and query it  ####
# # # # # # # # # # # # # # # # # # # # # # # # 

## 1. read in environment variable
dbconn_string <- Sys.getenv(x = "OPENSAFELY_FULL_DATABASE_URL")

## 2. create the connection using the connection string
dbconn <-  odbc::dbConnect(
  drv = odbc::odbc(),
  .connection_string = dbconn_string
)

## 3. now you can query the database with SQL
data <- odbc::dbGetQuery(dbconn, "SELECT 
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

## 4. write data to csv file
write.csv(data, file = here::here("output", "data.csv"))
