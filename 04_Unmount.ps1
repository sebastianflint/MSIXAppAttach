<#
.SYNOPSIS
The script unmount the VHD/X File
.DESCRIPTION
Use this script to unmount a MSIX App Attach Container
.NOTES
  Version:        1.0
  Author:         Manuel Winkel <www.deyda.net>
  Creation Date:  2020-06-04
  Purpose/Change:
#>
#region variables 
$packageName = "MozillaFirefox121.0.1x64de_121.0.1.0_x64__7x36akz78spd8" 
$vhdSrc="\\srv-dc02\MSIX$\Firefox.vhdx"

$msixJunction = "C:\temp\AppAttach\" 
#endregion

#region derregister
Remove-AppxPackage -AllUsers -Package $packageName

cd $msixJunction 
rmdir $packageName -Recurse -Force -Confirm:$false
#endregion

#Dismount VHD
disMount-Diskimage -ImagePath $vhdSrc
