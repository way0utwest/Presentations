$server = "JollyGreenGiant"
$database = "AdventureWorks2008"
$query = "SELECT TOP 10 Document, FileName FROM Production.Document WHERE Document IS NOT NULL"
$dirPath = "D:\Documents\Docs\"
 
$connection=new-object System.Data.SqlClient.SQLConnection
$connection.ConnectionString="Server={0};Database={1};Integrated Security=True" -f $server,$database
$command=new-object system.Data.SqlClient.SqlCommand($query,$connection)
$command.CommandTimeout=120
$connection.Open()
$reader = $command.ExecuteReader()
while ($reader.Read())
{
    $sqlBytes = $reader.GetSqlBytes(0)
    $filepath = "$dirPath{0}" -f $reader.GetValue(1)
    $buffer = new-object byte[] -ArgumentList $reader.GetBytes(0,0,$null,0,$sqlBytes.Length)
    $reader.GetBytes(0,0,$buffer,0,$buffer.Length)
    $fs = new-object System.IO.FileStream($filePath,[System.IO.FileMode]'Create',[System.IO.FileAccess]'Write')
	$fs.Write($buffer, 0, $buffer.Length)
	$fs.Close()
}
$reader.Close()
$connection.Close()