<#
.SYNOPSIS
  Get the OU to create the new user in

.DESCRIPTION
  Long description

.OUTPUTS
  This will return a string of the DistinguishedName of the OU that the new user will be placed in.

.EXAMPLE
  Get-UserOU

.LINK
  To other relevant cmdlets or help
#>
Function Get-UserOU
{
  [CmdletBinding()]
  [OutputType([Nullable])]
  param()
  Begin
  {
    # code
  }
  Process
  {
    $OU = Get-ADOrganizationalUnit -Filter * -Properties * | select canonicalname | Out-String
    $OU = $OU.trim()
    $OU = $OU.Remove(0,242)
    $OUCanonical = $OU.Split("`n",$OU.Length)

    $OU = Get-ADOrganizationalUnit -Filter * -Properties * | select DistinguishedName | Out-String
    $OU = $OU.trim()
    $OU = $OU.Remove(0,242)
    $OUDistinguished = $OU.Split("`n",$OU.Length)

    $linecounter = 0

    foreach($item in $OUCanonical){
      Write-Host($linecounter.ToString() + ". " + $item)
      $linecounter++
    }
    `r`n
    $UserOU = $OUDistinguished[[int](Read-Host -Prompt "Please enter the number of the OU you wish to place this new user in (i.e. 1 or 17)")]

    return $UserOU

  }
  End
  {
  }
}
