@echo off
echo Script started.
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    cscript "%temp%\getadmin.vbs" /NoLogo
    exit /B
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
echo Obtained administrative privileges.
:: Your commands go here
echo Script finished.


powershell -Command "& {$computerInfo = Get-WmiObject -Class Win32_ComputerSystem; $osInfo = Get-WmiObject -Class Win32_OperatingSystem; $diskInfo = Get-WmiObject -Class Win32_LogicalDisk; Write-Output 'Computer Information:'; Write-Output ('Model: ' + $computerInfo.Model); Write-Output ('Manufacturer: ' + $computerInfo.Manufacturer); Write-Output ('Total Physical Memory: ' + $computerInfo.TotalPhysicalMemory / 1GB + ' GB'); Write-Output '`nOperating System Information:'; Write-Output ('Name: ' + $osInfo.Caption); Write-Output ('Version: ' + $osInfo.Version); Write-Output ('Install Date: ' + $osInfo.ConvertToDateTime($osInfo.InstallDate)); Write-Output ('Last Boot Up Time: ' + $osInfo.ConvertToDateTime($osInfo.LastBootUpTime)); Write-Output '`nDisk Information:'; foreach ($disk in $diskInfo) {Write-Output ('Drive Letter: ' + $disk.DeviceID); Write-Output ('Disk Size: ' + $disk.Size / 1GB + ' GB'); Write-Output ('Free Space: ' + $disk.FreeSpace / 1GB + ' GB'); Write-Output '`n'}}"
pause