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

powershell -Command "& {$drives = Get-PSDrive -PSProvider 'FileSystem'; foreach ($drive in $drives) {Get-ChildItem -Path $drive.Root -Recurse -File -ErrorAction SilentlyContinue | Select-Object Name, Extension, Length, LastWriteTime, CreationTime, LastAccessTime, Mode, FullName | Export-Csv -Path '%~dp0file_list.csv' -NoTypeInformation -Append -Force}}"

pause