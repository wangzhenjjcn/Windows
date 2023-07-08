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

choco install openjdk -y