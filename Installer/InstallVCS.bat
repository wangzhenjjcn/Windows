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
::Check if choco is installed
echo check Chocolatey  
echo Checking Chocolatey...
where /q choco
echo Error level: %ERRORLEVEL%

IF ERRORLEVEL 1 (
    SET "CHOCO_URL=https://chocolatey.org/install.ps1"
    echo Chocolatey is not installed. Installing...
    PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((New-Object Sysem.Net.WebClient).DownloadString('%CHOCO_URL%'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
) else (
    echo Chocolatey is already installed. Checking for updates...
    choco upgrade chocolatey -y
)
echo Installing vs140...
choco install vcredist140 -y  --force
echo Installing vs2005...
choco install vcredist2005 -y  --force
echo Installing vs2008
choco install vcredist2008 -y  --force
echo Installing vs2010
choco install vcredist2010 -y  --force
echo Installing vs2012
choco install vcredist2012 -y  --force
echo Installing vs2013
choco install vcredist2013 -y  --force
echo Installing vs2015
choco install vcredist2015 -y  --force
echo Installing vs2017
choco install vcredist2017 -y  --force
echo Installing vsall
choco install vcredist-all -y  --force
pause