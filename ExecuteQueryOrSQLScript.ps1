#Execute a query or SQL script.
Import-Module SQLPS –DisableNameChecking
$instanceName = "XPENVY\XPSQLSVR"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

# Assume testDB exists on the server.
$dbName = "AdventureWorks2008R2"
$db = $server.Databases[$dbName]
$qry = "SELECT top 10 * FROM Person.Person"
$sqlFile="C:\Temp\UpdateCourse_Grades.sql"

#execute a passthrough query, and export to a CSV file
Invoke-Sqlcmd -Query $qry -Username "XPOwner" -Password "SGAkevin"  -ServerInstance "$instanceName" -Database $dbName | 
Export-Csv -LiteralPath "C:\Temp\ResultsFromPassThrough.csv" -NoTypeInformation

Invoke-Sqlcmd -InputFile $sqlFile  -Username "XPOwner" -Password "SGAkevin"  -ServerInstance "$instanceName" -Database "XP" |
Out-File -filepath "C:\Temp\Output_of_XP.Grades.csv"

##execute the SampleScript.sql, and display results to screen
Invoke-SqlCmd -InputFile "C:\Temp\testCSV.csv"  -Username "XPOwner" -Password "SGAkevin" -ServerInstance "$instanceName" -Database $dbName | 
Out-File -filepath "C:\Temp\Output_of_XP.Grades.csv"
#Select FirstName, LastName, ModifiedDate | 
#Format-Table
