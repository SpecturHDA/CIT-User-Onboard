# CIT-User-Onboard
User onboard scripts for on-premises Exchange & O365/Exchange Online

"*******************************************************************************************************************
*  The user onboard script copies certain information from an AD user name 'templateuser' to create a new user.
*  This script creates the 'templateuser' but you'll need to gather the appropriate locations/information below:
*******************************************************************************************************************
*  Profile Path - the root folder where roaming profiles are stored
*    (i.e \\servername\profilefolder\)
*
*  Home Drive Letter - the drive letter for a home drive
*    (i.e. 'H:' , or 'U:')
*
*  Home Directory - the root folder where user directories are stored;
*    in most cases this will be the same as the profile folder
*    (i.e. \\servername\profilefolder\)
*
*  Login Script Path - this can be a full UNC path or just the batch script
*    (i.e. \\servername\foldername\script.bat) or (i.e login.bat)
*******************************************************************************************************************"

1. Run makeTemplateUser.ps1 first
2. Run useronboard_OnPremExchange.ps1 to create a new user if the client uses an On Premises Exchange Server
