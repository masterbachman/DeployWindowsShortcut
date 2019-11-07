
@ECHO OFF

:--------------------------------------
:--------------------------------------
:: This block runs the .BAT as an administrator
:: BatchGotAdmin
:: https://superuser.com/questions/788924/is-it-possible-to-automatically-run-a-batch-file-as-administrator
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
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
:--------------------------------------
::Set the application-specific string vars 
SET AppDescription=PlaneWaveInstrumentsIcon
SET IconName=planewave_icon_gva_icon.ico
SET Shortcut_Name=PlaneWave Dashboard.url
SET URL_PATH=https://google.com

::Set the common string vars 
SET WORKING_PATH=%~dp0
SET ICONDEST=%UserProfile%\Pictures\%AppDescription%
SET LinkPath=%userprofile%\Desktop\%Shortcut_Name%

@echo. Copy Icon 
IF EXIST "%ICONDEST%" (GOTO _CopyIcon) 
mkdir "%ICONDEST%"
:_CopyIcon 
copy "%WORKING_PATH%%IconName%" "%ICONDEST%"

echo. 
echo. Create desktop shortcut... 
echo [InternetShortcut] > "%LinkPath%"
echo URL=%URL_PATH% >> "%LinkPath%"
echo IDList= >> "%LinkPath%"
echo IconFile=%ICONDEST%\%IconName%  >> "%LinkPath%"
echo IconFileDirectory *%ICONDEST%\%IconName%*
echo IconIndex=0 >> "%LinkPath%"
echo HotKey=0 >> "%LinkPath%"
echo. 
echo. 
echo. 
echo. 
echo.You should now have a shortcut to %AppDescription% on your desktop... 
echo. 
echo. 
pause 