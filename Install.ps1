$FolderPath = (pwd).path
winget install --id GNU.Wget2
wget2 https://github.com/pufferffish/wireproxy/releases/download/v1.0.9/wireproxy_windows_amd64.tar.gz
tar -xvzf .\wireproxy_windows_amd64.tar.gz



if (Test-Path -path "wireproxy.ps1")
{
	Remove-Item .\wireproxy.ps1
}

add-content -path .\wireproxy.ps1 @'
$prefix = "-d -c wireproxycfg.conf"
'@
add-content -path .\wireproxy.ps1 "Start-Process $FolderPath\wireproxy.exe -WorkingDirectory '$FolderPath\'" -NoNewLine
add-content -path .\wireproxy.ps1 '-WindowStyle Hidden -args $prefix'



$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:10
Register-ScheduledJob -Trigger $trigger -FilePath "$FolderPath\wireproxy.ps1" -Name WireProxyStartUp




echo "Removing instalation files"
Remove-Item .\wireproxy_windows_amd64.tar.gz
Remove-Item .\install.ps1

read-host "Press ENTER to exit"