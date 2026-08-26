Get-Service -Name wuauserv | Stop-Service -Force -verbose -ErrorAction SilentlyContinue

Get-ChildItem "C:\Windows\SoftwareDistribution\*" -Recurse -Force -verbose -ErrorAction          SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\Windows\Temp\*" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\Windows\prefetch\*" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\inetpub\logs\LogFiles\*" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\Users\*\AppData\Local\Temp" -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\Users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\Users\*\AppData\Local\Microsoft\Windows\History\*" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

Get-ChildItem "C:\Users\*\AppData\Local\Microsoft\Windows\INetCookies\*" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

$disk = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
foreach ($disk in $disks) {
$rbpathnew = "$($disk.DeviceID)\'$Recycle.Bin"  
if (Test-Path $rbpathnew) { cmd /c "rd /s /q $rbpathnew" } }

Get-Service -Name wuauserv | Start-Service -Verbose