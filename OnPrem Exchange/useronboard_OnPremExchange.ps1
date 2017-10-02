clear-host
import-module activedirectory
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
$ScriptDirectory = $MyInvocation.MyCommand.Path
$ScriptDirectory = $ScriptDirectory.substring(0,$ScriptDirectory.LastIndexOf('\'))

. (Join-Path $ScriptDirectory UserOnboardFunctions.ps1)

#Create new AD User
Write-Host "*********************************************"
Write-Host "Create New AD User" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"

$firstname = (Read-Host -Prompt "First Name")
$lastname = (Read-Host -Prompt "Last Name")
$fullname = $firstname + " " + $lastname
$samaccountname = (Read-Host -Prompt "Login Name (i.e. JSmith)")
$UPN = $samaccountname + "@" + (Get-ADDomain).dnsroot
$newPassword = (Read-Host -Prompt "Provide New Password" -AsSecureString)
$OU = Get-UserOU

$profilepath = (get-aduser templateuser -Properties *).profilepath
If ($profilepath -ne $null)
{
  $profilepath = $profilepath.substring(0,$profilepath.LastIndexOf('\')) + "\$samaccountname"
}
$homedrive = (get-aduser templateuser -Properties *).homedrive
$homedirectory = (get-aduser templateuser -Properties *).homedirectory
If ($homedirectory -ne $null)
{
  $homedirectory = $homedirectory.substring(0,$homedirectory.LastIndexOf('\')) + "\$samaccountname"
}
$scriptpath = (get-aduser templateuser -Properties *).scriptpath
$jobtitle = (Read-Host -Prompt "Job Title")
$department = (Read-Host -Prompt "Department")
$manager = (Read-Host -Prompt "Manager (i.e. Jdoe)")

new-aduser -name  $fullname -givenname $firstname -surname $lastname -displayname $fullname -userprincipalname $UPN -samaccountname $samaccountname -accountpassword $newPassword -path $OU -profilepath $profilepath -HomeDrive $homedrive -HomeDirectory $HomeDirectory -scriptpath $scriptpath -title $jobtitle -description $jobtitle -department $department -manager $manager -passthru | Enable-ADAccount

Start-Sleep -Milliseconds 2000
Write-Host "*********************************************"
Write-Host "User account created!" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"

Get-ADUser -Identity $samaccountname -Properties * | fl displayname,userprincipalname,samaccountname,DistinguishedName,homedrive,Homedirectory,scriptpath,title,description,Department,manager,Enabled

Write-Host "*********************************************"
Write-Host "Creating mailbox" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"

Enable-mailbox -identity $UPN

Write-Host "*********************************************"
Write-Host "Mailbox created!" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"

#Close PSSession
#get-pssession | remove-pssession

Pause
