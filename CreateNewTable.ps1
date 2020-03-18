#Create a new table in an eisting DB.
Import-Module SQLPS –DisableNameChecking
$instanceName = "XPENVY\XPSQLSVR"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

# Assume testDB exists on the server.
$dbName = "testDB"

$tableName = "Student"
$db = $server.Databases[$dbName]
$table = $db.Tables[$tableName]
#if table exists drop
if($table)
{
$table.Drop()
}
$table = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Table -ArgumentList $db, $tableName

#column class on MSDN
#http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.column.aspx
#column 1
$col1Name = "StudentID"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::Int;
$col1 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col1Name, $type
$col1.Nullable = $false
$col1.Identity = $true
$col1.IdentitySeed = 1
$col1.IdentityIncrement = 1
$table.Columns.Add($col1)
#column 2 - nullable
$col2Name = "FName"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::VarChar(50)
$col2 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col2Name, $type
$col2.Nullable = $true
$table.Columns.Add($col2)
#column 3 - not nullable, with default value
$col3Name = "LName"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::VarChar(50)
$col3 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col3Name, $type
$col3.Nullable = $false
$col3.AddDefaultConstraint("DF_Student_LName").Text = "'Doe'"
$table.Columns.Add($col3)
#column 4 - nullable, with default value
$col4Name = "DateOfBirth"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::DateTime;
$col4 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col4Name, $type
$col4.Nullable = $true
$col4.AddDefaultConstraint("DF_Student_DateOfBirth").Text ="'1800-00-00'"
$table.Columns.Add($col4)
#column 5
$col5Name = "Age"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::Int;
$col5 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col5Name, $type
$col5.Nullable = $false
$col5.Computed = $true
$col5.ComputedText = "YEAR(GETDATE()) - YEAR(DateOfBirth)";
$table.Columns.Add($col5)

$table.Create()

#make StudentID a clustered PK
#########################################
#note this is just a "placeholder" right now for PK
#no columns are added in this step
$PK=New-Object -TypeName Microsoft.SqlServer.Management.SMO.Index -ArgumentList $table,"PK_Student_StudentID"
$PK.IsClustered =$true
$PK.IndexKeyType =[Microsoft.SqlServer.Management.SMO.IndexKeyType]::DriPrimaryKey
#identify columns part of the PK
$PKcol=New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -ArgumentList $PK,$col1Name
$PK.IndexedColumns.Add($PKcol)
$PK.Create()