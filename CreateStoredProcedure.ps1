#Create a new stored procedure in an eisting DB.
Import-Module SQLPS –DisableNameChecking
$instanceName = "XPENVY\XPSQLSVR"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

# Assume testDB exists on the server.
$dbName = "AdventureWorks2008R2"
$db = $server.Databases[$dbName]
#storedProcedure class on MSDN:
#http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.storedprocedure.aspx
$sprocName = "uspGetPersonByLastName"
$sproc = $db.StoredProcedures[$sprocName]
#if stored procedure exists, drop it
if ($sproc)
{
    $sproc.Drop()
}

$sproc = New-Object -TypeName Microsoft.SqlServer.Management.SMO.StoredProcedure -ArgumentList $db, $sprocName
#TextMode = false means stored procedure header is not editable as text
#otherwise our text will contain the CREATE PROC block
$sproc.TextMode = $false
$sproc.IsEncrypted = $true
$paramtype = [Microsoft.SqlServer.Management.SMO.Datatype]::VarChar(50);
$param = New-Object -TypeName Microsoft.SqlServer.Management.SMO.StoredProcedureParameter -ArgumentList $sproc,
"@LastName",$paramtype
$sproc.Parameters.Add($param)
#Set the TextBody property to define the stored procedure.
$sproc.TextBody = @"
SELECT TOP 10 BusinessEntityID,LastName
FROM Person.Person 
WHERE LastName = @LastName
"@
# Create the stored procedure on the instance of SQL Server.
$sproc.Create()
#if later on you need to change properties, can use the Alter method

#Test the stored procedure
$lastName = "Abercrombie"
$result = Invoke-Sqlcmd `
-Query "EXEC uspGetPersonByLastName @LastName=`'$LastName`'" `
-ServerInstance "$instanceName" `
-Database $dbName
$result | Format-Table -AutoSize