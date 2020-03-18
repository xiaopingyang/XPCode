#Create a new view in an eisting DB.
Import-Module SQLPS –DisableNameChecking
$instanceName = "XPENVY\XPSQLSVR"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

# Assume testDB exists on the server.
$dbName = "AdventureWorks2008R2"
$db = $server.Databases[$dbName]
$viewName = "vwVCPerson"
$view = $db.Views[$viewName]
#if view exists, drop it
if ($view)
{
$view.Drop()
}
$view = New-Object -TypeName Microsoft.SqlServer.Management.SMO.View -ArgumentList $db, $viewName, "dbo"
#TextMode = false meaning we are not
#going to explicitly write the CREATE VIEW header
$view.TextMode = $false
$view.TextBody = @"
SELECT
TOP 100
BusinessEntityID,
LastName,
FirstName
FROM
Person.Person
WHERE
PersonType = 'IN'
ORDER BY
LastName
"@
$view.Create()

$result = Invoke-Sqlcmd `
-Query "SELECT * FROM vwVCPerson" `
-ServerInstance "$instanceName" `
-Database $dbName
$result | Format-Table -AutoSize
