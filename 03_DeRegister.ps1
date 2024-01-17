<#
.SYNOPSIS
The script deregister the MSIX Package
.DESCRIPTION
Use this script to deregister the MSIX Package
.NOTES
  Version:        1.0
  Author:         Manuel Winkel <www.deyda.net>
  Creation Date:  2020-06-04
  Purpose/Change:
#>
#region variables 
$packageName = "MozillaFirefox121.0.1x64de_121.0.1.0_x64__7x36akz78spd8" 
#endregion

#region derregister
Remove-AppxPackage -PreserveRoamableApplicationData $packageName 
#endregion 
