clear-host
import-module activedirectory
$ScriptDirectory = $MyInvocation.MyCommand.Path
$ScriptDirectory = $ScriptDirectory.substring(0,$ScriptDirectory.LastIndexOf('\'))

. (Join-Path $ScriptDirectory UserOnboardFunctions.ps1)

Write-Host "*******************************************************************************************************************
*  The user onboard script copies certain information from an AD user name 'templateuser' to create a new user.
*  This script creates the 'templateuser' but you'll need to gather the appropriate locations/information below:
*******************************************************************************************************************
*  Profile Path - the root folder where roaming profiles are stored
*    (i.e \\servername\profilefolder)
*
*  Home Drive Letter - the drive letter for a home drive
*    (i.e. 'H:' , or 'U:')
*
*  Home Directory - the root folder where user directories are stored;
*    in most cases this will be the same as the profile folder
*    (i.e. \\servername\profilefolder)
*
*  Login Script Path - this can be a full UNC path or just the batch script
*    (i.e. \\servername\foldername\script.bat) or (i.e login.bat)
*******************************************************************************************************************" -ForegroundColor Yellow

$firstname = "Template"
$lastname = "User"
$fullname = $firstname + " " + $lastname
$samaccountname = "templateuser"
$UPN = $samaccountname + "@" + (Get-ADDomain).dnsroot
$newPassword = (Read-Host -Prompt "Provide New Password" -AsSecureString)
$OU = Get-UserOU

$profilepath = (Read-Host -Prompt "Profile Path")
If ($profilepath -ne $null)
{
  $profilepath = $profilepath.substring(0,$profilepath.LastIndexOf('\')) + "\$samaccountname"
}
$homedrive = (Read-Host -Prompt "Home Drive Letter")
$homedirectory = (Read-Host -Prompt "Home Directory")
If ($homedirectory -ne $null)
{
  $homedirectory = $homedirectory.substring(0,$homedirectory.LastIndexOf('\')) + "\$samaccountname"
}
$scriptpath = (Read-Host -Prompt "Login Script Path")

new-aduser -name  $fullname -givenname $firstname -surname $lastname -displayname $fullname -userprincipalname $UPN -samaccountname $samaccountname -accountpassword $newPassword -path $OU -profilepath $profilepath -HomeDrive $homedrive -HomeDirectory $HomeDirectory -scriptpath $scriptpath -passthru | Enable-ADAccount

Start-Sleep -Milliseconds 2000
Write-Host "*********************************************"
Write-Host "User account created!" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"

Get-ADUser -Identity $samaccountname -Properties * | fl displayname,userprincipalname,samaccountname,DistinguishedName,homedrive,Homedirectory,scriptpath,title,description,Department,manager,Enabled

Write-Host "*******************************************************************************************************************
*  You can now use the User Onboard script located in the same folder.
*******************************************************************************************************************" -ForegroundColor Yellow

Pause
