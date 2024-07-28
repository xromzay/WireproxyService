if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
 Exit
}



$FolderPath = (pwd).path
mkdir Wireproxy
cd $FolderPath/Wireproxy
winget install --id GNU.Wget2t
wget2 https://github.com/pufferffish/wireproxy/releases/download/v1.0.9/wireproxy_windows_amd64.tar.gz
tar -xvzf .\wireproxy_windows_amd64.tar.gz
Remove-Item .\wireproxy_windows_amd64.tar.gz


if (Test-Path -path "wireproxy.ps1")
{
	Remove-Item .\wireproxy.ps1
}

add-content -path .\wireproxy.ps1 @'
$prefix = "-d -c wireproxycfg.conf"
'@
add-content -path .\wireproxy.ps1 "Start-Process $FolderPath\wireproxy\wireproxy.exe -WorkingDirectory '$FolderPath\wireproxy'" -NoNewLine
add-content -path .\wireproxy.ps1 '-WindowStyle Hidden -args $prefix'



$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:10
Register-ScheduledJob -Trigger $trigger -FilePath "R:\standaloneprograms\wireproxy.ps1" -Name WireProxyStartUp



echo "All good"



read-host "Press ENTER to exit"