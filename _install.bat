@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*

    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

mkdir C:\Windows\Ohook
copy activate-office-noclick.cmd C:\Windows\Ohook\activate-office-noclick.cmd /Y
copy silent-activate-office.vbs C:\Windows\Ohook\silent-activate-office.vbs /Y
copy uninstall.bat C:\Windows\Ohook\uninstall.bat /Y

schtasks.exe /Delete /f /tn "Office auto-activation"
schtasks.exe /Create /XML "Office auto-activation.xml" /tn "Office auto-activation"

echo:
echo:           ______________________________________________________
echo:           
echo:                [1] Activate firstly
echo:                                                                          
echo:                [0] Exit installer
echo:           ______________________________________________________
echo:
echo Choose a menu option using your keyboard [1,0] :
choice /c 10 /N
set _erl=%errorlevel%
if %_erl%==1 C:\Windows\Ohook\activate-office-noclick.cmd
if %_erl%==0 exit

