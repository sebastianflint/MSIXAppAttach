<#
.SYNOPSIS
The script mount the VHD/X File
.DESCRIPTION
Use this script to mount a MSIX App Attach Container (run as Administrator)
.NOTES
  Version:        1.0
  Author:         Manuel Winkel <www.deyda.net>
  Creation Date:  2020-06-04
  Purpose/Change:
#>
#region variables
$vhdSrc="\\srv-dc02\MSIX$\Firefox.vhdx"
$packageName = "MozillaFirefox121.0.1x64de_121.0.1.0_x64__7x36akz78spd8" 
$parentFolder = "MSIX"
$volumeGuid = "f956b2cd-a437-418e-b5a7-3804c3cd7d8d"

$parentFolder = "\" + $parentFolder + "\"
$msixJunction = "C:\temp\AppAttach\" 
#endregion

#region mountvhd
try 
{
    Mount-Diskimage -ImagePath $vhdSrc -NoDriveLetter -Access ReadOnly                 
    Write-Host ("Mounting of " + $vhdSrc + " was completed!") -BackgroundColor Green 
}
catch
{
    Write-Host ("Mounting of " + $vhdSrc + " has failed!") -BackgroundColor Red
}
#endregion


#region makelink
$msixDest = "\\?\Volume{" + $volumeGuid + "}\"

if (!(Test-Path $msixJunction)) 
{
    md $msixJunction
}

$msixJunction = $msixJunction + $packageName

cmd.exe /c mklink /j $msixJunction $msixDest
#endregion

#region stage
[Windows.Management.Deployment.PackageManager,Windows.Management.Deployment,ContentType=WindowsRuntime] | Out-Null
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTask = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where { $_.ToString() -eq 'System.Threading.Tasks.Task`1[TResult] AsTask[TResult,TProgress](Windows.Foundation.IAsyncOperationWithProgress`2[TResult,TProgress])'})[0]
$asTaskAsyncOperation = $asTask.MakeGenericMethod([Windows.Management.Deployment.DeploymentResult], [Windows.Management.Deployment.DeploymentProgress])

$packageManager = [Windows.Management.Deployment.PackageManager]::new()
    
$path = $msixJunction + $parentFolder + $packageName # needed if we do the pbisigned.vhd
$path = ([System.Uri]$path).AbsoluteUri
  
$asyncOperation = $packageManager.StagePackageAsync($path, $null, "StageInPlace")
                                                                                                                    
$task = $asTaskAsyncOperation.Invoke($null, @($asyncOperation))
        
$task
#endregion
