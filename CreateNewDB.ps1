Import-Module SQLPS –DisableNameChecking
$instanceName = "XPENVY\XPSQLSVR"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$dbName = "TestDB"
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($server, $dbName)
$db.Create()

$server.Databases |
Select Name, Status, Owner, CreateDate