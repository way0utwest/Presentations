#Set the working location to the file with our sample policies
sl "C:\Program Files (x86)\Microsoft SQL Server\100\Tools\Policies\DatabaseEngine\1033"

Invoke-PolicyEvaluation -Policy "Database Auto Close.xml" -TargetServer "MyServerName"