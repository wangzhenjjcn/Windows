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

@echo off

:: 打开文件选择对话框并复制选择的文件到 system32 文件夹
set "batFilePath="
for %%I in ("%SystemRoot%\System32") do set "destinationPath=%%~fI"
setlocal enabledelayedexpansion
for /f "delims=" %%I in ('powershell -noprofile -command "Add-Type -AssemblyName System.Windows.Forms; $dialog = New-Object System.Windows.Forms.OpenFileDialog; $dialog.Filter = 'Batch Files (*.bat)|*.bat'; $dialog.ShowDialog(); $dialog.FileName"') do (
  set "batFilePath=%%~fI"
)
if defined batFilePath (
  copy /Y "%batFilePath%" "%destinationPath%"
) else (
  echo 用户取消了文件选择。
  exit /b
)

:: 提示用户输入服务名称
set /p "serviceName=请输入服务名称: "

:: 创建计划任务，后台运行 BAT 文件
schtasks /create /tn "%serviceName%" /tr "%destinationPath%\%~n0.bat" /sc onstart /rl highest /f
schtasks /run /tn "%serviceName%"

:: 完成提示
echo BAT 文件已设置为在开机时后台运行。
echo 服务名称: %serviceName%
echo BAT 文件路径: %batFilePath%
