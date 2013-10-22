-- alter service master key regenerate


-- Backup the SMK
BACKUP SERVICE MASTER KEY
 TO FILE = 'c:\sqlbackup\MainServiceMaster.key'
 ENCRYPTION BY PASSWORD = 'S3cureP@ssword!sneeded'


-- Restore the SMK
RESTORE SERVICE MASTER KEY
 FROM FILE = 'c:\sqlbackup\MainServiceMaster.key'
 DECRYPTION BY PASSWORD = 'S3cureP@ssword!sneeded'
 
 
