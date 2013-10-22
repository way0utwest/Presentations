$TargetServer = "dkrSQL2012"
$OutputXML = "C:\Users\Steve\My Documents\AutoShrink.xml"
$PolicyName = "Database Auto Shrink"
$ServerInstance = "dkrSQL2012"
$Database = "PBMResults"
Set-Location "C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Policies\DatabaseEngine\1033"
Invoke-PolicyEvaluation -Policy "Database Auto Shrink.xml" -TargetServer $TargetServer -OutputXML > $OutputXML
$PolicyResult = Get-Content $OutputXML;
$EvalResults = $PolicyResult -replace "'", "''"
$QueryText = "INSERT INTO PolicyHistory_staging (EvalServer, EvalPolicy, EvalResults)
VALUES(N'$TargetServer', N'$PolicyName', N'$EvalResults')"
Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $Database -Query $QueryText