@echo off
title VirusRemovalTool Bootup 
color 2
set appVersion="1.0.6.3"
echo.
:APPLICATION_CONFIGURATION
:: SETTING VARIABLES
set CurrentCD="%cd%"
set CoreCD=%userprofile%\appdata\Roaming\VRT
set OutsideCoreCD=%userprofile%\appdata\Roaming
set SecretCD=%UserProfile%\AppData\Local\VirusRemovalTool
set OutsideSecretCD=%UserProfile%\AppData\Local
set /a MainError="0"
set /a UpdateAvail="0"
set /a admin="0"
set /a CRITICAL="0"
set /a NORMAL="0"
set /a SilentRunErr="0"
set /a NoInternet="0"
set /a FAILED_BOOTCHECK_COUNTER="0"
rem VirusRemovalTool 2021 Copyright
:PRE-ADMIN-CHK
NET SESSION >nul 2>&1
IF %ERRORLEVEL% == "0" set /a admin=1 && goto ADMINBOOT
goto ADMINBOOT

:ADMINBOOT
set /a counter="0"
CD %SecretCD%
findstr "AdminBootup=1" VirusRemovalTool_CONFIG.TXT>NUL
IF ERRORLEVEL 1 (GOTO CORE-ACCESS_CHK) ELSE (GOTO ADMIN-BOOTUP-UPDATECHK)

:: PRE-BOOTUP _REWORK_
:CORE-ACCESS_CHK
:: ASSIGN_BOOTCHK_VARIABLES
set /a MISSING_FILES="0"
set /a STARTERROR="0"
set /a SUCCESFULL_PASS="0"
set /a BOOTCHECK_LOOPER_COUNT="1"
set BOOTCHECK_LOOPERID="ACCESSDENIED"
set BOOTCHECK_SCANDIR="%CoreCD%"
set BOOTCHECK_LOOPER_SCANFILE="VRT_Data.TXT"
:CORE-ACCESS_CHK-LOOPER
:: ASSING_VARS
if %BOOTCHECK_LOOPER_COUNT%==2 set BOOTCHECK_LOOPERID="UNLICENSED_DETECTED" && set BOOTCHECK_SCANDIR=%SecretCD% && set BOOTCHECK_LOOPER_SCANFILE="VirusRemovalTool_CONFIG.TXT"
if %BOOTCHECK_LOOPER_COUNT%==3 set BOOTCHECK_LOOPERID="ACCESSDENIED" && set BOOTCHECK_SCANDIR=%SecretCD% && set BOOTCHECK_LOOPER_SCANFILE="VirusRemovalTool_CONFIG.TXT"
if %BOOTCHECK_LOOPER_COUNT%==5 goto CORE-ACCESS_CHK-2
CD %BOOTCHECK_SCANDIR%
findstr "%BOOTCHECK_LOOPERID%" %BOOTCHECK_LOOPER_SCANFILE%>NUL
if errorlevel 1 (set /a FAILED_PASS+=1) ELSE (SET /A SUCCESFULL_PASS+=1)
set /a BOOTCHECK_LOOPER_COUNT+=1
goto CORE-ACCESS_CHK-LOOPER

:CORE-ACCESS_CHK-2
if %SUCCESFULL_PASS% GEQ 1 set /a FAILED_BOOTCHECK_COUNTER+=1
:: RESET_VARIABLES
set /a SUCCESFULL_PASS="0"
set /a FAILED_PASS="0"
set BOOTCHECK_LOOPERID="VRT"
set /a BOOTCHECK_LOOPER_COUNT="1"
set BOOTCHECK_SCANDIR="%CoreCD%"
:CORE-ACCESS_CHK-2-LOOPER
:: ASSIGNING_LOOPER_DATA
if %BOOTCHECK_LOOPER_COUNT%==1 set BOOTCHECK_LOOPERID="VRT" && set BOOTCHECK_SCANDIR="%OutsideCoreCD%"
if %BOOTCHECK_LOOPER_COUNT%==2 set BOOTCHECK_LOOPERID="VRT_Properties.txt" && set BOOTCHECK_SCANDIR="%CoreCD%"
if %BOOTCHECK_LOOPER_COUNT%==3 set BOOTCHECK_LOOPERID="VirusRemovalTool_CONFIG.txt" && set BOOTCHECK_SCANDIR="%SecretCD%"
if %BOOTCHECK_LOOPER_COUNT%==4 set BOOTCHECK_LOOPERID="Username.txt" && set BOOTCHECK_SCANDIR="%SecretCD%"
if %BOOTCHECK_LOOPER_COUNT%==5 set BOOTCHECK_LOOPERID="VRT_Data.txt" && set BOOTCHECK_SCANDIR="%CoreCD%"
if %BOOTCHECK_LOOPER_COUNT%==6 set BOOTCHECK_LOOPERID="Temp" && set BOOTCHECK_SCANDIR="%CoreCD%"
if %BOOTCHECK_LOOPER_COUNT%==7 set BOOTCHECK_LOOPERID="VirusRemovalTool" && set BOOTCHECK_SCANDIR="%OutsideSecretCD%"
if %BOOTCHECK_LOOPER_COUNT%==8 goto CORE-ACCESS_CHK-EXTRA
:: SCANNING_FOR_TARGET
cd %BOOTCHECK_SCANDIR%
if NOT exist %BOOTCHECK_LOOPERID% (set /a FAILED_PASS+=1) ELSE (set /a SUCCESFULL_PASS+=1)
set /a BOOTCHECK_LOOPER_COUNT+=1
GOTO CORE-ACCESS_CHK-2-LOOPER

:CORE-ACCESS_CHK-EXTRA
if %FAILED_PASS% GEQ 1 set /a FAILED_BOOTCHECK_COUNTER+=1
set EnableExpirimental="UNDEFINED"
CD %CoreCD%
findstr "EnableExpirimental=1" VRT_Properties.txt>NUL
IF ERRORLEVEL 1 ( set EnableExpirimental=FALSE) ELSE ( set EnableExpirimental="TRUE")
cd %CoreCD%
set/p DefinedUsername=<Username.txt
:BOOTCHECK-3
if %FAILED_BOOTCHECK_COUNTER% GEQ 1 ( goto STARTUP-ANOMILY-DETECTED) ELSE ( goto BOOTCHECK-4-RESET_VARIABLES)
echo error.
echo.
timeout /t 3 /nobreak>nul && goto VRT-SAFEMODE_ENTER

:STARTUP-ANOMILY-DETECTED
cls
echo.
echo VRT encounterd an error whilst performing standard BOOTCHECKS!
echo.
echo DEBUG_DATA
echo ------------------------
echo FAILED_BOOTCHECK_COUNTER: %FAILED_BOOTCHECK_COUNTER%
ECHO.
pause>nul
goto VRT-SAFEMODE_ENTER

:BOOTCHECK-4-RESET_VARIABLES
::RESET_VARIABLED
set /a DISABLED_SETTINGS="0"
set /a ENABLED_SETTINGS="0"
set BOOTCHECK_LOOPERID="UNDEFINED"
set /a BOOTCHECK_LOOPER_COUNT="1"
set BOOTCHECK_LOOPER_SCANFILE="VRT_Properties.txt"
set BOOTCHECK_SCANDIR="%CoreCD%"
:BOOTCHECK-4-LOOPER
if %BOOTCHECK_LOOPER_COUNT%==1 rem set BOOTCHECK_LOOPERID="PreviousLockout=1" && set BOOTCHECK_SCANDIR="%SecretCD%" && set BOOTCHECK_LOOPER_SCANFILE="VirusRemovalTool_CONFIG.TXT"
if %BOOTCHECK_LOOPER_COUNT%==2 set BOOTCHECK_LOOPERID="EngageLockdown=1" && set BOOTCHECK_SCANDIR="%CoreCD%" && set BOOTCHECK_LOOPER_SCANFILE="VRT_Properties.txt"
if %BOOTCHECK_LOOPER_COUNT%==3 goto BOOTCHECK-5
::SCANNING_FOR_TARGET
findstr "%BOOTCHECK_LOOPERID%" %BOOTCHECK_LOOPER_SCANFILE%>nul
IF ERRORLEVEL 1 ( set /a DISABLED_SETTINGS+=1) ELSE ( set /a ENABLED_SETTINGS+=1)
set /a BOOTCHECK_LOOPER_COUNT+=1
goto BOOTCHECK-4-LOOPER

:BOOTCHECK-5
goto ENABLE-DISABLE_SAPI

:ACCDENIED-VRT
CD %SecretCD%
color c
CLS
echo.
echo Access Denied to Application
echo.
echo // Even if you reinstall this application you will NOT be able to enter again //
echo.
echo You may have previously tried to re-design or redistribute this application!
echo.
echo ACCESSDENIED >> VirusRemovalTool_CONFIG.TXT
pause> nul
EXIT

:LOCKDOWN-PROCEDURE-2
CD %UserProfile%\AppData\Roaming\VRT\Error-Logs
echo There was an error while logging in to VRT >> Errorlog_%random%.log
color c
cls
echo.
echo Warning! Lockdown mode engaged, please standby!
timeout /t 1 /nobreak>nul
echo Loading...
timeout /t 1 /nobreak>nul && goto LOCKDOWN-DISCORD
exit

:LOCKDOWN-DISCORD
cls
echo.
echo Please Contact ther owner at the discord server!
echo.
echo https://discord.gg/PFfh2ywa
echo.
echo ERROR APPLICATION CANNOT BE UNBLOCKED >> Errorlog_%random%.log
echo.
CD %UserProfile%\AppData\Roaming\VRT
echo ACCESSDENIED >> VRT_Data.TXT
echo.
CD %UserProfile%\AppData\Local\VirusRemovalTool
echo ACCESSDENIED >> VirusRemovalTool_CONFIG.TXT
ping -n 6 127.0.0.1>nul
GOTO ACCDENIED-VRT

:DESKTOP-UPDATE2
cls
echo.
echo.
echo Application Update Locations...
echo.
echo ==============================================================
echo %UserProfile%\AppData\Roaming (Folder name: VRT)
echo %UserProfile%\AppData\Local (Folder name: VirusRemovalTool)
echo ==============================================================
echO.
set /P c=Do you want to download the update[Y/N]?
if /I "%c%" EQU "Y" goto :APPLICATION_INSTALL-DECLARE_VARS
if /I "%c%" EQU "N" EXIT

:APPLICATION_INSTALL-DECLARE_VARS
SetLocal EnableDelayedExpansion
set INSTALLER_ID="PREPARING"
set /a INSTALLER_LOOPCOUNT="0"
set /a INSTALLER_DIR="%OutsideCoreCD%"
:APPLICATION_INSTALL-LOOPER
set 
color 2
title INSTALLING_APPLICATION...
echo.
echo Installing Application. . .[%INSTALLER_ID%]
:: ASSIGNING_LOOPERCOUNTER-ID
if %INSTALLER_LOOPCOUNT%==1 set INSTALLER_ID="MAIN_FILES" && cd %OutsideCoreCD% && md VRT
if %INSTALLER_LOOPCOUNT%==2 set INSTALLER_ID="CORE_MODULE" && cd %CoreCD% && md Error-Logs && MD Extra_Modules echo \ Ussername Configuration Files \ >> UserConfig.txt && echo Username_Defined=false >> UserConfig.txt && Username=none >> UserConfig.txt
if %INSTALLER_LOOPCOUNT%==3 set INSTALLER_ID="TEMP_FILES" && cd %CoreCD% && MD Temp && echo ---------------DATA_STORAGE---------------- > VRT_Data.txt && VirusRemovalTool - PROPERTIES > VRT_Data.txt
if %INSTALLER_LOOPCOUNT%==4 set INSTALLER_ID="BACKUPS_MODULE" && cd %CoreCD% && MD Backups && MD Quarantine && cd %UserProfile%\AppData\Roaming\VRT\Backups && echo. > VRT_Backup.txt
if %INSTALLER_LOOPCOUNT%==5 set INSTALLER_ID="SETTING_PROPERTIES" && cd %CoreCD% && // DO NOT EDIT THE LOCKDOWN OPTION AS YOU WILL NOT BE ABLE TO GO BACK IN THIS APPLICATION EVEN IF YOU EDIT IT BACK // >> VRT_Properties.txt && echo EnableSapi=0 >> VRT_Properties.txt && echo AnalyseFilePermission=1 >> VRT_Properties.txt && SkipWelcomeScene=0 >> VRT_Properties.txt && echo EngageLockdown=0 >> VRT_Properties.txt && echo SetMainError=0 >> VRT_Properties.txt && echo EnableExpirimental=0 >> VRT_Properties.txt
if %INSTALLER_LOOPCOUNT%==6 set INSTALLER_ID="BACKUP_FOLDER" && cd %OutsideSecretCD% && md VirusRemovalTool && md Cache && echo PreviousLockout=0 >> VirusRemovalTool_CONFIG.txt && echo Version==%version% >> VirusRemovalTool_CONFIG.txt && echo AdminBootup=0 >> VirusRemovalTool_CONFIG.txt && echo UpdateStatus=Updated && echo --------TempValueSetV1------- >> TempValueSet.txt
if %INSTALLER_LOOPCOUNT%==7 goto INSTALLING_APPLICATION-SET_USERNAME
timeout /t 1 /nobreak>nul && goto APPLICATION_INSTALL-LOOPER

:INSTALLING_APPLICATION-SET_USERNAME
cls
echo.
echo Hello! What should we call you?
echo.
set /p USER=Please enter your name=
cd %CoreCD%
  SETLOCAL=ENABLEDELAYEDEXPANSION

    rename UserConfig.TXT UserConfig.tmp
    for /f %%a in (UserConfig.tmp) do (
        set foo=%%a
        if !foo!==Username=none set foo=Username=%USER%
        echo !foo! >> UserConfig.TXT) 
del UserConfig.tmp
cd %CoreCD%
  SETLOCAL=ENABLEDELAYEDEXPANSION

    rename UserConfig.TXT UserConfig.tmp
    for /f %%a in (UserConfig.tmp) do (
        set foo=%%a
        if !foo!==Username_Defined=false set foo=Username_Defined=true
        echo !foo! >> UserConfig.TXT) 
del UserConfig.tmp
GOTO USERNAME_CONFIG

:USERNAME_CONFIG
cd %CoreCD%
  SETLOCAL ENABLEDELAYEDEXPANSION

    rename UserConfig.TXT UserConfig.tmp
    for /f %%a in (UserConfig.tmp) do (
        set foo=%%a
        if !foo!==Username_Defined=false set foo=Username_Defined=true
        echo !foo! >> UserConfig.TXT) 
del UserConfig.tmp
echo.
echo Writing Name to Memory. . .
cd %SecretCD%
echo %NAME% > UserName.txt
timeout /t 1 /nobreak>nul && goto ENABLE-DISABLE_SAPI



echo error.
pause>nul
exit

:OUTDATED_UPDATE
cls
echo.
echo Setting Username Properties...
echo.
timeout /t 2 /nobreak>nul
cls
echo.
title Configuring App...(2/3)
echo Adding Username Config...
color 2
cd %UserProfile%\AppData\Roaming
cls
md VRT
cd %UserProfile%\AppData\Roaming\VRT
echo \ Username Configuration File / >> UserConfig.TXT
echo. >> UserConfig.TXT
echo Username_Defined=false >> UserConfig.TXT
echo Username=none >> UserConfig.TXT
md Error-Logs
md Extra_Modules
SetLocal EnableDelayedExpansion
cd %UserProfile%\AppData\Roaming\VRT
md Temp
if %errorlevel% equ 1 GOTO MAIN-UPDATE-ERR-1
echo.
timeout /t 1 /nobreak>nul
cd %UserProfile%\AppData\Roaming\VRT
echo.
echo --------------DATA STORAGE------------- >> VRT_Data.TXT
echo.
echo VirusRemovalTool Properties >> VRT_Properties.txt
md Backups
echo.
md Quarantine
echo.
cd %UserProfile%\AppData\Roaming\VRT\Backups
echo.
echo. >> VRT-Backup.txt
ping -n 2 127.0.0.1>nul
GOTO DESKTOP-UPDATE_VERIFY

:DESKTOP-UPDATE_VERIFY
cd %UserProfile%\AppData\Roaming\VRT
if exist Quarantine GOTO DESKTOP-PROPERTIES
if not exist Quarantine GOTO DESKTOP-ERROR_1

:DESKTOP-PROPERTIES
cd %UserProfile%\AppData\Roaming\VRT
echo // DO NOT EDIT THE LOCKDOWN OPTION AS YOU WILL NOT BE ABLE TO GO BACK IN THIS APPLICATION EVEN IF YOU EDIT IT BACK // >> VRT_Properties.txt
echo EnableSapi=0 >> VRT_Properties.txt
echo AnalyseFilePermission=1 >> VRT_Properties.txt
echo SkipWelcomeScene=0 >> VRT_Properties.txt
echo EngageLockdown=0 >> VRT_Properties.txt
echo SetMainError=0 >> VRT_Properties.txt
echo EnableExpirimental=0 >> VRT_Properties.txt
echo.
cls
GOTO LOGIN-SYS

:LOGIN-SYS
GOTO APPDATA

:APPDATA
cd %UserProfile%\AppData\Local
echo.
md VirusRemovalTool
cd %UserProfile%\AppData\Local\VirusRemovalTool
md Cache
if %ERRORLEVEL%==1 GOTO UPDATE-ERROR
echo.
cd %UserProfile%\AppData\Local\VirusRemovalTool
echo. >> AnalyseRegularFiles.txt
echo.
echo PreviousLockout=0 >> VirusRemovalTool_CONFIG.txt
echo Version==%version% >> VirusRemovalTool_CONFIG.txt
echo AdminBootup=0 >> VirusRemovalTool_CONFIG.txt
echo UpdateStatus=Updated
echo.
echo --------TempValueSetV1------- >> TempValueSet.txt
GOTO USERCONFIG

:USERCONFIG
cd %UserProfile%\AppData\Roaming\VRT
findstr "Username_Defined=false" UserConfig.TXT>NUL
IF ERRORLEVEL 1 (GOTO ENABLE-DISABLE_SAPI) ELSE (GOTO SET-USERNAME)

:DESKTOP-ERROR
GOTO DESKTOP-ERROR_1

:SET-USERNAME
title Configuring App...(3/3)
cls
echo.
echo Hello! What should we call you?
echo.
echo.
set /p USER=Please enter your name=
GOTO SET-USERNAME_1

:ADMIN-BOOTUP
cls
echo.
echo Admin Bootup Selected
echo.
echo [User=Not avail] - [[%Version%]]
echo.
ECHO 1 - Normal Bootup
ECHO 2 - Admin Menu
ECHO 3 - Enter Safemode
ECHO 4 - Reinstall Side Application Files [RSAF Program]
ECHO 5 - Load Command Prompt
ECHO 6 - Reset Bootup Status
echo.

set /p OPT=Please select an action:
if %OPT% equ 1 GOTO ENABLE-DISABLE_SAPI
if %OPT% equ 2 GOTO dev
if %OPT% equ 3 GOTO VRT-SAFEMODE_ENTER
if %OPT% equ 4 GOTO RSIF
if %OPT% equ 5 GOTO ADMIN-PROMPT
if %OPT% equ 6 GOTO RST-ADMIN

:RST-ADMIN
cd %UserProfile%\AppData\Local\VirusRemovalTool
  SETLOCAL=ENABLEDELAYEDEXPANSION

    rename VirusRemovalTool_CONFIG.TXT VirusRemovalTool_CONFIG.tmp
    for /f %%a in (VirusRemovalTool_CONFIG.tmp) do (
        set foo=%%a
        if !foo!==AdminBootup=1 set foo=AdminBootup=0
        echo !foo! >> VirusRemovalTool_CONFIG.TXT) 
del VirusRemovalTool_CONFIG.tmp
echo.
GOTO ADMIN-BOOTUP_LOAD

:ADMIN-BOOTUP_LOAD
cls
echo.
echo Revoking Admin Bootup Privileges...
echo.
ping -n 4 127.0.0.1>nul
GOTO ADMIN-BOOTUP

:MAIN-UPDATE-ERR-1
cls
COLOR c
echo.
echo There was an error while configuring an important update!
echo.
echo Please run RSAF or Reinstall command to use this application.
echo.
pause> nul
GOTO VRT-SAFEMODE_ENTER

:RSIF
cls
echo Reinstalltation Program (DEV) [[Reinstall Side Application Files]]
echo.
echo.
pause
echo.
cd %UserProfile%\AppData\Roaming
echo.
rmdir /s /q VRT
cls
echo.
echo VRT Folder Deleted...(1/2)
ping -n 4 127.0.0.1>nul
echo
cd %UserProfile%\AppData\Local
echo.
rmdir /s /q VirusRemovalTool
echo VirusRemovalTool Folder Deleted...(2/2)
ping -n 4 127.0.0.1>nul
goto RSIF-CHK

:RSIF-CHK
cd %UserProfile%\AppData\Roaming
if exist VRT GOTO RSI-ERROR-VRT
if not exist VRT GOTO RSIF-CHK-2

:RSIF-CHK-2
cd %UserProfile%\AppData\Local
if exist VirusRemovalTool GOTO RSIF-ERROR-VRT0
if not exist VirusRemovalTool GOTO RSIF-COMPLETED

:RSIF-ERROR-VRT
cls
echo.
echo Main VRT folder could not been deleted!
pause> nul 
GOTO ADMIN-BOOTUP

:RSIF-ERROR-VRT0
cls
echo.
echo Backup VRT folder could not been deleted!
pause> nul
GOTO ADMIN-BOOTUP

:RSIF-COMPLETED
cls
echo.
echo Completed!
echo.
echo Restart For download...
echo.
pause
exit

:DESKTOP-ERROR_1
cls
echo.
echo There was an error while configuring an important update!
echo.
echo Click "enter" to enter safemode
pause> nul
GOTO VRT-SAFEMODE_ENTER

:ENABLE-DISABLE_SAPI
CD %UserProfile%\AppData\Roaming\VRT
findstr "EnableSapi=1" VRT_Properties.TXT>NUL
IF ERRORLEVEL 1 (GOTO WELCOME-SCREEN-SKIP) ELSE (GOTO SKIPSCENE)

:SKIPSCENE
CD %UserProfile%\AppData\Roaming\VRT
findstr "SkipWelcomeScene=1" VRT_Properties.TXT>NUL
IF ERRORLEVEL 1 (GOTO SAPI) ELSE (GOTO OFF-CONNECTION-TEST)

:SAPI
CD %UserProfile%\AppData\Roaming\VRT\Temp
echo StrText="Welcome to Virusremovaltool" > Sapi.vbs
echo set ObjVoice=CreateObject("SAPI.SpVoice") >> Sapi.vbs
echo ObjVoice.Speak StrText >> Sapi.vbs
start Sapi.vbs
echo.
del /q Sapi.vbs
GOTO WELCOME-SCREEN-SKIP

:WELCOME-SCREEN-SKIP
CD %UserProfile%\AppData\Roaming\VRT
findstr "SkipWelcomeScene=1" VRT_Properties.TXT>NUL
IF ERRORLEVEL 1 (GOTO WELCOME-SCREEN) ELSE (GOTO OFF-CONNECTION-TEST)

:WELCOME-SCREEN
cls
goto SEGLOGON_ORG
echo.                                                     
echo                   `------------`                  
echo                 .:/:.`        `.:/:.               
echo              :o:.                .:o.             
echo             -oo                    -/-            
echo             /.-+-                  `.+            
echo            --   -//.                 --           
echo            :. `   `:++:`.. ``...`  ` .:           
echo            --.:.`..--.-:/oyhysssso:-.--           
echo             +-.+yhhhhh+.`/hhhhhhhhhy:+            
echo             `s.hhhhhhhh/..yhhhhhhhhs+.            
echo              :.:osssso/.yy.+hhhhhs:.:             
echo             :/``.`  `.-ohho. ...````:: `          
echo              .-/:+o: `:osso:` :o+:/-.             
echo                +:oh+.```  ```.+ho:+               
echo                +`-ho/:::--:::/oh-`+               
echo                ::.-+/:::--:::/+-./:               
echo                 :/-.``---.-.``.-/:                
echo                   `:-`..``-..-:`                  
echo                     .:------:.                    
echo.              
echo            Starting VirusRemovalTool...               
echo.
timeout /t 2 /nobreak>nul && GOTO SEGLOGON_ORG

:SEGLOGON_ORG
CD %UserProfile%\AppData\Roaming\VRT
findstr "TOS-AGREED" VRT_Data.TXT>NUL
IF ERRORLEVEL 1 ( GOTO TUTORIAL) ELSE ( GOTO officalstart)

:TUTORIAL
cls
echo.
echo Welcome to VirusRemovalTool!
echo.
echo Please read the TOS agreement.
echo.
echo 1. VRT_Data.txt
echo.
echo This is the cookie file it is stored in whatever dictonary you open this file in!
echo You can reset your file if it becomes too large but it does reset everything.
echo Read more about this file on "Data Collection"
echo.
echo 2. Code Editing
echo.
echo This Application is entirely owned by Cybernetic
echo Code Editing is allowed but you will need to contact the owner at: 0095296@wellant.nl for conformation 
echo Do NOT make copies Pirated apps will be found deleted and the owners will be fined.
echo.
echo 3. VRT_Properties.txt
echo.
echo VRT_Properties.txt is a file that stores data like have you read the tos, do you want to enable or disable voiches?
echo This file does NOT store any user data!
echo.
echo 4. Data Collecting
echo.
echo This application does not share data with third party incorparations VRT does include a cookie file called: VRT_Data.TXT
echo We do have a survey but the survey is anounymous and does and we cannot see any emails from poeple that took the survey
echo this survey is only for suggestions, bug reports, and feedback VRT will NOT share any collected data in the future.
echo.
echo.
ECHO BY CLICKING "ENTER" YOU AGREE WITH THE TOS!
pause> nul
GOTO tos-agreement

:tos-agreement
cd %UserProfile%\Appdata\Roaming\VRT
echo TOS-AGREED >> VRT_Data.txt
GOTO FIRST-TUTORIAL

:FIRST-TUTORIAL
cls
echo.
echo Hello there! Welcome to this application.
echo.
echo This is a tutorial from how you use this application, you can view this anytime you want in the "Extras" option!
echo.
ECHO 1. INFO
echo.
echo Info is for general info and specific information it is a new feature and not everything works but it can be helpfull!
echo.
ECHO 2. OPTIMIZER
echo.
echo Optimizer options are for your pc cleaning your pc and Corrupted file checker and much more!
echo.
ECHO 3. CONSOLE
echo.
echo you can view the console as a shortcut altho it has it's own features!
echo.
ECHO 4. VIRUS INTELLIGENCE 
echo.
echo This is the main option you can scan files scan process you can use Counter Virus Payload
echo.
ECHO 5. SAFEMODE
echo.
echo Safemode is for options like repairing your files or reinstalling!
echo.
echo.
echo Enjoy Your Application!
echo.
echo.
pause> nul
GOTO officalstart

:DESKTOP-SUC
cls
echo.
echo Update Succesfully Installed...!
echo.
pause> nul
GOTO SET_PROPERTIES-1

:SET_PROPERTIES-1
GOTO officalstart

:DESKTOP-FAIL
cls
echo.
echo Update Failed 
echo.
echo Reason: "UserProfile\AppData\Roaming\VRT\Backups" Does NOT exist!
echo.
echo.
pause> nul
GOTO officalstart

:VRT-SAFEMODE_ENTER
:SAFEMODE-UI 
cls
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Application Rescue Mode
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Repair Your Application.
echo.
echo {Running Version= %version%}
echo.
echo Errorlevel= %ERRORLEVEL%
echo.
echo.
ECHO 1 - Reinstall Application 
ECHO 2 - Error Repair
ECHO 3 - Exit Application
echo.

set /p opt=Put in safemode action here:
if %opt% equ 1 goto REINSTALL
if %opt% equ 2 goto REPAIR-LOAD
if %opt% equ 3 exit

:REPAIR-LOAD
set load=
set/a loadnum=0
set/a loadper=0
set/a counter=0

:Loading-REP
title Repair Diagnostics...
set load=%load%           
cls
echo.
echo Starting Error Diagnostics...(%loadper%%%)
echo -------------------------------------------------------------------------------------------------------------
echo %load%
echo -------------------------------------------------------------------------------------------------------------
echo.
echo ______________________________________
echo        File Diagnostics Status
echo.
If %counter% equ 1 echo VRT (Dictonary)
If %counter% equ 2 echo VRT_Properties.txt
If %counter% equ 3 echo VRT_Data.txt
If %counter% equ 4 echo Backups (Dictonary)
if %counter% equ 5 echo VirusRemovalTool (Dictonary)
if %counter% equ 6 echo Quarantine (Dictonary)
if %counter% equ 7 echo Temp (Dictonary)
if %counter% equ 8 echo Error-Logs (Dictonary)
if %counter% equ 9 echo Collecting Results...
echo.
echo ______________________________________
echo.
echo.
ping localhost -n 2 >nul

set/a loadnum=%loadnum% +11
set/a loadper=%loadper% +11
if %loadnum% GEQ 100 goto REPAIR
if %loadnum% GEQ 30 goto setload
if %loadnum% GEQ 50 goto setload
if %loadnum% GEQ 60 goto setload
if %loadnum% GEQ 70 goto setload
if %loadnum% GEQ 80 goto setload
if %loadnum% GEQ 90 goto setload
if %loadnum% GEQ 11 goto setload
if %loadnum% GEQ 17 goto setload
if %loadnum% GEQ 90 goto setload

:setload
set /a counter+=1
GOTO Loading-REP

:REPAIR
set /a counter=0
set /a error=0
cls
cd %userprofile%\AppData\Roaming
if exist VRT GOTO REPAIR-1
if not exist VRT GOTO REPAIR-0-ERR

:REPAIR-0-ERR
cd %userprofile%\Appdata\Roaming
MD VRT
set /a counter+=1
echo.
GOTO REPAIR-1

:REPAIR-1
cd %userprofile%\Appdata\Roaming\VRT
if exist VRT_Properties.txt GOTO REPAIR-2
if not exist VRT_Properties.txt GOTO REPAIR-1-ERR

:REPAIR-1-ERR
cd %userprofile%\Appdata\Roaming\VRT
echo.
DEL VRT_Properties.txt /Q
echo VirusRemovalTool Properties >> VRT_Properties.TXT 
echo EnableSapi=0 >> VRT_Properties.TXT
echo AnalyseFilePermission=1 >> VRT_Properties.TXT 
echo SkipWelcomeScene=0 >> VRT_Properties.TXT
echo EngageLockdown=0 >> VRT_Properties.TXT
echo SetMainError=0 >> VRT_Properties.TXT
echo EnableExpirimental=0=0 >> VRT_Properties.TXT
echo.
set /a counter+=1
echo.
GOTO REPAIR-2

:REPAIR-2
cd %userprofile%\Appdata\Roaming\VRT
if exist VRT_Data.TXT GOTO REPAIR-3
if not exist VRT_Data.TXT GOTO REPAIR-2-ERR

:REPAIR-2-ERR
cd %userprofile%\Appdata\Roaming\VRT
echo //REPAIRED FILE// >> VRT_Data.txt
set /a counter+=1
GOTO REPAIR-3

:REPAIR-3
cd %userprofile%\Appdata\Roaming\VirusRemovalTool
if exist Backups GOTO REPAIR-4
if not exist Backups GOTO REPAIR-3-ERR

:REPAIR-3-ERR
cd %userprofile%\Appdata\Roaming\VirusRemovalTool
md Backups
set /a counter+=1
GOTO REPAIR-4

:REPAIR-4
cd %userprofile%\Appdata\Local
if exist VirusRemovalTool GOTO REPAIR-5
if not exist VirusRemovalTool GOTO REPAIR-4-ERR

:REPAIR-4-ERR
cd %userprofile%\Appdata\Local
MD VirusRemovalTool
echo.
set /a counter+=1
GOTO REPAIR-5

:REPAIR-5
cd %UserProfile%\AppData\Roaming\VRT
if exist Temp GOTO REPAIR-6
if not exist Temp GOTO REPAIR-5-ERR

:REPAIR-5-ERR
cd %userprofile%\appdata\roaming\VRT
echo.
MD Temp
set /a counter+=1
GOTO REPAIR-6

:REPAIR-6
cd %Userprofile%\AppData\Roaming\VRT
if exist Quarantine GOTO REPAIR-7
if not exist Quarantine GOTO REPAIR-6-ERR

:REPAIR-6-ERR
cd %Userprofile%\AppData\Roaming\VRT
cls
md Quarantine
echo.
set /a counter+=1
GOTO REPAIR-7

:REPAIR-7
cd %UserProfile%\AppData\Local\VirusRemovalTool
if exist VirusRemovalTool_CONFIG.txt GOTO REPAIR-8
if not exist VirusRemovalTool_CONFIG.txt GOTO REPAIR-7-ERR

:REPAIR-7-ERR
cd %UserProfile%\AppData\Local\VirusRemovalTool
echo.
echo PreviousLockout=0 >> VirusRemovalTool_CONFIG.txt
echo.
set /a counter+=1
GOTO REPAIR-8

:REPAIR-8
cd %Userprofile%\AppData\Roaming\VRT
if exist Error-Logs GOTO REPAIR-9
if not exist Error-Logs GOTO REPAIR-8-ERR

:REPAIR-8-ERR
cd %userprofile%\Appdata\Roaming\VRT
echo.
md Error-Logs
echo.
set /a counter+=1
GOTO REPAIR-9

:REPAIR-9
cd %Userprofile%\AppData\Local\VirusRemovalTool
if exist Username.TXT GOTO REPAIR-10
if not exist Username.TXT GOTO REPAIR-9-ERR

:REPAIR-9-ERR
cls
echo.
echo Automatic Repair Prompt.
echo.
echo While repairing your application we lost your name!
echo.
set /a counter+=1
set /p name=Please select your name:
GOTO REPAIR-9-ERR2

:REPAIR-9-ERR2
cd %UserProfile%\AppData\Roaming\VRT
echo //USERNAME CONFIG [AUTO REPAIR]// >> Userconfig.TXT
echo Username_Defined=true >> Userconfig.TXT
echo Username=%name% >> Userconfig.TXT
echo.
cd %Userprofile%\AppData\Local\VirusRemovalTool
echo %name% >> Username.TXT
GOTO REPAIR-10

:REPAIR-10
GOTO REPAIR-13

:REPAIR-13
cd %UserProfile%\Appdata\Roaming\VRT
set file=VRT_Properties.TXT
set /a cnt=0
for /f %%a in ('type "%file%"^|find "" /v /c') do set /a cnt=%%a
if %cnt% LSS 6 GOTO REPAIR-13-ERR
GOTO REPAIR-14

:REPAIR-13-ERR
cd %UserProfile%\Appdata\Roaming\VRT
DEL VRT_Properties.TXT
echo VirusRemovalTool Properties >> VRT_Properties.TXT 
echo EnableSapi=0 >> VRT_Properties.TXT
echo AnalyseFilePermission=1 >> VRT_Properties.TXT 
echo SkipWelcomeScene=0 >> VRT_Properties.TXT
echo EngageLockdown=0 >> VRT_Properties.TXT
echo SetMainError=0 >> VRT_Properties.TXT
echo EnableOfflineMode=0 >> VRT_Properties.TXT
set /a error+=1
GOTO REPAIR-14

:REPAIR-14
cd %UserProfile%\AppData\Roaming\VRT
if exist Extra_Modules GOTO REPAIR-COMPLETED
if not exist Extra_Modules GOTO REPAIR-14-ERR

:REPAIR-14-ERR
cd %UserProfile%\AppData\Roaming\VRT
md Extra_Modules
echo.
set /a counter+=1
GOTO REPAIR-COMPLETED


:REPAIR-COMPLETED
cls
echo.
echo Collecting Results...
ping -n 2 127.0.0.1>nul
cls
echo.
echo Repair Results.
echo.
echo _________________________
echo %counter% files missing.
echo %error% errors detected.
echo _________________________
echo.
if %counter% LSS 1 echo No files were repaired!
if %counter% GEQ 1 echo Corrupted files repaired!
if %error% LSS 1 echo No software errors repaired!
if %error% GEQ 1 echo Software errors repaired!
echo.
echo.
if %counter% GEQ 1 echo (If you still get an error message then reinstall this application)
echo.
pause> nul
GOTO RP-CHK

:RP-CHK
CD %UserProfile%\AppData\Roaming\VRT\Temp
findstr "ConsoleVerif" ConsoleVerif.TXT>NUL
IF ERRORLEVEL 1 (GOTO SAFEMODE-UI) ELSE (GOTO RP-DEL)

:RP-DEL
CD %UserProfile%\AppData\Roaming\VRT\Temp
DEL ConsoleVerif.TXT
GOTO CONSOLE-COMMAND

:REINSTALL
cls
echo.
echo Reinstall Side Application Files (RSAF)
echo.
echo.
set /P c=Do you want to Reinstall Core Files[Y/N]?
if /I "%c%" EQU "Y" goto :RA
if /I "%c%" EQU "N" goto :GOTO OFFICAL-ERROR_SET

:RA
cls
echo.
echo Deleting Application Files...(1/3)
echo.
ping -n 4 127.0.0.1>nul
echo.
cd %UserProfile%\AppData\Roaming
echo.
rmdir /s /q VRT
echo.
echo Updating...(2/3)
ping -n 2 127.0.0.1>nul
echo
cd %UserProfile%\AppData\Local
echo.
rmdir /s /q VirusRemovalTool
echo Rerouting...
GOTO RA-CHK-2

:RA-CHK-2
cd %UserProfile%\AppData\Local
if exist VirusRemovalTool GOTO RA-ERROR-VRT0
if not exist VirusRemovalTool GOTO RA-COMPLETED

:RA-ERROR-VRT
cls
echo.
echo Main VRT folder could not been deleted!
echo.
echo.
pause> nul 
GOTO ADMIN-BOOTUP

:RA-ERROR-VRT0
cls
echo.
echo Backup VRT folder could not been deleted!
echo.
echo.
pause> nul
GOTO ADMIN-BOOTUP

:RA-COMPLETED
cls
echo.
echo Application Files Succesfully Deleted!
echo.
ping -n 4 127.0.0.1>nul
GOTO DESKTOP-UPDATE2

:OFFICAL-ERROR_SET
cd %UserProfile%\AppData\Roaming\VRT\Temp
echo ErrorCode=RUNTIME_ERROR >> RUNTIME-ERROR.TXT
echo.
cd %UserProfile%\AppData\Roaming\Error-Logs
echo Runtime Error (Reinstall Denied) >> Errorlog_%random%.TXT 
GOTO OFFICAL-ERROR

:OFFICAL-ERROR
cls
echo.
echo \\ VirusRemovalTool Error Menu \\
echo.
echo {Running Version=%version%}
echo.
echo Error: RUNTIME ERROR
echo.
ECHO 1 - Enter safemode
echo.
echo For help Please goto the discord server!
echo.
SET /P OPT=Put in an action here:
if %OPT% equ 1 GOTO VRT-SAFEMODE_ENTER
pause> nul
GOTO OFFICAL-ERROR

:offline-mode
set/a offline+=1
GOTO officalstart

=======================================================================================================================
:officalstart
cd %UserProfile%\AppData\Local\VirusRemovalTool
for /f "delims=" %%x in (Username.txt) do set userID=%%x
color 2
cls
title MRT V%version%
if %admin% equ 1 title VRT ~ [RUNNING VERSION] {%version%} // [ELEVATED PERMISSIONS]
echo.
echo [96m++++++++++++++++++++++++++++++++[0m
echo [96m+[91mMalwareRemovalTool[0m            [96m+[0m
echo [96m+[92mCurrentVer : V%version%[0m           [96m+[0m
echo [96m+[94mKartana Software[0m              [96m+[0m
echo [96m++++++++++++++++++++++++++++++++[0m
if %admin%==1 echo [ADMINISTRATOR] 
if %MainError% GEQ 1 goto officalstart-Err-2
if %UpdateAvail%==1 echo [UPDATE AVAILABLE] - [New Version=%GetVer%]
if %CRITICAL%==1 echo [CRITICAL UPDATE]
if %NORMAL%==1 echo [NORMAL UPDATE]
echo.
echo.
ECHO 1 - Info
ECHO 2 - Optimizer Options
ECHO 3 - Build-In Tools
ECHO 4 - Virus Intelligence
ECHO 5 - Safemode
ECHO 6 - Extras
echo.
if %ERRORLEVEL% equ 1 GOTO NOT_FOUND404
if not exist Username.TXT GOTO officalstart-Err
echo [96m------------------------------[0m
echo User ID: [92m%userID%[0m
echo [96m------------------------------[0m
echo.

set /p opt=Please select an action:
if %OPT%==1 GOTO INFO
if %OPT%==2 GOTO Optimizer
if %OPT%==3 GOTO APP_TOOLS
if %OPT%==4 GOTO VIRUSINTEL
if %OPT%==5 GOTO VRT-SAFEMODE_ENTER
if %OPT%==6 GOTO ENABLE/DISABLE_OPEN
if %OPT%==9 GOTO EXTRAS
if %OPT%==100 GOTO dev
if %OPT%==else GOTO NOT_FOUND404
if %ERRORLEVEL%==1 GOTO SORRY

:NOT_FOUND404
cls
echo.
echo Command Not found 404
echo.
pause> nul
GOTO NOT_FIN

:AI_INSTALL-CHK-PROMPT
cls
echo.
echo AI Program is a work in progress!
echo.
echo Expected release date: Unknown
pause> nul
goto officalstart

:officalstart-Err
cd %Userprofile%\AppData\Local\VirusRemovalTool
cls
echo.
echo Warning Username not configured!
echo.
echo.
echo Please use RSAF command to reinstall the application and configure your Username!
echo.
if exist Username.txt echo Reason: Username not correctly written to file
if not exist Username.txt echo Reason: Username File does NOT exist
echo.
ping -n 8 127.0.0.1>nul
GOTO VRT-SAFEMODE_ENTER

officalstart-Err-2
cd %UserProfile%\AppData\Roaming

:APP_TOOLS
CLS
echo.
echo 1 - Update Application
echo 2 - Open Settings 
echo 3 - File Destroyer
echo 4 - String Encryption [BETA]
echo.
echo 5 - Return
echo.
set/p opt=Please select an option:
if %opt%==1 goto UPDATER-APP
if %opt%==2 goto ehfiehfie
if %opt%==3 goto TOOLS-FILE_DESTROYER
if %opt%==4 goto TOOLS-STRING_ENCRYPTION
if %opt%==5 goto officalstart


:SOCIAL
cls
echo.
echo Welcome to the Social Menu!
echo.
ECHO 1 - Discord Server
ECHO 2 - Website {Not Finished}
ECHO 3 - Rate/Feedback (Anounymous)
echo.

set /p opt=
if %opt% equ 1 GOTO DISCORD-Redirect 
if %opt% equ 2 GOTO OFFICAL-ERROR
if %opt% equ 3 GOTO RATING 

:SECURITY_SCAN
cls
echo.
echo The Security Scan checks the system for hidden malware!
echo.
ECHO 1 - Start Scan
ECHO 2 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto SECURITY_SCAN-START
if %OPT%==2 goto officalstart

:SECURITY_SCAN-START
set/a TotalSec=0
set/a gumb=0
set/a zucn=0
set/a dqcn=0
set/a TotalSecurityDetections=0
cls
echo.
echo Running Security Scan...
echo.
setlocal EnableExtensions DisableDelayedExpansion
set "HostsFile=%SystemRoot%\System32\drivers\etc\hosts"
%SystemRoot%\System32\findstr.exe /I /L /C:"gumblar.cn" %HostsFile% >nul
if %errorlevel% equ 0 set/a gumb=1 && set/a TotalSec+=1
%SystemRoot%\System32\findstr.exe /I /L /C:"38zu.cn" %HostsFile% >nul
if %errorlevel% equ 0 set/a zucn=1 && set/a TotalSec+=1
%SystemRoot%\System32\findstr.exe /I /L /C:"d99q.cn" %HostsFile% >nul
if %errorlevel% equ 0 set/a dqcn=1 && set/a Totalsec+=1
echo.
if %TotalSec% GEQ 1 set/a TotalSecurityDetections+=1
echo Security Scan Results
echo.
echo =============================================================================
echo.
echo Malicious Hosts Entries Found = %Totalsec%
echo.
pause> nul

:EXTRAS
cls
echo.
echo Extra App Features
echo.
ECHO 1 - Log Options
ECHO 2 - Show TOS
ECHO 3 - Delete Side Files (NO AUTOMATIC DOWNLOAD)
ECHO 4 - Social Menu
ECHO 5 - TroubleShooting
ECHO 6 - Help
ECHO 7 - View Tutorial
ECHO 8 - Go Back
echo.

set /p opt=put in action here:
if %opt% equ 1 GOTO LOGOPT
if %opt% equ 2 GOTO TUTORIAL
if %opt% equ 3 GOTO DELFL-PROMPT
if %opt% equ 4 GOTO SOCIAL
if %opt% equ 5 GOTO TROUBLESHOOT
if %opt% equ 6 GOTO HELP-MENU
if %opt% equ 7 GOTO FIRST-TUTORIAL
if %opt% GEQ 8 GOTO officalstart

:DELFL-PROMPT
cls
echo.
set /P c=Do you want to delete all files[Y/N]?
if /I "%c%" EQU "Y" goto :DELFL-EXTRAS
if /I "%c%" EQU "N" goto :EXTRAS

:DELFL-EXTRAS
cls
echo.
echo Deleting files...
echo.
cd %UserProfile%\Appdata\Roaming
rmdir /s /q VRT
echo.
cd %UserProfile%\AppData\Local
rmdir /s /q VirusRemovalTool
ping -n 2 127.0.0.1>nul
echo.
echo Deletion Complete!
echo.
ping -n 2 127.0.0.1>nul
echo.
set /P c=Do you want to reinstall all files[Y/N]?
if /I "%c%" EQU "Y" goto :DESKTOP-UPDATE2
if /I "%c%" EQU "N" goto :EXTRAS

:CREDITS
cls
echo.
echo Programmer_______ME
echo Publisher________ME
echo Update Manager___ME
echo.
echo :D
echo.
echo Kortana Software
echo.
pause> nul
GOTO EXTRAS

:TROUBLESHOOT
set /a counter=0
cls
echo.
echo Troubleshooting Options
echo.
ECHO 1 - Configure Update
ECHO 2 - Go back

set /p opt=Please select an action:
if %OPT% EQU 1 GOTO CONFIG-UPDATE-CHK
if %OPT% EQU 2 GOTO officalstart

:CONFIG-UPDATE-CHK
cd %Userprofile%\AppData\Roaming\VRT
if exist VRT_Properties.TXT GOTO CONFIG-UP-SET-2
if not exist VRT_Properties.TXT GOTO CONFIG-UP-SET-1

:CONFIG-UP-SET-2
GOTO CONFIG-UPDATE-TR

:CONFIG-UP-SET-1
set /a counter+=1
GOTO CONFIG-UPDATE-CONFIG-UP-SET-1-1

:CONFIG-UP-SET-1-1
cd %UserProfile%\AppData\Roaming\VRT\Error-Logs
echo UPDATE NOT CORRECTLY INSTALLED [%TIME%] >> ErrorLogUpdate[%TIME%].TXT
GOTO CONFIG-UPDATE-TR

:CONFIG-UPDATE-TR
cls
echo.
echo.
echo Configure Update Manually
echo.
echo.
if %counter% EQU 1 echo Update Status=UPDATE NOT CORRECTLY INSTALLED
if %counter% EQU 0 echo Update Status=UPDATE IS CORRECTLY INSTALLED
echo.
if %counter% EQU 1 echo (Please run repair command!)
echo.
echo.
ECHO 1 - Update (Desktop)
ECHO 2 - Update (Custom Dictonary)
echo.
ECHO 3 - Go back 
echo.

set /p opt=Please select an action:
if %opt% equ 1 GOTO CONFIG-UP-DEKSTOP
if %opt% equ 2 GOTO CONFIG-UP-CUSTOMDICT

:ENABLE/DISABLE_OPEN
cd %UserProfile%\AppData\Roaming\VRT
START VRT_Properties.txt
Goto Officalstart

:UPDATER-APP
cls
Title Updater Manager
set/a response_wait=0
echo.
echo ================================
echo Updater Manager 
echo ================================
echo.
echo {Version 1.0.1}
echo.
if %NoInternet%==1 echo [No Internet Access]
echo.
ECHO 1 - Update Search
ECHO 2 - Verify Update
ECHO 3 - Go back
echo.
set /p opt=please put in action here:

if %OPT%==1 GOTO update-ConStart
if %OPT%==2 GOTO REPAIR
if %OPT%==3 GOTO officalstart
if %OPT%==else GOTO NOT_FOUND404

:update-ConStart
if %SilentRunErr%==1 GOTO CONSTART-QUE
:update-ConStart-1
cd %UserProfile%\Appdata\Roaming\VRT\Extra_Modules\UpdateConnectionCheck
START SilentRunner.vbs
set /a response_wait=0
GOTO update-conchk

:CONSTART-QUE
cls
echo.
echo Previous Module damage has been detected!
echo.
set /P c=Launch Anyway[Y/N]?
if /I "%c%" EQU "Y" goto :update-ConStart-1
if /I "%c%" EQU "N" goto :UPDATER-APP

:update-conchk
set /a response_wait+=1
cls
cd %UserProfile%\Appdata\Roaming\VRT\Temp
if exist NoConnection.txt GOTO Update-NoInternet
if exist ConnectionTrue.txt GOTO update
echo.
echo Testing Internet Connection...
ping localhost -n 2 >nul
if %response_wait% GEQ 3 GOTO MODULE-CONCHK-NOTVERIF
GOTO update-conchk

:MODULE-CONCHK-NOTVERIF
cd %Userprofile%\Appdata\Roaming\VRT\EXTRA_MODULE\UpdateConnectionCheck
if exist SilentRunner.vbs GOTO MODULE-CONCHK-ERR-SET
if not exist SilentRunner.vbs GOTO CON_CHK1

:MODULE-CONCHK-ERR-SET
set SilentRunErr=0
GOTO MODULE-CONCHK-ERR

:CON_CHK1
set/a SilentRunErr=1
GOTO MODULE-CONCHK-ERR

:MODULE-CONCHK-ERR
cd %Userprofile%\Appdata\Roaming\VRT\EXTRA_MODULE\UpdateConnectionCheck
cls
echo.
echo _CATASTROPHIC ERROR_
echo.
echo ERRORCODE: NO_MODULE_RESPONSE
echo.
if exist UpdateConnectionCheck.bat echo ERRORTYPE: SOFTWARE ERROR 
if not exist UpdateConnectionCheck.bat echo ERRORTYPE: MODULE NOT INSTALLED
echo.
if %SilentRunErr%==1 echo -------------------EXTRA DAMAGES------------------------
if %SilentRunErr%==1 echo.
if %SilentRunErr%==1 echo Module Launcher Error [LAUNCHER DOES NOT EXIST]
echo.
echo -----------------------------------------------
echo.
if exist UpdateConnectionCheck.bat echo Info: Module is installed, This is most likely a bug i will fix soon! / Or it is a Software configuration error!
if not exist UpdateConnectionCheck.bat echo Info: Module Not installed, Download link expired? download link will be updated or fixed!
echo.
pause> nul
GOTO UPDATER-APP

:Update-NoInternet
cd %UserProfile%\Appdata\Roaming\VRT\Temp
del /q NoConnection.txt
cls
echo.
echo Oops...You aren't connected to the Internet!
echo.
echo Try our "Internet Repair" feature!
echo.
set /a NoInternet=1
Pause> nul
goto UPDATER-APP

:update
cd %UserProfile%\AppData\Roaming\VRT\Temp
del /q ConnectionTrue.txt
SetLocal EnableDelayedExpansion
cls
echo.
echo Checking for updates.....
echo.
powershell -Command "Invoke-WebRequest https://pastebin.com/raw/bsuNrGfx -Outfile Updatelog.cc"
Set count=1
For /f "Usebackq tokens=*" %%A in ("Updatelog.cc") do (
	if !count! EQU 1 (set update=%%A)
	set /a count+=1
)

if %update%==avail (
goto saki
)
if %update%==nope (
del /q Updatelog.cc
echo.
cls
echo.
echo You are using latest version: %Version%
echo.
pause> nul
GOTO UPDATER-APP
)

:saki
Set count=1
For /f "Usebackq tokens=*" %%C in ("%Userprofile%\Appdata\Roaming\VRT\Temp\Updatelog.cc") do (
	if !count! EQU 3 (set UpdateVer=%%C)
	set /a count+=1
)
cls
echo.
echo Update available - Version=%UpdateVer%
echo.
echo.
set /p cai= "Do you want to download (Y/N)? "
if %cai%==y (
goto downloadupdate
) else (
del /q %Userprofile%\Appdata\Roaming\VRT\Temp\Updatelog.cc
goto UPDATER-APP
)

:downloadupdate
cd %UserProfile%\AppData\Roaming\VRT\Temp
echo.
Set count=1
For /f "Usebackq tokens=*" %%B in ("%Userprofile%\Appdata\Roaming\VRT\Temp\Updatelog.cc") do (
	if !count! EQU 2 (set uplink=%%B)
	set /a count+=1
)
cls
echo.
echo Downloading Update.....(%UpdateVer%)
powershell -Command "Invoke-WebRequest %uplink% -Outfile UpdateFile.bat"
cd /d %Userprofile%\Appdata\Roaming\VRT\Temp\
rename "UpdateFile.bat" "VirusRemovalTool.bat"
echo.
GOTO UPDATE-EXP-CHK

:UPDATE-EXP-CHK
cls
echo.
echo Verifying Succesfull Download...
ping -n 4 127.0.0.1>nul
CD %UserProfile%\AppData\Roaming\VRT\Temp
findstr "DOCTYPE" VirusRemovalTool.bat>NUL
IF ERRORLEVEL 1 (GOTO UPDATE-SUCCESFULL) ELSE (GOTO UPDATE-FAILED-EXP)

:UPDATE-FAILED-EXP
CD %UserProfile%\AppData\Local\VirusRemovalTool\Cache
cls
echo.
echo Technical Error~
echo.
echo Reason: DOWNLOAD LINK EXPIRED
echo.
echo ERRORCODE: DOWNLOAD_EXPIRED
echo.
echo Info: The download link is expired i will renew this link ASAP!
echo.
echo. >> ErrorCodeUpdateInvalid.txt
pause> nul
GOTO UPDATER-APP

:UPDATE-SUCCESFULL
cd %UserProfile%\Appdata\Roaming\VRT\Temp
cls
echo.
echo Update Succesfull!
echo.
echo.
del /q Updatelog.cc
pause> nul
GOTO UPDATER-APP

:VIRUSINTEL
color 2
title Virus Intelligence ~ {BETA}
cls
echo.
echo.
echo ==================================
echo         Virus Intelligence
echo ==================================
echo.
echo {Version= 1.0.6}
echo.
echo.
ECHO 1 - Analyse File Menu
ECHO 2 - Counter Virus Payloads
ECHO 3 - How to delete adware/malware?
ECHO 4 - Fast Scan
echo.
ECHO 5 - Go Back
echo.

SET /P OPT=Put in an action here:
if %OPT%==1 GOTO BATCHCHECKER-CHK
if %OPT%==2 GOTO UNDOPROCESS
if %OPT%==3 GOTO HOW2DEL
if %OPT%==4 GOTO SysScanner
if %OPT%==5 GOTO officalstart

:HOW2DEL
cls
echo.
echo How to delete adware/malware?
echo.
echo Adware [1/2]
echo ======================================
echo.
echo Step 1. Disable Unkown Extensions
echo.
echo Step 2. Download Adwcleaner from https://malwarebytes.com/adwcleaner/
echo.
echo Step 3. Reset Browser
echo.
echo Step 4. Download Malwarebytes from https://malwarebytes.com/
echo.
echo Step 5. Possibly Download Malwarebytes Anti-Rootkit from https://malwarebytes.com/antirootkit/
echo.
echo Step 6. Click Windows+R then type in "%appdata%\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome-apps"
echo.
echo Step 7. Add Malwarebytes Internet Guard
echo.
echo Step 8. If nothing helped it is time to reset your pc!
echo.
echo [ADWARE FINSIHED]
echo.
echo ==========================================
echo.
echo Malware [2/2]
echo ======================================
echo.
echo ====IF YOU GET TOO MANY POP UPS YOUR BOOT YOUR PC IN SAFE MODE====
echo.
echo Step 1. Download any Anti-Virus program (or turn on Windows Defender) (payed AV prefered)
echo.
echo Step 2. Run Fast or Full scan (AV)
echo.
echo Step 3. Click Windows+R and type in "mrt.exe" and click yes then run scan
echo.
echo Step 4. (OPTIONAl) Navigate thru explorer to System32 and search for "SigVerif.exe" then scan drivers
echo.
echo Step 5. Download Malwarebytes Anti-Rootkit from https://malwarebytes.com/antirootkit/
echo.
echo Step 6. Possibly Reset your pc
echo.
echo Step 7. Manually Search thru your pc (NOT RECOMMENDED)
echo.
echo Step 8. Reset Browsher
echo.
echo Step 9. Delete everything from the "Startup" folder then restart your pc
echo.
echo [MALWARE FINISHED]
echo.
echo More virus types will be added soon!
echo.
pause> nul
GOTO VIRUSINTEL

:BATCHCHECKER-CHK
CD %UserProfile%\AppData\Roaming\VRT
findstr "AnalyseFilePermission=0" VRT_Properties.txt>NUL
IF ERRORLEVEL 1 (GOTO BATCHCHECKER) ELSE (GOTO BATCH-DENIED)

:BATCH-DENIED
cls
cd %userprofile%\appdata\roaming\VRT\Temp
echo.
echo.
echo Permission Error
echo.
echo Info: VirusRemovalTool does not have permissions to analyse files
echo.
pause> nul
goto VIRUSINTEL

:DIAG-UP
color 2
echo.
echo.
echo // VRT Update Diagnostics //
echo.
echo Diagnostics Outdated
echo.
echo.
set /P c=Do you want to run VRT Diagnostics[Y/N]?
if /I "%c%" EQU "Y" goto :RUN-DIAG-1
if /I "%c%" EQU "N" goto :officalstart

:RUN-DIAG-1
cd %UserProfile%\AppData\Local
if exist VirusRemovalTool GOTO RUN-DIAG-2
if not exist VirusRemovalTool GOTO RUN-DIAG-FAIL

:RUN-DIAG-2
cd %UserProfile%\AppData\Roaming
if exist VRT GOTO RUN-DIAG-3
if not exist VRT GOTO RUN-DIAG-FAIL

:RUN-DIAG-3
cd %UserProfile%\AppData\Roaming\VRT
if exist VRT_Properties.TXT GOTO RUN-DIAG-4
if not exist VRT_Properties.TXT GOTO RUN-DIAG-FAIL

:RUN-DIAG-4
cd %UserProfile%\AppData\Roaming\VRT
if exist Error-Logs GOTO DIAG-PROCESS
if not exist Error-Logs GOTO RUN-DIAG-FAIL

:RUN-DIAG-FAIL
cd %UserProfile%\AppData\Roaming\VRT
echo VRT-DIAG-FAIL >> VRT_Data.TXT
GOTO DIAG-PROCESS

:DIAG-PROCESS
cls
echo.
echo Collecting Results...
echo.
ping -n 4 127.0.0.1>nul
GOTO DIAG-REPORT-CHECK

:DIAG-REPORT-CHECK
cd %UserProfile%\AppData\Roaming\VRT
findstr "VRT-DIAG-FAIL" VRT_Data.TXT>NUL
IF ERRORLEVEL 1 (GOTO DIAG-NOERROR) ELSE (GOTO DIAG-ERROR)

:DIAG-NOERROR
cls
echo.
echo \\ VRT Update Diagnostics Results \\ 
echo.
echo Update Correctly Installed!
echo.
cd %UserProfile%\AppData\Roaming\VRT
echo.
echo Update-Verified[OUTDATED] >> VRT_Data.txt
cls
pause> nul
GOTO DIAG-UP

===========================

:HELP_1
cls
color 2
echo.
echo ============
echo     HELP
echo ============
echo.
echo.
ECHO 1 - Errorcode 303 "Update unsuccefull"
ECHO 2 - Errorcode 456 "Unknown Command"
ECHO 3 - Go back
echo.

set /p opt=Put in action here:
if %OPT%==1 GOTO 303-Help
if %OPT%==2 GOTO 456-Help
if %OPT%==3 GOTO officalstart

:CONSOLE-COMMAND
cls
echo.
echo.
echo VRT Console Command 1.1.1 ///
echo.
echo.
echo Type "help" for menu
echo.
echo.
set /p Command=Please select an action:
if %Command% equ Help GOTO CONSOLE-HELP
if %Command% equ exit exit
if %Command% equ RSAF GOTO REINSTALL
if %Command% equ Verif GOTO REPAIR-LOAD
if %Command% equ VCP GOTO UNDOPROCESS
if %Command% equ Exit console GOTO officalstart
if %Command% equ resetadmin GOTO CONSOLE-ADMIN-RESET
if %Command% equ loadai GOTO AI_INSTALL-CHK

:AI-LOAD

:CONSOLE-HELP
cls
echo.
echo.
echo VRT Console Command 1.1.1 ///
echo.
echo.
echo resetadmin =resets admin bootup settings
echo  exit =exits application
echo  VCP =Runs basic anti virus payloads
echo RSAF =Reinstalls application
echo Verif =Verify downloaded files
echo Exit console =exits the console
ECHO loadai =Loads AI
echo.
set /p Command=Please select an action:
if %Command% equ Help GOTO CONSOLE-HELP
if %Command% equ exit exit
if %Command% equ RSAF GOTO REINSTALL
if %Command% equ verif GOTO REPAIR-CONSOLE-SET
if %Command% equ vcp GOTO UNDOPROCESS
if %Command% equ exit GOTO officalstart
IF %Command% equ resetadmin GOTO CONSOLE-ADMIN-RESET
if %Command% equ loadai GOTO AI_INSTALL-CHK

:REPAIR-CONSOLE-SET
CD %UserProfile%\AppData\Roaming\VRT\Temp
echo ConsoleVerif >> ConsoleVerif.TXT
GOTO REPAIR-LOAD

:CUSTOM_SCAN
cls
echo.
echo Welcome to the VRT custom scan, it was recently created and is very unstable!
echo.
echo.
ECHO 1 - Custom Dictonary
ECHO 2 - Prelisted Scan Loactions
ECHO 3 - Go back
echo.
set /p opt==Put in action here=
if %OPT%==1 GOTO CUSTOM_DICT
if %OPT%==2 GOTO PRELISTED_SCAN
if %OPT%==3 GOTO officalstart

:CUSTOM_DICT 
GOTO NOT_FIN

:PRELISTED_SCAN
GOTO NOT_FIN

:AI-INSTALL-CHK
echo.
echo AI not compatible!
pause> nul
GOTO officalstart
cd %UserProfile%\Appdata\Roaming\VRT
if exist AI GOTO AI_INSTALL-CHK1
if not exist AI GOTO AI_INSTALL

:AI_INSTALL-CHK1
cd %UserProfile%\Appdata\Roaming\VRT\AI
if exist IOS_Memory.txt GOTO AI_INSTALL-CHK2
if not exist IOS_Memory.txt GOTO AI_NOT_COMPLETE

:AI_INSTALL-CHK2
cd %UserProfile%\Appdata\Roaming\VRT\AI
if exist Modules GOTO AI_INSTALL-CHK3
if not exist Modules GOTO AI_NOT_COMPLETE

:AI_INSTALL-CHK3
cd %userprofile%\appdata\roaming\VRT\AI\Modules
set cnt=0
for %%A in (*) do set /a cnt+=1
if %cnt%==1 GOTO AI_NOT_COMPLETE
if %cnt%==2 GOTO AI_NOT_COMPLETE
if %cnt%==3 GOTO AI-LOAD
if %cnt% GEQ 4 GOTO AI_NOT_COMPLETE

:AI_NOT_COMPLETE
cls
echo.
echo AI_INSTALL_NOT_COMPLETE
echo.
echo Reinstall Recommended...(%version%)
echo.
echo NO_REINSTALL_AVAIL
pause> nul
exit

:AI-LOAD
cd %UserProfile%\Appdata\Roaming\VRT\AI\Modules
START IOS_Checker.bat
exit

:AI-INSTALLER-SILENT
cd %UserProfile%\Appdata\Roaming\VRT\Temp
echo Set oShell = CreateObject ("Wscript.Shell") >> Run.vbs
echo Dim strArgs >> Run.vbs
echo strArgs = "cmd /c SilentInstaller.bat" >> Run.vbs
echo oShell.Run strArgs, 0, false >> Run.vbs
:AI-DOWN-INSTALLR

:AI-DOWN-INSTALLR
echo.
echo Installing Necessary Modules...
echo powershell -Command "Invoke-WebRequest  -Outfile IOS-Installer.bat" 

:AI-CONFIG-CHK


:AI-CONFIG
echo Set oShell = CreateObject ("Wscript.Shell") >> Run.vbs
echo Dim strArgs >> Run.vbs
echo strArgs = "cmd /c IOS_Checker.bat" >> Run.vbs
echo oShell.Run strArgs, 0, false >> Run.vbs
start "" "IOS-SilentRunner.vbs

:NOT_FIN
cls
echo.
echo =======================================
echo This page is currently in development!
echo =======================================
echo.
echo.
echo We hope you understand!
echo.
echo.
pause> nul
goto officalstart

:303-Help
cls
echo.
echo Errorcode 303
echo.
echo If this program fails it's probably because you have a different Desktop path!
echo.
echo Goto the Trooubleshooting tab to configure this procedure mannuly!
echo.
echo.
pause> nul
GOTO officalstart

:RATING
GOTO RATING1

:RATING1
START https://docs.google.com/forms/d/e/1FAIpQLSfrvCTJypprGWWXxXYXg5erPWWQQDlkp2_LU4LbDfvAy1ZuUQ/viewform?usp=sf_link
GOTO THANKYOU

:THANKYOU
ping -n 6 127.0.0.1>nul
cls
echo.
echo Thank you for reviewing our application!
echo.
echo We will use this info to make this application better
echo.
pause> nul
GOTO officalstart

:CONSOLE-ADMIN-RESET
cd %UserProfile%\AppData\Local\VirusRemovalTool
  SETLOCAL=ENABLEDELAYEDEXPANSION

    rename VirusRemovalTool_CONFIG.TXT VirusRemovalTool_CONFIG.tmp
    for /f %%a in (VirusRemovalTool_CONFIG.tmp) do (
        set foo=%%a
        if !foo!==AdminBootup=1 set foo=AdminBootup=0
        echo !foo! >> VirusRemovalTool_CONFIG.TXT) 
del VirusRemovalTool_CONFIG.tmp
echo.
GOTO ADMIN-BOOTUP_LOAD-1

:ADMIN-BOOTUP_LOAD-1
cls
echo.
echo Revoking Admin Bootup Privileges...
echo.
ping -n 4 127.0.0.1>nul
GOTO CONSOLE-COMMAND

:LOGOPT
cls
color 2
echo.
echo ====================
echo Log Options Menu 
echo ====================
echo.
ECHO 1 - Check Data file size
ECHO 2 - Remake VRT_Data.txt
ECHO 3 - Check other file sizes
ECHO 4 - Go back
echo.
set /p opt=Put in action here:
if %OPT% equ 1 GOTO SETFILE
if %OPT% equ 2 GOTO DAT
if %OPT% equ 3 GOTO SETCUSTOMFILE
if %OPT% equ 4 GOTO DELALL
if %OPT% equ 5 GOTO officalstart

:SETCUSTOMFILE
cls
echo.
echo what is the file name?
echo.
echo.
SET /P NAME=Put in  file name here:
GOTO CHKFLSTATUS

:CHKFLSTATUS
if exist %NAME% GOTO FLCOMP
if not exist %NAME% GOTO FLDEN

:FLCOMP
cls
echo.
echo File detected in dictonary!
echo.
echo.
ping -n 2 127.0.0.1>nul
GOTO SETFILESIZE

:FLDEN
cls
echo.
echo Action denied!
echo.
echo Reason: File doesn't exist.
echo.
echo.
echo Do not forget to put the file extension in the type bar!
echo.
echo.
pause> nul
GOTO officalstart

:SETFILESIZE
cls
echo.
echo what is the max file size?
echo.
echo.
SET /P maxsize=Put in max file size here:
GOTO CHKFLC

:CHKFLC
echo.
setlocal
cd %userprofile%\Appdata\roaming\VRT
set file="%NAME%"
set maxbytesize=%maxsize%

FOR /F "usebackq" %%A IN ('%file%') DO set size=%%~zA

if %size% LSS %maxbytesize% (
    echo.File is ^under %maxbytesize% bytes
) ELSE (
    echo.File is ^above %maxbytesize% bytes
)
pause> nul
GOTO officalstart

:SETFILE
cls
echo.
echo what is the max file size?
echo.
echo.
SET /P maxsize=Put in max file size here:
GOTO CHKFL

:CHKFL
echo.
setlocal
cd %userprofile%\Appdata\roaming\VRT
set file="VRT_Data.txt"
set maxbytesize=%maxsize%

FOR /F "usebackq" %%A IN ('%file%') DO set size=%%~zA

if %size% LSS %maxbytesize% (
    echo.File is ^under %maxbytesize% bytes
) ELSE (
    echo.File is ^above %maxbytesize% bytes
)
pause> nul
GOTO officalstart

:LVL3
cls
color c
echo.
echo.
echo Level 3 Emergency Lockout Protocol Activated
echo.
echo.
echo Codename "%random%"
echo.
echo Lockout Inintated...
echo LEVEL 3 SECRURITY BREACH ACTION NEEDED! [%date%] >> VRT_Data.txt
echo.
pause> nul
Goto ACCDENIED

:DAT
cls
color 2
echo.
echo Click "enter" to Remake file
echo.
echo.
pause> nul
GOTO DATCHECK

:DATERROR
cls
color 2
echo.
echo

:TROUBLE
cls
echo.
echo =========================
echo Troubleshooting Menu
echo =========================
echo.
echo.
ECHO 1 - PC Troubleshooting
ECHO 2 - Application troubleshooting
echo.
ECHO 3 - Go back
echo.

set /p opt=Put in action here:
if %OPT% equ 1 GOTO Trouble-Tray
if %OPT% equ 2 GOTO App-Tray
if %OPT% GEQ 3 GOTO officalstart

:App-Tray
cls
echo.
echo Application Troubleshooting
echo.
echo.
echo NO DATA
echo.
ECHO 1 - Go back

set /p opt=Put in action here:
if %OPT% equ 1 GOTO officalstart

:Trouble-Tray
cls
color 2
echo.
echo Troubleshooting options.
echo.
echo.
ECHO 1 - Network Reset
ECHO 2 - Firewall on (REGISTERY REQUIRED)
ECHO 3 - Enable Task Manager (REGISTERY REQUIRED)
ECHO 4 - Enable AntiSpyware (REGISTERY REQUIRED)
ECHO 5 - Go Back
echo.

SET /P OPT=Please select troubleshooting options:
if %OPT%==1 GOTO NETRESET
if %OPT%==2 GOTO FIRON
if %OPT%==3 GOTO ESM
if %OPT%==4 GOTO EAS
if %OPT%==5 GOTO Officalstart

:DATCHECK
GOTO DAT2

:NETRESET
cls
color 2
ipconfig /renew
echo.
cls
ipconfig
echo.
echo.
pause> nul
GOTO Trouble

:FIRON
cls
color 2
echo.
echo.
NetSh Advfirewall set allprofiles state on
echo.
echo.
pause> nul
GOTO Trouble

:ESM
cls
color 2
echo.
ECHO REGEDIT4 > %WINDIR%\DXM.REG
echo. >> %WINDIR%\DXM.reg

echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System] >> %WINDIR%\DXM.reg
echo "DisableTaskMgr"=dword:0 >> %WINDIR%\DXM.reg
echo [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System] >> %WINDIR%\DXM.reg
echo "DisableTaskMgr"=dword:0 >> %WINDIR%\DXM.reg

start /w regedit /s %WINDIR%\DXM.reg
echo.
echo.
pause> nul
GOTO Trouble

:EAS
cls
color 2
echo.
echo.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t "REG_DWORD" /d "0" /f
echo.
echo.
pause> nul
GOTO Trouble

:VUP
cls
color 2
echo.
echo.
ECHO REGEDIT4 > %WINDIR%\DXM.REG
echo. >> %WINDIR%\DXM.reg

echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System] >> %WINDIR%\DXM.reg
echo "DisableTaskMgr"=dword:0 >> %WINDIR%\DXM.reg
echo [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System] >> %WINDIR%\DXM.reg
echo "DisableTaskMgr"=dword:0 >> %WINDIR%\DXM.reg

start /w regedit /s %WINDIR%\DXM.reg
echo.
NetSh Advfirewall set allprofiles state on
echo.
cls
echo.
echo.
echo The program has fininshed.
echo.
echo.
pause> nul
GOTO START

:SORRY 
color 2
cls
title GENERAL ERROR
echo.
echo VirusRemovalTool could not process your request.
echo.
echo Command: %OPT%
echo.
echo Errorcode: 456
echo.
echo Please type again.
echo.
pause> nul
GOTO officalstart

:UNDOPROCESS
cls
echo.
echo Virus Counter Payload
echo.
echo This is used to enable things like enable TskMgr or renew internet access.
echo.
echo This does NOT delete the virus/trojan!
echo.
echo.
set /P c=Do you want to run the Virus Counter Payload[Y/N]?
if /I "%c%" EQU "Y" goto :dlog
if /I "%c%" EQU "N" goto :runtest
if /I "%c%" EQU "y" goto :dlog
if /I "%c%" EQU "n" goto :runtest

:runtest
cls
color 2
echo.
echo The Counter Payload has been cancelled by user.
echo.
pause> nul
GOTO officalstart

:dlog
cls
color 2
echo.
echo Beginning undo process...
pause> nul
ipconfig /renew

ECHO REGEDIT4 > %WINDIR%\DXM.REG
echo. >> %WINDIR%\DXM.reg

echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System] >> %WINDIR%\DXM.reg
echo "DisableTaskMgr"=dword:0 >> %WINDIR%\DXM.reg
echo [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System] >> %WINDIR%\DXM.reg
echo "DisableTaskMgr"=dword:0 >> %WINDIR%\DXM.reg
start /w regedit /s %WINDIR%\DXM.reg
echo.
NetSh Advfirewall set allprofiles state on
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t "REG_DWORD" /d "0" /f
echo.
ping -n 4 127.0.0.1>nul
GOTO LOG

:LOG
CD %UserProfile%\AppData\Roaming\VRT
echo Counter Virus Payload Completed >> VRT_Data.txt
cls
echo.
echo The Virus Counter Payload has been succesfully executed!
echo.
echo.
set /P c=Do you want to shutdown this pc[Y/N]?
if /I "%c%" EQU "Y" goto :off
if /I "%c%" EQU "N" goto :on
if /I "%c%" EQU "y" goto :off
if /I "%c%" EQU "n" goto :on

:off
cls
color 2
echo.
echo The pc will shutdown in 10 seconds!
echo.
%windir%\System32\shutdown.exe -s -f -t 10 -c "VirusRemovalTool will shutdown in 10 seconds"
exit

:BATCHCHECKER
cls
echo.
echo File Analysation Menu
echo.
ECHO 1 - Analyse File
ECHO 2 - Database Analyser
ECHO 3 - Real Time Protection
ECHO 4 - Install Extra Search Module
echo.
ECHO 4 - Go back
echo.

set /p OPT=Please put an action here:
if %OPT% equ 1 GOTO BATCH-DESKTOP
if %OPT% equ 2 GOTO DATABASE-ANALYSE
if %OPT% equ 3 GOTO REAL_TIME
if %OPT% equ 4 GOTO INSTALL_ANTI_VM-MD5
if %OPT% equ 5 GOTO VIRUSINTEL

:INSTALL_ANTI_VM-MD5
cd %UserProfile%\Appdata\Roaming\VRT\Temp
cls
echo.
echo Next Version Release...
pause> nul
GOTO officalstart

echo Installing MD5 Search Module...
SetLocal EnableDelayedExpansion
powershell -Command "Invoke-WebRequest https://pastebin.com/raw/GGw0yAgt -Outfile Md5Link.cc"
Set count=1
For /f "Usebackq tokens=*" %%W in ("%Userprofile%\Appdata\Roaming\VRT\Temp\Md5Link.cc") do (
	if !count! EQU 1 (set linkp=%%W)
	set /a count+=1
cls
echo.
ECHO %linkp%
cd %Userprofile%\Appdata\Roaming\VRT\Extra_Modules
md MD5
cd %Userprofile%\Appdata\Roaming\VRT\Extra_Modules\MD5
powershell -Command "Invoke-WebRequest %linkp% -Outfile MD5.bat"
cls
echo.
echo Verifying Succefull Download...
echo.
cd %UserProfile%\Appdata\VRT\Extra_Modules\MD5
findstr "checksum" MD5.bat>NUL
IF ERRORLEVEL 1 (GOTO MD5-FAIL) ELSE (GOTO MD5-SUCCESS)

:MD5-FAIL
cls
echo.
echo Download Link Expired - Please report on website
echo.
echo https://0095296.wixsite.com/kartanasoftware
echo.
echo We are sorry for the inconvienience!
echo.
pause> nul
GOTO UPDATER-APP

:MD5-SUCCESS
cls
echo.
echo Succesfull Download!
echo.
echo Applying New File...
echo.
pause> nul
GOTO :BATCHCHECKER

:REAL_TIME
cls
echo.
echo Installing Modules...
echo.
SetLocal EnableDelayedExpansion
powershell -Command "Invoke-WebRequest [RTP File] -Outfile GetVer.cc"
Set count=1
For /f "Usebackq tokens=*" %%A in ("GetVer.cc") do (
	if !count! EQU 1 (set GetVer=%%A)
	set /a count+=1
)


:BATCH-DESKTOP
cd %Userprofile%\Appdata\Local\VirusRemovalTool
cls
echo.
echo Please enter the file name with extension (example: .exe .txt)
echo.
echo ------Regular Searched Files------
type AnalyseRegularFiles.txt
cd %UserProfile%\Desktop
echo.
set /p Batname=Enter file name:

IF EXIST %Batname% goto Reg-Set-Chk
IF NOT EXIST %Batname% goto clean

:Reg-Set-Chk
cd %UserProfile%\Appdata\Local\VirusRemovalTool
findstr "%Batname%" AnalyseRegularFiles.TXT>NUL
IF ERRORLEVEL 1 (GOTO Reg-Set-Chk-2) ELSE (GOTO Reg-EXIST)

:Reg-Set-Chk-2
cd %UserProfile%\Appdata\Local\VirusRemovalTool
set file=AnalyseRegularFiles.txt
set /a cnt=0
for /f %%a in ('type "%file%"^|find "" /v /c') do set /a cnt=%%a
if %cnt% GEQ 4 GOTO Reg-Set-Del
GOTO Reg-Set

:Reg-Set-Del
cd %UserProfile%\Appdata\Local\VirusRemovalTool
DEL AnalyseRegularFiles.txt
echo AnalyseRegularFiles.txt
GOTO Reg-Set

:Reg-EXIST
GOTO infected-chk

:Reg-Set
cd %Userprofile%\appdata\Roaming\local\VirusRemovalTool
echo %Batname% >> AnalyseRegularFiles.txt
goto infected-chk

:infected-chk
cd %UserProfile%\Desktop
findstr "ProtectCode14" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO infected) ELSE (GOTO INFECTED-ERR)


:INFECTED-ERR
cd %UserProfile%\Appdata\Roaming\VRT\Error-Logs
cls
echo.
echo You cannot scan protected files!
echo.
echo FileContainsProtectionCode >> Error_Report[SCAN_ERROR].txt
pause> nul
GOTO BATCH-DESKTOP

:infected
cls
set/a counter=0
set/a rogue=0
set/a ransom=0
set/a adware=0
set /a spyware=0
set /a light=0
echo.
echo.
set /P c=This file is recognized do you want to check this file for virusses[Y/N]?
if /I "%c%" EQU "Y" goto :CHK-FOLDER
if /I "%c%" EQU "N" goto :BATCHCHECKER

:CHK-FOLDER
cd %UserProfile%\Desktop
setlocal EnableDelayedExpansion
set "cmd=findstr /R /N "^^" %Batname% | find /C ":""

for /f %%h in ('!cmd!') do set fileline=%%h
if %fileline% GEQ 1 GOTO CHK-EXTENSION
if %fileline% LSS 0 GOTO UNSUPPORTED-CHK

:UNSUPPORTED-CHK
cls
echo.
echo Unsupported File Detected!
echo.
echo Folders cannot be scanned!
echo please only scan the files.
echo.
echo (Unsupported file/folder=%Batname%)
pause> nul
GOTO BATCH-DESKTOP

:CHK-EXTENSION
SETLOCAL
cls
echo.
for %%a in (%BATNAME%) do (
    set fileextension=%%~xa
)    
if %fileextension% == .cry GOTO CHK-EXTENSION1
if %fileextension% == .crypto GOTO CHK-EXTENSION1
if %fileextension% == .darkness GOTO CHK-EXTENSION1
if %fileextension% == .locked GOTO CHK-EXTENSION1
if %fileextension% == .crypt GOTO CHK-EXTENSION1
if %fileextension% == .decipher GOTO CHK-EXTENSION1
if %fileextension% == .install_tor GOTO CHK-EXTENSION1
if %fileextension% == .how_to_recover GOTO CHK-EXTENSION1
if %fileextension% == .vault GOTO CHK-EXTENSION1
if %fileextension% == .help_restore GOTO CHK-EXTENSION1
if %fileextension% == .restore_fi GOTO CHK-EXTENSION1
if %fileextension% == .@india.com GOTO CHK-EXTENSION1
if %fileextension% == .frtrss GOTO CHK-EXTENSION1
if %fileextension% == .keemail.me GOTO CHK-EXTENSION1
if %fileextension% == .nochance GOTO CHK-EXTENSION1
if %fileextension% == .exx GOTO CHK-EXTENSION1
if %fileextension% == .kraken GOTO CHK-EXTENSION1
if %fileextension% == .ukr.net GOTO CHK-EXTENSION1
GOTO CHK

:CHK-EXTENSION1
set/a ransom+=1
set/a counter+=1
goto CHK

:DATABASE_SEARCH
cd %UserProfile%\Desktop
findstr "%BATNAME%" Database.txt>NUL
IF ERRORLEVEL 1 (GOTO CHK) ELSE (GOTO DATABASE-TRUE)

:DATABASE-TRUE
cd %UserProfile%\Appdata\Roaming\VRT\Temp
echo [%BATNAME%]-DatabaseFound >> AnalyseReport[%Batname%].txt
set/a Adware+=1
set/a counter+=1
GOTO CHK

:CHK-HASHING-INTERNET-VERIF
GOTO CHK-NAME-VIRUS
cd %UserProfile%\Desktop
set "file=%BATNAME%"
call md5.bat "%file%" md5

if "%md5%" equ "79054025255fb1a26e4bc422aef54eb4" (
      echo MD5 identical!
) else (
      echo MD5 does not match.
)
pause> nul


:CHK
cd %UserProfile%\Desktop
findstr "DisableTaskMgr" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-1) ELSE (GOTO CHK-ADD)

:CHK-ADD
cd %Userprofile%\AppData\Roaming\VRT\Temp
set /a counter+=1
set /a rogue+=1
echo DisableTaskMgr >> AnalyseReport[%Batname%].txt
GOTO CHK-1

:CHK-1
cd %UserProfile%\Desktop
findstr "tags.bluekai.com" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-2) ELSE (GOTO CHK-1-ADD)

:CHK-1-ADD
cd %Userprofile%\AppData\Roaming\VRT\Temp
set /a counter+=1
set /a adware+=1
echo BlueKaiAdware >> AnalyseReport[%Batname%].txt
GOTO CHK-2

:CHK-2
cd %UserProfile%\Desktop
findstr "DisableAntiSpyware" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-3) ELSE (GOTO CHK-2-ADD)

:CHK-2-ADD
cd %Userprofile%\AppData\Roaming\VRT\Temp
set /a counter+=1
set /a spyware+=1
echo DisableAntiSpyware >> AnalyseReport[%Batname%].txt
GOTO CHK-3

:CHK-3
cd %UserProfile%\Desktop
findstr "StartRansom" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-4) ELSE (GOTO CHK-3-ADD)

:CHK-3-ADD
cd %Userprofile%\AppData\Roaming\VRT\Temp
set /a counter+=1
set /a ransom+=1
echo RansomeDecrypt >> AnalyseReport[%Batname%].txt
GOTO CHK-4

:CHK-4
cd %UserProfile%\Desktop
findstr "killer" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-5) ELSE (GOTO CHK-4-ADD)

:CHK-4-ADD
cd %Userprofile%\AppData\Roaming\VRT\Temp
set /a counter+=1
set /a rogue+=1
echo Trojan.Java.AppletKiller >> AnalyseReport[%Batname%].txt
GOTO CHK-5

:CHK-5
cd %UserProfile%\Desktop
findstr "najort5g.exe" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-6) ELSE (GOTO CHK-5-ADD)

:CHK-5-ADD
cd %UserProfile%\AppData\Roaming\VRT\Temp
set /a counter+=1
set /a rogue+=1
echo Najort5g.exe >> AnalyseReport[%Batname%].txt
GOTO CHK-6

:CHK-6
cd %UserProfile%\Desktop
findstr "execute_adware" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-7) ELSE (GOTO CHK-6-ADD)

:CHK-6-ADD
cd %UserProfile%\AppData\Roaming\VRT\Temp
set /a counter+=1
set /a adware+=1
echo AdwareDetection >> AnalyseReport[%Batname%].txt
GOTO CHK-7

:CHK-7
cd %UserProfile%\Desktop
findstr "Crypto.Cipher" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-8) ELSE (GOTO CHK-7-ADD)

:CHK-7-ADD
cd %UserProfile%\AppData\Roaming\VRT\Temp
set /a counter+=1
set /a ransom+=1
echo RansomewareCrypt >> AnalyseReport[%Batname%].txt
GOTO CHK-8

:CHK-8
cd %UserProfile%\Desktop
findstr "Btloader.com" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-9) ELSE (GOTO CHK-8-ADD)

:CHK-8-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set /a counter+=1
set /a adware+=1
echo BT-Loader Adware >> AnalyseReport[%Batname%].txt
GOTO CHK-9

:CHK-9
cd %Userprofile%\Desktop
findstr "bk-coretag.js" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-10) ELSE (GOTO CHK-9-ADD)

:CHK-9-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set /a counter+=1
set /a adware+=1
echo OracleAdware >> AnalyseReport[%Batname%].txt
GOTO CHK-10

:CHK-10
cd %Userprofile%\Desktop
findstr "ecurepubads.g.doubleclick.net" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-11) ELSE (GOTO CHK-10-ADD)

:CHK-10-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set /a counter+=1
set /a adware+=1 
echo DoubleClick-Adware[1/2] >> AnalyseReport[%Batname%].txt
GOTO CHK-11

:CHK-11
cd %Userprofile%\Desktop
findstr "gpt.js" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-12) ELSE (GOTO CHK-11-ADD)

:CHK-11-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set /a light+=1
echo AdwareInstallBeacon >> AnalyseReport[%Batname%].txt
GOTO CHK-12

:CHK-12
cd %Userprofile%\Desktop
findstr "cdn.optimizely.com" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-13) ELSE (GOTO CHK-12-ADD)

:CHK-12-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set /a counter+=1
set /a adware+=1
echo OptimiselyAdware >> AnalyseReport[%Batname%].txt
GOTO CHK-13

:CHK-13
cd %Userprofile%\Desktop
findstr "bat.js" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-14) ELSE (GOTO CHK-13-ADD)

:CHK-13-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set /a counter+=1
set /a adware+=1
echo AdwareInstalWebBeacons(Bat) >> AnalyseReport[%Batname%].txt
GOTO CHK-14

:CHK-14
cd %Userprofile%\Desktop
findstr "coretag.js" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-15) ELSE (GOTO CHK-14-ADD)

:CHK-14-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set/a counter+=1
set/a adware+=1
echo OracleBeacon >> AnalyseReport[%Batname%].txt
GOTO CHK-15

:CHK-15
cd %Userprofile%\Desktop
findstr "scout.js" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-16) ELSE (GOTO CHK-15-ADD)

:CHK-15-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set/a counter+=1
set/a adware+=1
echo FastlyJavaScript >> AnalyseReport[%Batname%].txt
GOTO CHK-16

:CHK-16
cd %Userprofile%\Desktop
findstr "VirTool.BAT.PBVE" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-17) ELSE (GOTO CHK-16-ADD)

:CHK-16-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set/a counter+=1
set/a rogue+=1
echo RogueVirTool >> AnalyseReport[%Batname%].txt
GOTO CHK-17

:CHK-17
cd %Userprofile%\Desktop
findstr "deal.kinguin.net" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO CHK-18) ELSE (GOTO CHK-17-ADD)

:CHK-17-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set/a counter+=1
set/a adware+=1
echo Adware.Hotjar.js >> AnalyseReport[%Batname%].txt
GOTO CHK-18

:CHK-18
cd %Userprofile%\Desktop
findstr "houston.js" %Batname%>NUL
IF ERRORLEVEL 1 (GOTO END-CHK) ELSE (GOTO CHK-18-ADD)

:CHK-18-ADD
cd %Userprofile%\Appdata\Roaming\VRT\Temp
set/a counter+=1
set/a adware+=1
echo Houston.js >> AnalyseReport[%Batname%].txt
GOTO END-CHK

:END-CHK
cd %Userprofile%\AppData\Roaming\VRT\Temp
cls
echo.
echo ------------RESULTS--------------
echo.
if %counter% GEQ 1 echo [%Batname%] tested postitive for %Counter%/19 Detections
if %counter% LSS 1 echo [%Batname%] tested negative for File Analysation Detections
if %light% GEQ 1 echo.
if %light% GEQ 1 echo ________________________________________________________________
if %light% GEQ 1 echo [%Batname%] tested positive for a non malicious ad/web beacon
if %light% GEQ 1 echo ________________________________________________________________
echo.
echo.
if %counter% GEQ 1 echo _______________________
if %counter% GEQ 1 echo Class Threat Level
if %counter% GEQ 1 echo.
if %counter% EQU 1 echo Threat: Low Threat Level
if %counter% EQU 2 echo Threat: Low/Medium Threat Level
if %counter% EQU 3 echo Threat: Medium Threat Level
if %counter% EQU 4 echo Threat: Medium/High Threat Level
if %counter% GEQ 5 echo Threat: High Threat Level
if %counter% GEQ 1 echo _______________________
if %counter% GEQ 1 echo Malware Class
if %adware% GEQ 1 echo Class: Adware
if %ransom% GEQ 1 echo Class: Ransomware
if %rogue% GEQ 1 echo Class: Rogue
if %spyware% GEQ echo Class: Spyware
if %counter% GEQ 1 echo _______________________ 
if %light% GEQ 1 echo _________________________
if %light% GEQ 1 echo  EXTRAS:
if %light% GEQ 1 echo.
if %light% GEQ 1 echo  GooglePublisherTrack (gpt.js) [NON MALICIOUS] - [TRACING COOKIE]
if %light% GEQ 1 echo ________________________
echo.
echo.
if %counter% GEQ 1 echo Auto Quarantine Disabled Manual move required
pause> nul
GOTO officalstart

:AUTO-QUARANTINE
move "%UserProfile%\Desktop\%batname%" "%UserProfile%\AppData\Roaming\VRT\Quarantine"
GOTO END-CHK

:clean
cls
echo.
echo.
echo %Batname% was not found!
echo.
echo.
pause> nul
goto officalstart

:Optimizer
cd %userprofile%\Appdata\Local\VirusRemovalTool
cls
Title Optimizer Menu  1.0.4
echo.
echo ==================================
echo Optimizer Menu [BETA]
echo ==================================
echo.
echo {Version 1.0.4}
echo.
echo.
ECHO 1 - Run VRT Optimizer *BETA
ECHO 2 - Corrupted File Checker
ECHO 3 - Malicious Removal Tool (MRT)
ECHO 4 - Delete Temp Files
ECHO 5 - Internet Connection Repair (ELEVATED PERMISSIONS REQUIRED)
ECHO 6 - Ram Booster V1.0.0
ECHO 7 - Go back
echo ===================================
echo CurrentUsername= && type Username.txt
echo ===================================
echo.
SET /P OPT=Put in action here:
if %OPT%==1 GOTO OptimizerBET
if %OPT%==2 GOTO SFC
if %OPT%==3 GOTO START-MRT
if %OPT%==4 GOTO DEL-TEMP_VRT
if %OPT%==5 GOTO NC-PRETEST
if %OPT%==6 GOTO RAMBOOSTERV1
if %OPT%==7 GOTO officalstart

:START-MRT
start MRT.exe
GOTO Optimizer

:RAMBOOSTERV1
cls
echo.
echo.
FOR /F "tokens=4" %%a in ('systeminfo ^| findstr Physical') do if defined totalMem (set availableMem=%%a) else (set totalMem=%%a)
set totalMem=%totalMem:,=%
set availableMem=%availableMem:,=%
set /a usedMem=totalMem-availableMem
echo.
if %totalmem% GEQ 4221 GOTO RAMBOOST-OPT-2
if %totalmem% LSS 4221 GOTO RAMBOOST-OPT-1

:RAMBOOST-OPT-1
cd %UserProfile%\AppData\Roaming\VRT\Temp
echo.
echo FreeMem=Space(209600000) >> RamBoost2GB.vbs
echo.
echo 2096MB Memory Freed
echo.
pause> nul
goto Optimizer

:RAMBOOST-OPT-2
cd %UserProfile%\AppData\Roaming\VRT\Temp
cls
echo.
echo FreeMem=Space(809600000) >> RamBoost8GB.vbs
echo.
echo 8096MB Memory Freed
pause> nul
goto Optimizer

:NC-PRETEST
cls
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    GOTO NC-SET
) ELSE (
   echo ######## ########  ########   #######  ########  
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ######   ########  ########  ##     ## ########  
   echo ##       ##   ##   ##   ##   ##     ## ##   ##   
   echo ##       ##    ##  ##    ##  ##     ## ##    ##  
   echo ######## ##     ## ##     ##  #######  ##     ## 
   echo.
   echo.
   echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
   echo This script must be run as administrator to work properly!  
   echo If you're seeing this after clicking on a start menu icon, then right click on the shortcut and select "Run As Administrator".
   echo ##########################################################
   echo.
   PAUSE
   EXIT /B 1
)
@echo ON

:NC-SET
set/a loadnum=0
set/a loadper=0
set/a counter=0
GOTO NC-START

:NC-START
set load=%load%           
cls
echo.
echo Repairing Your Internet Connection...(%loadper%%%)
echo -------------------------------------------------------------------------------------------------------------
echo %load%
echo -------------------------------------------------------------------------------------------------------------
echo.
echo ______________________________________
echo        Repairing Status
echo.
If %counter% equ 1 echo Flushing DNS Cache
If %counter% equ 2 echo Resetting Netsh Winsock
If %counter% equ 3 echo Resetting Netsh IP
If %counter% equ 4 echo Releasing Connection...(1/2)
if %counter% equ 5 echo Renewing Connection...(2/2)
if %counter% equ 6 echo Resetting TCP/IP Connection
if %counter% equ 7 echo Verifying Connection...
if %counter% equ 8 echo Verifying Connection...
if %counter% equ 9 echo Calculating Results...
echo.
echo ______________________________________
echo.
echo.
ping localhost -n 2 >nul

set/a loadnum=%loadnum% +11
set/a loadper=%loadper% +11
if %loadnum% GEQ 100 goto NC-START_REAL
if %loadnum% GEQ 30 goto setload2
if %loadnum% GEQ 50 goto setload2
if %loadnum% GEQ 70 goto setload2
if %loadnum% GEQ 90 goto setload2
if %loadnum% GEQ 10 goto setload2
if %loadnum% GEQ 37 goto setload2
if %loadnum% GEQ 38 goto setload2

:setload2
set /a counter+=1
GOTO NC-START

:NC-START_REAL
echo.
echo Verifying...
ipconfig /flushdns
cls
echo.
ipconfig /release
cls
echo.
ipconfig /renew
cls
echo.
netsh winsock reset
cls
echo.
netsh int ip reset
cls
echo Running Repair Script...
ping localhost -n 4 >nul
GOTO NW-RESTART

:NW-RESTART
cd %UserProfile%\Appdata\Roaming\VRT
echo IP-Repair >> VRT_Data.txt.log
cd %UserProfile%\AppData\Roaming\VRT\Temp
echo IP-Repair >> IP-REPAIR-TEMP.log
echo Status=1 >> IP-REPAIR-TEMP.log
echo Rebooting in 10 Sec...(EXPECTED) >> IP-REPAIR-TEMP
cls
echo.
echo Restart is Required!
pause> nul
%windir%\System32\shutdown.exe -r -t 10 -c "VirusRemovalTool will restart your pc in 10 seconds"
exit

:SFC
cls
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    GOTO SFC-CONF
) ELSE (
   echo ######## ########  ########   #######  ########  
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ######   ########  ########  ##     ## ########  
   echo ##       ##   ##   ##   ##   ##     ## ##   ##   
   echo ##       ##    ##  ##    ##  ##     ## ##    ##  
   echo ######## ##     ## ##     ##  #######  ##     ## 
   echo.
   echo.
   echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
   echo This script must be run as administrator to work properly!  
   echo If you're seeing this after clicking on a start menu icon, then right click on the shortcut and select "Run As Administrator".
   echo ##########################################################
   echo.
   PAUSE
   EXIT /B 1
)
@echo ON

:SFC-CONF
cls
sfc /SCANNOW
echo.
pause> nul
GOTO Optimizer

:DEL-TEMP_VRT
cls
cd %userprofile%\appdata\roaming\VRT\Temp
set cnt=0
for %%A in (*) do set /a cnt+=1
echo _______________________________
echo there are %cnt% temp files
echo ______________________________
echo.
echo ====================
echo  File Name(s)=
echo ====================
dir /b 
echo ====================
echo.
set /P c=Do you want to Delete temp files[Y/N]?
if /I "%c%" EQU "Y" goto :DEL-TEMP-1
if /I "%c%" EQU "N" goto :Optimizer

:DEL-TEMP-1

:TEMP-DELETED-1
if exist %userprofile%\appdata\Roaming\VRT\Temp*.* GOTO TEMP-DELETED
if not exist %userprofile%\appdata\Roaming\VRT\Temp*.* GOTO TEMP-DELETED-ERR

:TEMP-DELETED-ERR
cls
echo.
echo No temp files detected!
echo.
pause> nul
GOTO TEMP-DELETED

:TEMP-DELETED
cd %userprofile%\appdata\Roaming\VRT\Temp
del /Q %userprofile%\appdata\Roaming\VRT\Temp*.*
GOTO Optimizer

:OptimizerBET
cls
color 2
echo.
echo Optimizer 2021 [BETA]
echo.
echo.
echo.
set /P c=Do you want to run this optimizer[Y/N]?
if /I "%c%" EQU "Y" goto :START-CHK
if /I "%c%" EQU "N" goto :NotRun

:START-CHK
cls
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    GOTO START-OPT
) ELSE (
   echo ######## ########  ########   #######  ########  
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ######   ########  ########  ##     ## ########  
   echo ##       ##   ##   ##   ##   ##     ## ##   ##   
   echo ##       ##    ##  ##    ##  ##     ## ##    ##  
   echo ######## ##     ## ##     ##  #######  ##     ## 
   echo.
   echo.
   echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
   echo This script must be run as administrator to work properly!  
   echo If you're seeing this after clicking on a start menu icon, then right click on the shortcut and select "Run As Administrator".
   echo ##########################################################
   echo.
   PAUSE> NUL
   EXIT /B 1
)
@echo ON

:START-OPT
goto optim-1

:OPTIM-1
CD %UserProfile%\Appdata\Local
echo.
echo Optimizing your pc...
echo.
cd %UserProfile%\Appdata\Local\Temp
echo.
   setlocal enableextensions disabledelayedexpansion

    set "target=%cd%"
    if not defined target set "target=%cd%"

    set "size=0"
    for /f "tokens=3,5" %%a in ('
        dir /a /s /w /-c "%target%"
        ^| findstr /b /l /c:"  "
    ') do if "%%b"=="" set "size=%%a"
cls

set /a total=%size% / 1024
echo.
set /a MB=%total% / 1024
echo.
GOTO OPTIM-3-3

:OPTIM-3-3
cls
echo.
echo Deleting Windows Temporary files...
ping localhost -n 3 >nul
del /f /q "%userprofile%\AppData\Local\Temp\*.*"
GOTO OPTIM-3


:OPTIM-2
cls
echo.
echo Deleting Cookies...
ping localhost -n 3 >nul
del /f /q "%userprofile%\Cookies\*.*"
echo.
GOTO OPTIM-3-EXTRAS

:OPTIM-3-EXTRAS
cls
echo.
echo Deleting Temporary Internet Files...
ping localhost -n 3 >nul
del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
GOTO OPTIM-3

:OPTIM-3
echo.
GOTO OPTIM-4

:OPTIM-4
cd %UserProfile%\Appdata\Roaming\VRT\Temp
cls
echo.
echo FreeMem = Space(64000000) >> RamBooster1.vbs
echo FreeMem = Space(32000000) >> RamBooster2.vbs
echo.
START RamBooster1.vbs
START RamBooster2.vbs
GOTO OPTIM-5
:OPTIM-5
cls
echo.
rem sfc /SCANNOW
echo.
GOTO OPT-COMP

====================================================================

:OPT-COMP
cd %UserProfile%\Appdata\Roaming\VRT
cls
title Optimizer succesfull!
echo.
echo [YOUR PC HAS BEEN OPTIMISED]
echo.
echo %MB% MB has been deleted!
echo.
echo PC-OPIMIZED >> VRT_Data.txt
echo.
echo.
pause> nul
GOTO officalstart

:SysScanner
set/a GlobalFoundBefore=0
set/a TencentFoundBefore=0
set/a KasperskyAV=0
title Sys Virus Scanner
cls
echo Info: This tool does NOT delete any registery keys!
echo It is possible that a virus that is detected isn't fully deleted!
echo But this tool does delete the Core files and folders of the app
echo.
echo.
ECHO 1 - Start Scan
ECHO 2 - Settings
ECHO 3 - Go Back
echo.
set/p opt=Put in action here:
if %OPT%==1 GOTO SysStart-chk-AV
if %OPT%==2 GOTO FastScan-Settings
if %OPT%==3 GOTO VIRUSINTEL

:FastScan-Settings
cd %UserProfile%\Appdata\Roaming\VRT
start VRT_Properties.txt
echo.
goto SysScanner
:SysStart-chk-AV
reg query HKEY_CURRENT_USER\SOFTWARE\KasperskyLab
cls
if %ERRORLEVEL%==0 goto KasperskyAV
GOTO SysStart-chk

:KasperskyAV
cd %UserProfile%\Appdata\Roaming\VRT\Temp
echo x=msgbox("WARNING: We detected Kaspersky on your system, Kaspersky Sometimes false positives our application as PDM:Trojan.Win32.Generic because of a trojan called kav.exe that this tool scans and deletes but this file is also a legit file of Kaspersky this process will automaticcly be skipped (you can configure this in the settings)" ,3+16, "Kaspersky False Positive Warning") >> KasperskyAV.vbs
echo.
cd %UserProfile%\Appdata\Roaming\VRT\Temp
START KasperskyAV.vbs
cd %UserProfile%\Appdata\Roaming\VRT\Temp
CLS
echo.
echo Warning Message Displayed Waiting For User Input...
cd %UserProfile%\Appdata\Roaming\VRT\Temp
pause> nul
del KasperskyAV.vbs
GOTO SysStart-chk
:SysStart-chk
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 GOTO SysStart
goto SysStart-Que

:SysStart-Que
cls
echo.
echo We can see you did not run this application as administrator!
echo Without admin VRT cannot delete all malware!
echo in folders like C:\Windows making your system still vulnerable!
echo.
set /P c=Do you want to run SystemScan anyways[Y/N]?
if /I "%c%" EQU "Y" goto SysStart
if /I "%c%" EQU "N" goto :exit

:SysStart
cd %Userprofile%\Appdata\Roaming\VRT
findstr "GlobalUpdate" VRT_Data.txt>NUL
IF ERRORLEVEL 1 (GOTO SysStart-Global) ELSE (GOTO SysStart2)

:SysStart2
cd %Userprofile%\Appdata\Roaming\VRT
findstr "Tencent.QQ" VRT_Data.txt>NUL
IF ERRORLEVEL 1 (GOTO SysStart-Tencent) ELSE (GOTO MalChromeID)

:SysStart-Global
set/a GlobalFoundBefore=1
GOTO SysStart2

:SysStart-Tencent
set/a TencentFoundBefore=1
goto MalChromeID

:MalChromeID
cd %UserProfile%\AppData\Local\Google\Chrome\User Data\Default\Extensions
cls
echo.
echo Scanning for Malicious Extensions on your system...
echo.
set/a Extension=0
set/a Extension1=0
set/a Extension2=0
set/a Extension3=0
set/a Extension4=0
set/a Extension5=0
set/a Extension6=0
set/a Extension7=0
set/a Extension8=0
set/a Extension9=0
set/a Extension10=0
set/a Extension11=0
set/a Extension12=0
set/a Extension13=0
set/a Extension14=0
set/a Extension15=0
set/a Extension16=0
set/a Extension17=0
set/a Extension18=0
set/a Extension19=0
set/a Extension20=0
set/a Extension21=0
set/a Extension22=0
set/a Extension23=0
set/a Extension24=0
set/a Extension25=0
set/a Extension26=0
set/a Extension27=0
set/a ExtensionAmoun=0
if exist bannaglhmenocdjcmlkhkcciioaepfpj set/a Extension4=1 && set/a ExtensionAmoun+=1 && rmdir /s /q bannaglhmenocdjcmlkhkcciioaepfpj
if exist bgffinjklipdhacmidehoncomokcmjmh set/a Extension5=1 && set/a ExtensionAmoun+=1 && rmdir /s /q bgffinjklipdhacmidehoncomokcmjmh
if exist bifdhahddjbdbjmiekcnmeiffabcfjgh set/a Extension6=1 && set/a ExtensionAmoun+=1 && rmdir /s /q bifdhahddjbdbjmiekcnmeiffabcfjgh
if exist bjpknhldlbknoidifkjnnkpginjgkgnm set/a Extension7=1 && set/a ExtensionAmoun+=1 && rmdir /s /q bjpknhldlbknoidifkjnnkpginjgkgnm
if exist blngdeeenccpfjbkolalandfmiinhkak set/a Extension8=1 && set/a ExtensionAmoun+=1 && rmdir /s /q blngdeeenccpfjbkolalandfmiinhkak
if exist ccdfhjebekpopcelcfkpgagbehppkadi set/a Extension9=1 && set/a ExtensionAmoun+=1 && rmdir /s /q ccdfhjebekpopcelcfkpgagbehppkadi
if exist cceejgojinihpakmciijfdgafhpchigo set/a Extension10=1 && set/a ExtensionAmoun+=1 && rmdir /s /q cceejgojinihpakmciijfdgafhpchigo
if exist cebjhmljaodmgmcaecenghhikkjdfabo set/a Extension11=1 && set/a ExtensionAmoun+=1 && rmdir /s /q cebjhmljaodmgmcaecenghhikkjdfabo
if exist chbpnonhcgdbcpicacolalkgjlcjkbbd set/a Extension12=1 && set/a ExtensionAmoun+=1 && rmdir /s /q chbpnonhcgdbcpicacolalkgjlcjkbbd
if exist cifafogcmckphmnbeipgkpfbjphmajbc set/a Extension13=1 && set/a ExtensionAmoun+=1 && rmdir /s /q cifafogcmckphmnbeipgkpfbjphmajbc
if exist clopbiaijcfolfmjebjinippgmdkkppj set/a Extension14=1 && set/a ExtensionAmoun+=1 && rmdir /s /q clopbiaijcfolfmjebjinippgmdkkppj
if exist cpgoblgcfemdmaolmfhpoifikehgbjbf set/a Extension15=1 && set/a ExtensionAmoun+=1 && rmdir /s /q cpgoblgcfemdmaolmfhpoifikehgbjbf
if exist dcmjopnlojhkngkmagminjbiahokmfig set/a Extension16=1 && set/a ExtensionAmoun+=1 && rmdir /s /q dcmjopnlojhkngkmagminjbiahokmfig
if exist deiiiklocnibjflinkfmefpofgcfhdga set/a Extension17=1 && set/a ExtensionAmoun+=1 && rmdir /s /q deiiiklocnibjflinkfmefpofgcfhdga
if exist dipecofobdcjnpffbkmfkdbfmjfjfgmn set/a Extension18=1 && set/a ExtensionAmoun+=1 && rmdir /s /q dipecofobdcjnpffbkmfkdbfmjfjfgmn
if exist dopkmmcoegcjggfanajnindneifffpck set/a Extension19=1 && set/a ExtensionAmoun+=1 && rmdir /s /q dopkmmcoegcjggfanajnindneifffpck
if exist dopmojabcdlfbnppmjeaajclohofnbol set/a Extension20=1 && set/a ExtensionAmoun+=1 && rmdir /s /q dopmojabcdlfbnppmjeaajclohofnbol
if exist edcepmkpdojmciieeijebkodahjfliif set/a Extension21=1 && set/a ExtensionAmoun+=1 && rmdir /s /q edcepmkpdojmciieeijebkodahjfliif
if exist ekbecnhekcpbfgdchfjcfmnocdfpcanj set/a Extension22=1 && set/a ExtensionAmoun+=1 && rmdir /s /q ekbecnhekcpbfgdchfjcfmnocdfpcanj
if exist elflophcopcglipligoibfejllmndhmp set/a Extension23=1 && set/a ExtensionAmoun+=1 && rmdir /s /q elflophcopcglipligoibfejllmndhmp
if exist kccohkcpppjjkkjppopfnflnebibpida set/a Extension24=1 && set/a ExtensionAmoun+=1 && rmdir /s /q kccohkcpppjjkkjppopfnflnebibpida
if exist kipjbhgniklcnglfaldilecjomjaddfi set/a Extension25=1 && set/a ExtensionAmoun+=1 && rmdir /s /q kipjbhgniklcnglfaldilecjomjaddfi
if exist lmjnegcaeklhafolokijcfjliaokphfk set/a Extension26=1 && set/a ExtensionAmoun+=1 && rmdir /s /q lmjnegcaeklhafolokijcfjliaokphfk
if exist npdpplbicnmpoigidfdjadamgfkilaak set/a Extension27=1 && set/a ExtensionAmoun+=1 && rmdir /s /q npdpplbicnmpoigidfdjadamgfkilaak
GOTO OperaExistCHK

:OperaExistCHK
set/a OperaExist=0
set/a ExtensionAmount=0
if exist %Userprofile%\AppData\Roaming\Opera Software\Opera Stable\Extensions set/a OperaExist+=1
if %OperaExist% GEQ 1 goto OperaMalwareID
goto Tencent.QQ

:OperaMalwareID
set/a ExtensionAmount=0
cd %Userprofile%\AppData\Roaming\Opera Software\Opera Stable\Extensions
if exist bannaglhmenocdjcmlkhkcciioaepfpj set/a ExtensionAmount+=1 && rmdir /s /q bannaglhmenocdjcmlkhkcciioaepfpj
if exist bgffinjklipdhacmidehoncomokcmjmh set/a ExtensionAmount+=1 && rmdir /s /q bgffinjklipdhacmidehoncomokcmjmh
if exist bifdhahddjbdbjmiekcnmeiffabcfjgh set/a ExtensionAmount+=1 && rmdir /s /q bifdhahddjbdbjmiekcnmeiffabcfjgh
if exist bjpknhldlbknoidifkjnnkpginjgkgnm set/a ExtensionAmount+=1 && rmdir /s /q bjpknhldlbknoidifkjnnkpginjgkgnm
if exist blngdeeenccpfjbkolalandfmiinhkak set/a ExtensionAmount+=1 && rmdir /s /q blngdeeenccpfjbkolalandfmiinhkak
if exist ccdfhjebekpopcelcfkpgagbehppkadi set/a ExtensionAmount+=1 && rmdir /s /q ccdfhjebekpopcelcfkpgagbehppkadi
if exist cceejgojinihpakmciijfdgafhpchigo set/a ExtensionAmount+=1 && rmdir /s /q cceejgojinihpakmciijfdgafhpchigo
if exist cebjhmljaodmgmcaecenghhikkjdfabo set/a ExtensionAmount+=1 && rmdir /s /q cebjhmljaodmgmcaecenghhikkjdfabo
if exist chbpnonhcgdbcpicacolalkgjlcjkbbd set/a ExtensionAmount+=1 && rmdir /s /q chbpnonhcgdbcpicacolalkgjlcjkbbd
if exist cifafogcmckphmnbeipgkpfbjphmajbc set/a ExtensionAmount+=1 && rmdir /s /q cifafogcmckphmnbeipgkpfbjphmajbc
if exist clopbiaijcfolfmjebjinippgmdkkppj set/a ExtensionAmount+=1 && rmdir /s /q clopbiaijcfolfmjebjinippgmdkkppj
if exist cpgoblgcfemdmaolmfhpoifikehgbjbf set/a ExtensionAmount+=1 && rmdir /s /q cpgoblgcfemdmaolmfhpoifikehgbjbf
if exist dcmjopnlojhkngkmagminjbiahokmfig set/a ExtensionAmount+=1 && rmdir /s /q dcmjopnlojhkngkmagminjbiahokmfig
if exist deiiiklocnibjflinkfmefpofgcfhdga set/a ExtensionAmount+=1 && rmdir /s /q deiiiklocnibjflinkfmefpofgcfhdga
if exist dipecofobdcjnpffbkmfkdbfmjfjfgmn set/a ExtensionAmount+=1 && rmdir /s /q dipecofobdcjnpffbkmfkdbfmjfjfgmn
if exist dopkmmcoegcjggfanajnindneifffpck set/a ExtensionAmount+=1 && rmdir /s /q dopkmmcoegcjggfanajnindneifffpck
if exist dopmojabcdlfbnppmjeaajclohofnbol set/a ExtensionAmount+=1 && rmdir /s /q dopmojabcdlfbnppmjeaajclohofnbol
if exist edcepmkpdojmciieeijebkodahjfliif set/a ExtensionAmount+=1 && rmdir /s /q edcepmkpdojmciieeijebkodahjfliif
if exist ekbecnhekcpbfgdchfjcfmnocdfpcanj set/a ExtensionAmount+=1 && rmdir /s /q ekbecnhekcpbfgdchfjcfmnocdfpcanj
if exist elflophcopcglipligoibfejllmndhmp set/a ExtensionAmount+=1 && rmdir /s /q elflophcopcglipligoibfejllmndhmp
if exist kccohkcpppjjkkjppopfnflnebibpida set/a ExtensionAmount+=1 && rmdir /s /q kccohkcpppjjkkjppopfnflnebibpida
if exist kipjbhgniklcnglfaldilecjomjaddfi set/a ExtensionAmount+=1 && rmdir /s /q kipjbhgniklcnglfaldilecjomjaddfi
if exist lmjnegcaeklhafolokijcfjliaokphfk set/a ExtensionAmount+=1 && rmdir /s /q lmjnegcaeklhafolokijcfjliaokphfk
if exist npdpplbicnmpoigidfdjadamgfkilaak set/a ExtensionAmount+=1 && rmdir /s /q npdpplbicnmpoigidfdjadamgfkilaak
goto Tencent.QQ

:Tencent.QQ
cls
set/a Scrax.dll=0
set/a SCRCFG.ini=0
set/a Tencent.QQ=0
echo Scanning for Adware on your system...
echo.
cd C:\Windows\System32
if exist Scrax.dll set/a Scrax.dll=1 && set/a Tencent.QQ+=1
cd C:\Windows
if exist SCRCFG.ini set/a SCRCFG.ini=1 && set/a Tencent.QQ+=1
cd C:\Program Files
if exist Tencent  set/a Tencent=1 && set/a Tencent.QQ+=1
if %Tencent.QQ% GEQ 1 GOTO Tencent.QQ-EXIST
if %Tencent.QQ%==0 GOTO GlobalUpdate
goto GlobalUpdate

:Tencent.QQ-EXIST
cd C:\Windows\System32
if %Scrax.dll%==1 DEL /Q Scrax.dll
cd C:\Windows
if %SCRCFG.ini%==1 DEL /Q SCRCFG.ini
cd C:\Program Files
if %Tencent%==1 rmdir /q Tencent
cd %UserProfile%\Appdata\Roaming\VRT
echo Tencent.QQ >> VRT_Data.txt
GOTO GlobalUpdate

:GlobalUpdate
set/a GlobaCore=0
set/a GlobalUpdate=0
set/a GlobaUA=0
set/a GlobaFolder=0
set/a Globa1d090=0
set/a Globa1d083=0
set/a Globa1d00b=0
set/a GlobaCore1cf=0
set/a comh.120035=0
set/a comh.133796=0
set/a comh.135462=0
set/a comh.139061=0
set/a comh.251661=0
set/a comh.328375=0
set/a comh.330025=0
set/a comh.354187=0
set/a comh.360877=0
set/a comh.365021=0
set/a comh.100087=0
set/a comh.495347=0
set/a globalUpdate=0
set/a GlobaUAid0=0
set/a GlobalProcess=0
cls
echo.
echo Scanning your sytem for Adware...
echo.
cd C:\Windows\System32\Tasks
if exist globalUpdateUpdateTaskMachineCore.job set/a GlobalUpdate+=1 && set/a GlobaCore=1
if exist globalUpdateUpdateTaskMachineUA.job set/a GlobalUpdate+=1 && set/a GlobaUA=1 
if exist globalUpdateUpdateTaskMachineCore1cfa030aa7c1cd0.job set/a GlobalUpdate+=1 && set/a GlobaCore1cf=1
if exist globalUpdateUpdateTaskMachineUA1d027fa37127575.job set/a GlobalUpdate+=1 && set/a GlobaUAid0
tasklist /fi "ImageName eq globalUpdateUpdateTaskMachineUA.job" /fo csv 2>NUL | find /I "globalUpdateUpdateTaskMachineUA.job">NUL
if "%ERRORLEVEL%"=="0" GOTO TASKKILL-GLOBA
GOTO GlobaContin

:TASKKILL-GLOBA
taskkill /im globalUpdateUpdateTaskMachineUA.job
cls
:GlobaContin
cd C:\Windows\Tasks
if exist globalUpdateUpdateTaskMachineCore1d090d32ba0eea.job set/a GlobalUpdate+=1 && set/a Globa1d090=1
if exist globalUpdateUpdateTaskMachineCore1d083722ddab71d.job set/a GlobalUpdate+=1 && set/a Globa1d083=1
if exist globalUpdateUpdateTaskMachineCore1d00bad5de224b6.job set/a GlobalUpdate+=1 && set/a Globa1d00b
cd %UserProfile%\Appdata\Local\Temp
if exist comh.847 set/a GlobalUpdate+=1 && set/a comh.847=1
if exist comh.120035 set/a GlobalUpdate+=1 && set/a comh.847=1
if exist comh.133796 set/a GlobalUpdate+=1 && set/a comh.133796=1
if exist comh.135462 set/a GlobalUpdate+=1 && set/a comh.135462=1
if exist comh.139061 set/a GlobalUpdate+=1 && set/a comh.139061=1
if exist comh.221081 set/a GlobalUpdate+=1 && set/a comh.221081=1
if exist comh.251661 set/a GlobalUpdate+=1 && set/a comh.251661=1
if exist comh.328375 set/a GlobalUpdate+=1 && set/a comh.328375=1
if exist comh.330025 set/a GlobalUpdate+=1 && set/a comh.330025=1
if exist comh.354187 set/a GlobalUpdate+=1 && set/a comh.354187=1
if exist comh.360877 set/a GlobalUpdate+=1 && set/a comh.360877=1
if exist comh.365021 set/a GlobalUpdate+=1 && set/a comh.365021=1
if exist comh.100087 set/a GlobalUpdate+=1 && set/a comh.100078=1
if exist comh.495347 set/a GlobalUpdate+=1 && set/a comh.495347=1
cd C:\Program Files
if exist globalUpdate set/a GlobalUpdate+=1 && set/a GlobalFolder=1
if %GlobalUpdate% GEQ 1 GOTO GlobalUpdate-Results
GOTO FastScan-Ransom

:GlobalUpdate-Results
cd C:\Windows\System32\Tasks
if %GlobaCore%==1 DEL /Q globalUpdateUpdateTaskMachineCore.job
if %GlobaUA%==1 DEL /Q globalUpdateUpdateTaskMachineUA.job
if %GlobaFolder%==1 rmdir /q globalUpdate
if %Globa1d090%==1 DEL /Q globalUpdateUpdateTaskMachineCore1d090d32ba0eea.job
if %Globa1d083%==1 DEL /Q globalUpdateUpdateTaskMachineCore1d083722ddab71d.job
if %Globa1d00b%==1 DEL /Q globalUpdateUpdateTaskMachineCore1d00bad5de224b6.job
if %GlobaCore1cf%==1 DEL /Q globalUpdateUpdateTaskMachineCore1cfa030aa7c1cd0.job
cd %Userprofile%\Appdata\local\Temp
if %comh.120035%==1 rmdir /q /s comh.120035
if %comh.133796%==1 rmdir /q /s comh.133796
if %comh.135462%==1 rmdir /q /s comh.135462
if %comh.139061%==1 rmdir /q /s comh.139061
if %comh.251661%==1 rmdir /q /s comh.251661
if %comh.328375%==1 rmdir /q /s comh.328375
if %comh.330025%==1 rmdir /q /s comh.330025
if %comh.354187%==1 rmdir /q /s comh.354187
if %comh.360877%==1 rmdir /q /s comh.360877
if %comh.100087%==1 rmdir /q /s comh.100087
if %comh.495347%==1 rmdir /q /s comh.495347
cd C:\Program Files
if %globalUpdate%==1 rmdir globalUpdate
if %GlobalProcess%==1 set/a RunningGlobalUpdate+=1
cd %UserProfile%\Appdata\Roaming\VRT
echo GlobalUpdate >> VRT_Data.txt
GOTO FastScan-Ransom

:FastScan-Ransom
set/a sysguard=0
cd C:\Windows
if exist sysguard set/a sysguard=1 && goto sysguard-removal
Goto Ransom-Exten

:sysguard-removal
cd C:\Windows
rmdir /q /s sysguard
cd %UserProfile%\Appdata\Roaming\VRT
echo sysguard >> VRT_Data.txt
goto Ransom-Exten

:Ransom-Exten
cd %UserProfile%\Documents
set/a RansomExten=0
set/a CryptoExten=0
set/a EncExten=0
set/a ChanExten=0
cls
echo.
echo Scanning your system for Ransomeware...
if exist *.crypto set/a RansomExten+=1 && set/a CryptoExten=1
if exist *.enc set/a RansomExten+=1 && set/a EncExten=1
if exist *.nochance set/a RansomExten+=1 && set/a ChanExten=1
GOTO Ransom-Chk

:Ransom-Chk
if %CryptoExten%==1 GOTO CryptoExten
if %EncExten%==1 GOTO EncExten
if %ChanExten%==1 GOTO ChanExten

:CryptoExten
for %%k in (*.crypto) do (
set CryptoFile=%%k
)
GOTO Ransom-Contin

:EncExten
for %%t in (*.enc) do (
set EncFile=%%t
)
GOTO Ransom-Contin

:ChanExten
for %%r in (*.nochance) do (
set ChanFile=%%r
)
GOTO Ransom-Contin

:Ransom-Contin
GOTO FastScan-Spyware

:FastScan-Spyware
set/a AST=0
set/a asectool=0
set/a scan.dll=0
set/a DesktopInkAST=0
cd %UserProfile%\Appdata\Roaming
cls
echo.
echo Scanning your system for Spyware...
if exist asectool.exe set/a AST+=1 && set/a asectool=1
if exist scan.dll set/a AST+=1 && set/a scan.dll=1
cd %UserProfile%\Desktop
if exist Advanced Security Tool 2010.Ink set/a AST+=1 && set/a DesktopInkAST=1
if %AST% GEQ 1 GOTO AST-DEL
GOTO Spyware.Barby

:AST-DEL
cd %UserProfile%\Appdata\Roaming
if %asectool%==1 DEL /Q asectool.exe
if %scan.dll%==1 DEL /Q scan.dll
CD %UserProfile%\Desktop
if %DesktopInkAST%==1 DEL /Q Advanced Security Tool 2010.Ink
cd %UserProfile%\Appdata\Roaming\VRT
echo AST >> VRT_Data.txt
GOTO Spyware.Barby

:Spyware.Barby
set/a Spy.Barby=0
set/a ddraw16=0
cd C:\Windows\System32
if exist ddraw16.exe set/a Spy.Barby+=1 && ddraw16=1
if %Spy.Barby%==1 GOTO SpyBarby-DEL
GOTO Spyware.AdClicker

:SpyBarby-DEL
if %Spy.Barby%==1 set/a Win64/Backdoor.Barby=1 && DEL ddraw16.exe
cd %UserProfile%\Appdata\Roaming\VRT
echo Spyware.Barby >> VRT_Data.txt
GOTO Spyware.AdClicker

:Spyware.AdClicker
cd C:\Windows\System32
set/a AdClicker=0
set/a hqj.dll=0
set/a cygwn32.dll=0
set/a marwin32.dll=0
set/a aujdh.exe=0
set/a mukmil.dll=0
set/a jmkqr=0
set/a AdClickerFolder=0
set/a CSUNIN=0
set/a KAV.EXE=0
set/a KAV2.EXE=0
if exist C:\Windows\System32\_hqjkqhnfjhc.dll set/a AdClicker+=1 && set/a hqj.dll=1 && DEL /Q _hqjkqhnfjhc.dll
if exist C:\Windows\System32\cygwn32.dll set/a AdClicker+=1 && set/a cygwn32.dll=1 && DEL /Q cywgn32.dll
if exist C:\Windows\System32\marwin32.dll set/a AdClicker+=1 && set/a marwin32.dll=1 && DEL /Q marwin.dll
if exist C:\Windows\System32\aujdhrrhfjl.exe set/a AdClicker+=1 && set/a aujdh.exe=1 && DEL /Q aujdhrrhfjl.exe
if exist C:\Windows\System32\mukmil.dll set/a AdClicker+=1 && set/a mukmil.dll=1 && DEL /Q mukmil.dll
if exist C:\Windows\System32\jmkqrfcl.dll set/a AdClicker+=1 && jmkqr=1 && DEL /Q jmkqrfcl.dll
cd C:\Program Files
if exist nxmcoqe set/a AdClicker+=1 && AdClickerFolder+=1 && rmdir /s /q nxmcoqe
if exist eachnet set/a AdClicker+=1 && AdClickerFolder+=1 && rmdir /s /q eachnet
cd C:\Windows\System32
if exist C:\Windows\System32\CSUNINST.EXE set/a AdClicker+=1 && CSUNIN=1 && DEL /Q CSUNINST.EXE
if exist C:\Windows\System32\KAV.EXE set/a AdClicker+=1 && set/a KAV.EXE=1 && DEL /Q KAV.EXE
cd C:\Windows
if exist C:\kav.exe set/a AdClicker+=1 && set/a KAV2.EXE=1 && DEL /Q kav.exe
cd %UserProfile%\Appdata\Roaming\VRT
if %AdClicker% GEQ 1 echo AdClickerFound >> VRT_Data.txt
GOTO Spyware.Backdoors

:Spyware.Backdoors
cls
echo.
echo Scanning for Backdoor Exploits in your system...
cd .
set/a WinPortFile=0
set/a localbase=0
set/a certcii=0
set/a Tuto=0
set/a AfCore=0
set/a AnalProcess=0
set/a analftp=0
set/a AnalVirus=0
set/a allch=0
set/a AdultLinks=0
set/a allchSys32=0
set/a qcbar=0
set/a qcbarSys32=0
set/a llch=0
if exist C:\Windows\winport.com set/a WinPortFile=1 && Tuto+=1 && DEL /Q C:\Windows\winport.com
if exist C:\Windows\localbase.dll set/a localbase=1 && Tuto+=1 && DEL /Q C:\Windows\localbase.dll
if exist C:\Windows\System32\certcgii.dll set/a certcii=1 && set/a AfCore+=1 && DEL /Q C:\Windows\System32\certcgii.dll
if exist C:\Windows\System32\datioe.dll set/a datioe=1 && set/a AfCore+=1 && DEL /Q C:\Windows\System32\datioe.dll
echo.
tasklist /fi "ImageName eq analftp.exe" /fo csv 2>NUL | find /I "analftp.exe">NUL
if "%ERRORLEVEL%"=="0" set/a AnalProcess=1 set/a MaliciousProcess+=1 && taskkill /im analftp.exe
if exist C:\Windows\analftp.exe set/a analftp=1 && set/a AnalVirus+=1 && DEL /Q C:\Windows\analftp.exe
if exist C:\Windows\downloaded program files\allch.dll set/a allch=1 && set/a AdultLinks+=1 && DEL /Q C:\Windows\downloaded program files\allch.dll
if exist C:\Windows\System32\allch.dll set/a allchSys32=1 && set/a AdultLinks+=1 && DEL /Q C:\Windows\System32\allch.dll
if exist C:\Windows\downloaded program files\qcbar.dll set/a qcbar=0 && set/a AdultLinks+=1 && DEL /Q C:\Windows\downloaded program files\qcbar.dll
if exist C:\Windows\System32\qcbar.dll set/a qcbarSys32=1 && set/a AdultLinks+=1 && DEL /Q C:\Windows\System32\qcbar.dll
if exist C:\Windows\System32\llch.dll set/a llch=1 && set/a AdultLinks+=1 && DEL /Q C:\Windows\System32\llch.dll
set/a magent=0
set/a bagle=0
if exist C:\Windows\System32\magent.exe set/a magent=1 && set/a bagle+=1 && DEL /Q C:\Windows\System32\magent.exe
GOTO FastScan-Files


:FastScan-Files
set /a ZeroDay=0
set/a ToolBarDetect=0
goto ZERODAY

:ZERODAY
set/a Toolbar3=0
set/a ToolBar4=0
set/a ToolBar2=0
set/a ToolBar1=0
set/a BDSSetup=0
set/a Basta=0
set/a Heur=0
cd %userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files
if exist AskToolbarInstaller-ATU3-TMP[4].7z set/a ToolBar4=1 && set/a ZeroDay+=1 && DEL /Q AskToolbarInstaller-ATU3-TMP[4].7z
if exist AskToolbarInstaller-ATU3-TMP[3].7z set/a ToolBar3=1 && set/a ZeroDay+=1 && DEL /Q AskToolbarInstaller-ATU3-TMP[3].7z
if exist AskToolbarInstaller-ATU3-TMP[2].7z set/a ToolBar2=1 && set/a ZeroDay+=1 && DEL /Q AskToolbarInstaller-ATU3-TMP[2].7z
if exist AskToolbarInstaller-ATU3-TMP[1].7z set/a ToolBar1=1 && set/a ZeroDay+=1 && DEL /Q AskToolbarInstaller-ATU3-TMP[1].7z
set/a ToolBarDetect=%ToolBar4%+%ToolBar3%+%ToolBar1%+%ToolBar2%
cd C:\Windows\System32
if exist BDSSetup.exe set/a BDSSetup=1 && set/a ZeroDay+=1 && DEL /Q BDSSetup.exe
if exist C:\Windows\System32\BastaYa.exe set/a Basta+=1 && DEL /Q C:\Windows\System32\BastaYa.exe
if exist C:\Program Files\Google\Chrome\Application\amvn.js set/a ZeroDay+=1 && set/a Heur=1 && DEL /Q C:\Program Files\Google\Chrome\Application\amvn.js
GOTO Backdoor.svchost

:Backdoor.svchost
cls
echo.
echo Scanning for Backdoor Exploits on your system...
set/a winsvchost=0
set/a Tempsvchost=0
set/a Sys32Tasksvc=0
set/a PrgFlsvc=0
set/a DriverSVC=0
set/a svchost.exe=0
set/a schost=0
if exist C:\Windows\svchost.exe set/a winsvchost=1 && set/a svchost.exe+=1 && DEL /Q C:\Windows\svchost.exe
if exist %UserProfile%\Appdata\Local\Temp\svchost.exe set/a Tempsvchost=1 && set/a svchost.exe+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\svchost.exe
if exist C:\Windows\Tasks\svchost.exe set/a Sys32Tasksvc=1 && set/a svchost.exe+=1 && DEL /Q C:\Windows\Tasks\svchost.exe
if exist C:\program files\svchost.exe set/A PrgFlsvc=1 && set/a svchost.exe+=1 && DEL /Q C:\program files\svchost.exe
if exist C:\Windows\System32\drivers\svchost.exe set/a DriverSVC=1 && set/a svchost.exe+=1 && DEL /Q C:\Windows\System32\drivers\svchost.exe
if exist C:\Windows\System32\schost.exe set/a schost=1 && set/a svchost.exe+=1 && DEL /Q C:\Windows\System32\schost.exe
goto Rootkit.Scanner.Agent

:Rootkit.Scanner.Agent
set/a cel90=0
set/a Win32.Agent=0
set/a cel90Temp=0
if exist C:\Windows\Temp\cel90xbe.sys set/a cel90=1 && set/a Win32.Agent+=1 && DEL /Q  C:\Windows\Temp\cel90xbe.sys
if exist C:\Program Files\superutilbar set/a RootkitAgentFolder+=1 && Win32.Agent+=1 && rmdir /s /q C:\Program Files\superutilbar
if exist %UserProfile%\Appdata\Local\Temp\cel90xbe.sys set/a cel90Temp=1 && Win32.Agent+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\cel90xbe.sys
GOTO Rootkit.Scanner.Msq

:Rootkit.Scanner.Msq
set/a xondsys=0
set/a Msq=0
set/a vmbm=0
set/a vrmy=0
set/a bics=0
set/a brsr=0
set/a oiqh=0
set/a xfum=0
set/a mtkd=0
set/a xeya=0
set/a obqj=0
set/a wprq=0
if exist C:\Windows\System32\Drivers\msqpdxlypgxond.sys set/a xondsys=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\Drivers\msqpdxlypgxond.sys
if exist C:\Windows\System32\msqpdxoqecvmbm.dll set/a vmbm=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\msqpdxoqecvmbm.dll
if exist C:\Windows\System32\msqpdxmxcyvrmy.dll set/a vrmy=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\msqpdxmxcyvrmy.dll
if exist C:\Windows\System32\Drivers\msqpdxxqibbics.sys set/a bics=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\Drivers\msqpdxxqibbics.sys
if exist C:\Windows\System32\msqpdxosvdbrsr.dll set/a brsr=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\msqpdxosvdbrsr.dll
if exist C:\Windows\System32\drivers\msqpdxmqltoiqh.sys set/s oiqh=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\drivers\msqpdxmqltoiqh.sys
if exist C:\Windows\System32\msqpdxriqpxfum.dll set/a xfum=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\msqpdxriqpxfum.dll
if exist C:\Windows\System32\msqpdxkopxmtkd.dll set/a mtkd=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\msqpdxkopxmtkd.dll
if exist C:\Windows\System32\msqpdxccecxeya.dll set/a xeya=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\msqpdxccecxeya.dll
if exist C:\Windows\System32\Drivers\msqpdxylvrobqj.sys set/a obqj=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\Drivers\msqpdxylvrobqj.sys
if exist C:\Windows\System32\Drivers\msqpdxqjxuwprq.sys set/a wprq=1 && set/a Msq+=1 && DEL /Q C:\Windows\System32\Drivers\msqpdxqjxuwprq.sys
goto Worm.Scanner

:Worm.Scanner
set/a FrameWork=0
if exist C:\Windows\System32\FrameWork.exe set/a FrameWork+=1 && DEL /Q C:\Windows\System32\FrameWork.exe
goto VirTool.Scanner

:VirTool.Scanner
set/a bfgminer=0
set/a BitMiner=0
set/a opencl=0
set/a Miner=0
set/a CpuMiner=0
set/a CpuMiner2=0
set/a pts=0
set/a csrssWin=0
set/a helper=0
set/a conhost=0
set/a poclbm=0
if exist %UserProfile%\Appdata\com.flash.WidgetBrowser\bfgminer.bat set/a bfgminer=1 && set/a BitMiner+=1 && DEL /Q %UserProfile%\Appdata\com.flash.WidgetBrowser\bfgminer.bat
if exist C:\Windows\rpcminer\bitcoinmineropencl.cl set/a opencl=1 && set/a BitMiner+=1 && DEL /Q C:\Windows\rpcminer\bitcoinmineropencl.cl
if exist %UserProfile%\Appdata\Local\Temp\Miner.exe set/a Miner=1 && set/a BitMiner+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\Miner.exe
if exist %UserProfile%\Appdata\Local\Temp\NsCpuCNMiner32.exe set/a CpuMiner=1 && set/a BitMiner+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\NsCpuCNMiner32.exe
if exist %UserProfile%\Appdata\Local\Temp\2\NsCpuCNMiner32.exe set/a CpuMiner2=1 && set/a BitMiner+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\2\NsCpuCNMiner32.exe
if exist C:\temp\pts5a.exe set/a BitMiner+=1 && DEL /Q C:\temp\pts5a.exe
if exist %UserProfile%\Appdata\Local\Temp\pts5a.exe set/a pts=1 && set/a BitMiner+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\pts5a.exe
if exist C:\temp\wc1a.exe set/a BitMiner+=1 && DEL /Q C:\temp\wc1a.exe
if exist C:\Windows\csrss.exe set/a csrssWin=1 && set/a BitMiner+=1 && DEL /Q C:\Windows\csrss.exe
if exist %UserProfile%\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\helper.ink set/a helper=1 && set/a BitMiner+=1 && DEL /Q %UserProfile%\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\helper.ink
if exist %UserProfile%\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\conhost32.exe set/a conhost=1 && set/a BitMiner+=1 && DEL /Q %UserProfile%\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\conhost32.exe
if exist %UserProfile%\Appdata\Local\Temp\poclbm.cl set/a poclbm=1 && set/a BitMiner+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\poclbm.cl
goto Virtool.DelInject

:Virtool.DelInject
set/a cssProgram=0
set/a DelInject=0
set/a KopSys32=0
if exist C:\Program Files\css.exe set/a cssProgram=1 set/a && set/a DelInject+=1 && DEL /Q C:\Program Files\css.exe
if exist C:\Windows\System32\kop.exe set/a KopSys32=1 && set/a DelInject+=1 && DEL /Q C:\Windows\System32\kop.exe
goto Virtool.ObFuscator

:Virtool.ObFuscator
CD %UserProfile%\Appdata\Local\Temp
set/a ObFus=0
if exist %UserProfile%\Appdata\Local\Temp\tmph3177712440872985331.tmp set/a ObFus+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\tmph3177712440872985331.tmp
if exist %UserProfile%\Appdata\Local\Temp\DAT4B6.tmp.exe set/a ObFus+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\DAT4B6.tmp.exe
if exist %UserProfile%\Appdata\Local\Temp\DATEF.tmp.exe set/a ObFus+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\DATEF.tmp.exe
if exist %UserProfile%\Appdata\Local\Temp\tmph6991948211928276353.tmp set/a ObFus+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\tmph6991948211928276353.tmp
if exist %UserProfile%\Appdata\Local\Temp\tmph2039790625174568602.tmp set/a ObFus+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\tmph2039790625174568602.tmp
if exist %UserProfile%\Appdata\Local\Temp\tmph7846970360140126121.tmp set/a ObFus+=1 && DEL /Q tmph7846970360140126121.tmp
if exist %UserProfile%\Appdata\Local\Temp\DAT2A4.tmp.exe set/a ObFus+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\DAT2A4.tmp.exe
if exist %UserProfile%\Appdata\Local\Temp\DAT5B.tmp.exe set/a ObFus+=1 && %UserProfile%\Appdata\Local\Temp\DAT5B.tmp.exe
if exist %UserProfile%\Appdata\Local\Temp\DAT532.tmp.exe set/a ObFus+=1 && %UserProfile%\Appdata\Local\Temp\DAT532.tmp.exe
if exist %UserProfile%\Appdata\Local\Temp\DAT63.tmp.exe set/a ObFus+=1 && %UserProfile%\Appdata\Local\Temp\DAT63.tmp.exe
if exist %UserProfile%\Appdata\Local\Temp\DAT79F.tmp.exe set/a ObFus+=1 && %UserProfile%\Appdata\Local\Temp\DAT79F.tmp.exe
if exist %UserProfile%\Appdata\Local\Temp\DAT20A1.tmp.exe set/a ObFus+=1 && %UserProfile%\Appdata\Local\Temp\DAT20A1.tmp.exe
goto Backdoor.AgentRW

:Backdoor.AgentRW
set/a idesk=0
set/a AgentRW=0
if exist C:\Windows\System32\idesk.conf set/a idesk=1 && set/a AgentRW+=1 && DEL /Q C:\Windows\System32\idesk.conf
GOTO Backdoor.AgentAG

:Backdoor.AgentAG
set/a AgentAG=0
if exist C:\Windows\System32\phomac.exe set/a AgentAG+=1 && DEL /Q C:\Windows\System32\phomac.exe
GOTO Backdoor.AgentGF

:Backdoor.AgentGF
set/a AgentGF=0
if exist C:\Windows\winserver.exe set/a AgentGF+=1 && DEL /Q C:\Windows\winserver.exe
goto Backdoor.AgentAC

:Backdoor.AgentAC
set/a vbs=0
set/a AgentAC=0
set/a wdmb=0
if exist C:\Windows\System32\vbsys2.dll set/a vbs=1 && set/a AgentAC+=1 && DEL /Q C:\Windows\System32\vbsys2.dll
if exist C:\Windows\System32\wdmbgnb_.dll set/a wdmb=1 && set/a AgentAC+=1 && DEL /Q C:\Windows\System32\wdmbgnb_.dll
goto Backdoor.AgentAQ

:Backdoor.AgentAQ
set/a AgentAQ=0
goto AFX.Windows.Rootkit

:AFX.Windows.Rootkit
set/a iexplore=0
set/a iexploreWin=0
set/a AFXRootkit=0
if exist C:\Windows\System32\iexplore.dll set/a iexplore=1 && set/a AFXRootkit+=1 && DEL /Q C:\Windows\System32\iexplore.dll
if exist C:\Windows\iexplore.dll set/a iexploreWin=1 && set/a AFXRootkit+=1 && DEL /Q C:\Windows\iexplore.dll
GOTO Backdoor.AgotbotGen

:Backdoor.AgotbotGen
set/a Agotbot=0
if exist C:\Windows\temp\msgked.exe set/a Agotbot+=1 && DEL /Q C:\Windows\temp\msgked.exe
if exist C:\Windows\System32\msgked.exe set/a Agotbot+=1 && DEL /Q C:\Windows\System32\msgked.exe
if exist C:\Windows\System32\msmc.exe set/a Agotbot+=1 && DEL /Q C:\Windows\System32\msmc.exe
if exist C:\Windows\System32\soundtasks.exe set/a Agotbot+=1 && DEL /Q C:\Windows\System32\soundtasks.exe
if exist C:\Windows\System32\wmon32.exe set/a Agotbot+=1 && DEL /Q C:\Windows\System32\wmon32.exe
goto AOT.KeyHook

:AOT.KeyHook
set/a AOT=0
if exist C:\Windows\System32\2020search.dll set/a AOT+=1 && DEL /Q C:\Windows\System32\2020search.dll
if exist C:\Windows\mspphe.dll set/a AOT+=1 && DEL /Q C:\Windows\mspphe.dll
if exist C:\Windows\mssvr.exe set/a AOT+=1 && DEL /Q C:\Windows\mssvr.exe
if exist C:\Windows\bjam.dll set/a AOT+=1 && DEL /Q C:\Windows\bjam.dll
if exist C:\Windows\2020search2.dll set/a AOT+=1 && DEL /Q C:\Windows\2020search2.dll
goto Hijacker

:Hijacker
set/a mst=0
if exist C:\Windows\System32\MSTRC32.DLL set/a mst+=1 && DEL /Q C:\Windows\System32\MSTRC32.DLL
goto ASR

:ASR
set/a ASR=0
if exist C:\Program Files\HCWC\assault.exe set/a ASR+=1 && DEL /Q C:\Program Files\HCWC\assault.exe
if exist C:\Windows\Temp\assault_original.exe set/a ASR+=1 && DEL /Q C:\Windows\Temp\assault_original.exe
goto Downloader

:Downloader
set/a CasinoURL=0
set/a Cas=0
set/a clrschp=0
if exist %UserProfile%\Desktop\old port casino.url set/a CasinoURL=1 && set/a Cas+=1 && DEL /Q %UserProfile%\Desktop\old port casino.url
if exist C:\Windows\System32\clrschp033.exe set/a clrschp=1 && set/a Cas+=1 && DEL /Q C:\Windows\System32\clrschp033.exe
set/a arup=0
set/a Skymm=0
if exist C:\Windows\arupdate.exe set/a arup+=1 && DEL /Q C:\Windows\arupdate.exe
if exist C:\Windows\adroar.dll set/a arup+=1 && DEL /Q C:\Windows\adroar.dll
if exist C:\Windows\System32\adroar.dll set/a arup+=1 && DEL /Q C:\Windows\System32\adroar.dll
if exist C:\Windows\cpr.exe set/a arup+=1 && DEL /Q C:\Windows\cpr.exe
if exist C:\Windows\Temp\Cpr.exe set/a arup+=1 && DEL /Q C:\Windows\Temp\Cpr.exe
if exist C:\Windows\cpruninst.exe set/a arup+=1 && DEL /Q C:\Windows\cpruninst.exe
if exist C:\Windows\System32\cpr.dll set/a arup+=1 && DEL /Q C:\Windows\System32\cpr.dll
if exist %UserProfile%\Appdata\Local\Temp\Skymmstp013.exe set/a Skymm+=1 && DEL /Q %UserProfile%\Appdata\Local\Temp\Skymmstp013.exe
goto Bot.Net

:Bot.Net
set/a ejtlzm=0
if exist C:\Windows\ejtlzm.exe set/a ejtlzm+=1 && DEL /Q C:\Windows\ejtlzm.exe
echo.
goto Packetapp

:Packetapp
set/a PacketAPP=0
cd %UserProfile%\Appdata\Local\Temp
if exist Packet.dll set/a PacketAPP+=1 && DEL /Q %UserProfile%\AppData\Local\Temp\Packet.dll
cd C:\Windows
if exist Packet.dll set/a PacketAPP+=1 && DEL /Q C:\Windows\Packet.dll
goto Lineage.Trojan

:Lineage.Trojan
set/a Liner=0
if exist C:\Windows\TEMP\Kn3Iu\file.exe set/a Liner+=1 && DEL /Q C:\Windows\TEMP\Kn3Iu\file.exe
if exist C:\Windows\System32\file.exe set/a Liner+=1 && DEL /Q C:\Windows\System32\file.exe
if exist C:\Program Files\file.exe set/a Liner+=1 && DEL /Q C:\Program Files\file.exe
if exist C:\Program Files\Common Files\file.exe set/a Liner+=1 && DEL /Q C:\Program Files\Common Files\file.exe
if exist C:\Windows\System32\Drivers\etc\file.exe set/a Liner+=1 && DEL /Q C:\Windows\System32\Drivers\etc\file.exe
goto advanceddrive

:advanceddrive
set/a ADBJob=0
set/a ADU=0
set/a ADUProc=0
tasklist /fi "ImageName eq AdvancedDriverUpdater_UPDATES.job" /fo csv 2>NUL | find /I "AdvancedDriverUpdater_UPDATES.job">NUL
if "%ERRORLEVEL%"=="0" set/a ADUProc=1 && set/a MaliciousProcess+=1 && taskkill /im AdvancedDriverUpdater_UPDATES.job
if exist C:\Windows\Tasks\AdvancedDriverUpdater_UPDATES.job set/a ADVJob=1 && set/a ADU+=1 && DEL /Q C:\Windows\Tasks\AdvancedDriverUpdater_UPDATES.job
if exist C:\Windows\System32\Tasks\AdvancedDriverUpdaterRunAtStartup set/a ADU+=1 && DEL /Q C:\Windows\System32\Tasks\AdvancedDriverUpdaterRunAtStartup
if exist C:\Windows\System32\Tasks\AdvancedDriverUpdater_UPDATES set/a ADU+=1 && DEL /Q C:\Windows\System32\Tasks\AdvancedDriverUpdater_UPDATES
if exist %UserProfile%\APPDATA\Systweak\ADU set/a ADU+=1 && rmdir /s /q %UserProfile%\APPDATA\Systweak\ADU
if exist C:\Program Files\Advanced Driver Updater set/a ADU+=1 && rmdir /s /q C:\Program Files\Advanced Driver Updater
goto OK.TOOLBAR

:OK.TOOLBAR
echo.
cls
echo.
echo Searching for Spyware on your system...
set/a OKTOOLBAR=0
set/a ToolBarDLL=0
set/a OKMASTER=0
set/a OKTOOLBARFOLER=0
set/a OK.TOOLBARMaster=0
set/a ToolBarProces=0
tasklist /fi "ImageName eq OKMaster.exe" /fo csv 2>NUL | find /I "OKMaster.exe">NUL
if "%ERRORLEVEL%"=="0" set/a OK.TOOLBARMaster=1 && set/a MaliciousProcess+=1 && taskkill /im OKMaster.exe
tasklist /fi "ImageName eq OkToolbar.dll" /fo csv 2>NUL | find /I "OkToolbar.dll">NUL
if "%ERRORLEVEL%"=="0" set/a ToolBarProces=1 && set/a MaliciousProcess+=1 && taskkill /im OkToolbar.dll
if exist C:\Program Files\OKToolbar set/a OKTOOLBARFOLDER+=1 && set/a OKTOOLBAR+=2 && rmdir /s /q C:\Program Files\OKToolbar
if exist C:\Program Files\OKToolbar\OkToolbar.dll set/a ToolBarDLL=1 && set/a OKTOOLBAR+=1 && DEL /Q C:\Program Files\OKToolbar\OkToolbar.dll
if exist C:\Program Files\OKToolbar\OKMaster.exe set/a OKMASTER=1 && set/a OKTOOLBAR+=1 && DEL /Q C:\Program Files\OKToolbar\OKMaster.exe
goto Malware.WIN32.Mes

:Malware.WIN32.Mes
set/a Win32Mes=0
if exist C:\Program Files\Win32coMessenger set/a Win32Mes+=1 && rmdir /q /s C:\Program Files\Win32coMessenger
set/a Winlogon=0
tasklist /fi "ImageName eq Systen.dll" /fo csv 2>NUL | find /I "Systen.dll">NUL
if "%ERRORLEVEL%"=="0" set/a Winlogon+=1 && set/a MaliciousProcess+=1 && taskkill /im Systen.dll
tasklist /fi "ImageName eq explorer.dll" /fo csv 2>NUL | find /I "explorer.dll">NUL
if "%ERRORLEVEL%"=="0" set/a Winlogon+=1 && set/a MaliciousProcess+=1 && taskkill /im explorer.dll
if exist C:\Windows\System32\fpls0337e.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\fpls0337e.dll
if exist C:\Windows\System32\explorer.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\explorer.dll
if exist C:\Windows\System32\fpls0337e.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\fpls0337e.dll
if exist C:\Windows\System32\khdhept.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\khdhept.dll
if exist C:\Windows\System32\Systen.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\Systen.dll
if exist C:\Windows\System32\redist.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\redist.dll
if exist C:\Windows\System32\piofmap.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\piofmap.dll
if exist C:\Windows\System32\q668lgju16o8.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\q668lgju16o8.dll
if exist C:\Windows\System32\winbug32.dll set/a Winlogon+=1 && DEL /Q C:\Windows\System32\winbug32.dll
if exist C:\Windows\System32\winjgf32.dll se/a Winlogon+=1 && DEL /Q C:\Windows\System32\winjgf32.dll
goto Malware.imod

:Malware.imod
set/a imod=0
tasklist /fi "ImageName eq imod9.dll" /fo csv 2>NUL | find /I "imod9.dll">NUL
if "%ERRORLEVEL%"=="0" set/a imod+=1 && set/a MaliciousProcess+=1 && taskkill /im imod9.dll
if exist C:\Windows\System32\imod9.dll set/a imod+=1 && DEL /Q C:\Windows\System32\imod9.dll
goto Malware.Moneygainer

:Malware.Moneygainer
set/a shginas=0
tasklist /fi "ImageName eq shginas.dll" /fo csv 2>NUL | find /I "shginas.dll">NUL
if "%ERRORLEVEL%"=="0" set/a shginas+=1 && set/a MaliciousProcess+=1 && taskkill /im shginas.dll
if exist C:\Windows\shginas.dll set/a shginas+=1 && DEL /Q C:\Windows\shginas.dll
goto Malware.outerinfo

:Malware.outerinfo
set/a outerinfo=0
if exist C:\Program Files\A?pPatch set/a outerinfo+=1 && rmdir /s /q C:\Program Files\A?pPatch
if exist C:\Program Files\Outerinfo set/a outerinfo+=1 && rmdir /s /q C:\Program Files\Outerinfo
goto EliteCodec

:EliteCodec
set/a EliteCodec=0
set/a EliteCodecEXIST=0
if exist C:\Program Files\EliteCodec set/a EliteCodecEXIST=1 && goto EliteCodec-CONTIN
goto EliteCodecSkip

:EliteCode-CONTI
cd .
pushd c:\Program Files\EliteCodec
FOR %%A IN (*.exe) do (
tasklist /FI "IMAGENAME eq %%A" 2>NUL | find /I /N "%%A">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im %%A
cd .
)
pushd c:\Program Files\EliteCodec
FOR %%A IN (*.dll) do (
tasklist /FI "IMAGENAME eq %%B" 2>NUL | find /I /N "%%B">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im %%B
)
dir c:\Program Files\EliteCodec >nul
if exist C:\Program Files\EliteCodec set/a EliteCodec+=1 && rmdir /s /q C:\Program Files\EliteCodec
goto EliteCodecSkip

:EliteCodecSkip
goto Zlob.Malware

:Zlob.Malware
set/a Zlob=0
if exist C:\Program Files\FreeVideo set/a Zlob+=1 && rmdir /s /q C:\Program Files\FreeVideo
if exist C:\Program Files\VideoPlugin\Uninstall.exe set/a Zlob+=1 && DEL /Q C:\Program Files\VideoPlugin\Uninstall.exe
if exist C:\Program Files\DirectVideo set/a Zlob+=1 && rmdir /s /q C:\Program Files\DirectVideo 
if exist C:\Windows\frennk.dll set/a Zlob+=1 && DEL /Q C:\Windows\frennk.dll
if exist C:\Windows\System32\ixt3.dll set/a Zlob+=1 && DEL /Q C:\Windows\System32\ixt3.dll
if exist C:\Windows\System32\yephk.dll set/a Zlob+=1 && DEL /Q C:\Windows\System32\yephk.dll
goto FileCorrupter

:FileCorrupter
set/a FileCorruptCore=0
if exist C:\Windows\System32\fpfstb.dll set/a FileCorruptCore+=1 && DEL /Q C:\Windows\System32\fpfstb.dll
goto 01NET.com_Main

:01NET.com_Main
cd %UserProfile%\Appdata\LocalLow
set/a onenet=0
if exist %UserProfile%\Appdata\LocalLow\01NET.com_V1 set/a onenet+=1 && rmdir /s /q 01NET/com_V1
goto PUA

:PUA
set/a PUA=0
if exist %UserProfile%\Appdata\AceWebExtension set/a PUA+=1 && rmdir /s /q %UserProfile%\Appdata\AceWebExtension
if exist %UserProfile%\Appdata\Local\AceWebExtension set/a PUA+=1 && rmdir /s /q %UserProfile%\Appdata\Local\AceWebExtension
if exist C:\Program Files\50CoUpaons set/a PUA+=1 && rmdir /s /q C:\Program Files\50CoUpaons
if exist C:\Program Files\50CoUpons set/a PUA+=1 && rmdir /s /q C:\Program Files\50CoUpons
if exist C:\Program Files\550COupons set/a PUA+=1 && rmdir /s /q C:\Program Files\550COupons
if exist C:\Program Files\50Cooupons set/a PUA+=1 && rmdir /s /q C:\Program Files\50Cooupons
goto PROCESS_SCANNER

:PROCESS_SCANNER
set/a yew=0
set/a MaliciousProcess=0
set/a winport=0
set/a tmpMal=0
set/a tmpMal1=0
set/a ScrnSaver=0
set/a VidSaver=0
set/a giantsav=0
set/a IWant=0
set/a dfr=0
set/a flashinstaller=0
set/a Trojan.PWS=0
set/a shader3=0
set/a Bikini=0
set/a softpcp=0
set/a memz=0
cls
echo.
echo Scanning for Malicious Process running on your system...
tasklist /fi "ImageName eq yewimmxqbs32.exe" /fo csv 2>NUL | find /I "yewimmxqbs32.exe">NUL
if "%ERRORLEVEL%"=="0" set/a yew=1 && set/a MaliciousProcess+=1 && taskkill /im yewimmxqbs32.exe
tasklist /fi "ImageName eq winport.com" /fo csv 2>NUL | find /I "winport.com">NUL
if "%ERRORLEVEL%"=="0" set/a winport=1 && set/a MaliciousProcess+=1 && taskkill /im winport.com
tasklist /fi "ImageName eq 10aba34-5619.tmp" /fo csv 2>NUL | find /I "10aba34-5619.tmp">NUL
if "%ERRORLEVEL%"=="0" set/a tmpMal=1 && set/a MaliciousProcess+=1 && taskkill /im 10aba34-5619.tmp
tasklist /fi "ImageName eq 10aba34-5619.tmp" /fo csv 2>NUL | find /I "10aba34-5619.tmp">NUL
if "%ERRORLEVEL%"=="0" set/a tmpMal1=1 && set/a MaliciousProcess+=1 && taskkill /im 10aba34-5619.tmp
tasklist /fi "ImageName eq popularscreensavers.exe" /fo csv 2>NUL | find /I "popularscreensavers.exe">NUL
if "%ERRORLEVEL%"=="0" set/a ScrnSaver=1 && set/a MaliciousProcess+=1 && taskkill /im popularscreensavers.exe
tasklist /fi "ImageName eq VidSaver15_20120508.exe" /fo csv 2>NUL | find /I "VidSaver15_20120508.exe">NUL
if "%ERRORLEVEL%"=="0" set/a VidSaver=1 && set/a MaliciousProcess+=1 && taskkill /im VidSaver15_20120508.exe
tasklist /fi "ImageName eq giantsavings_us.exe" /fo csv 2>NUL | find /I "giantsavings_us.exe">NUL
if "%ERRORLEVEL%"=="0" set/a giantsav=1 && set/a MaliciousProcess+=1 && taskkill /im giantsavings_us.exe
tasklist /fi "ImageName eq IWantThis_ppi.exe.un.exe" /fo csv 2>NUL | find /I "IWantThis_ppi.exe.un.exe">NUL
if "%ERRORLEVEL%"=="0" set/a IWant=1 && set/a MaliciousProcess+=1 && taskkill /im IWantThis_ppi.exe.un.exe
tasklist /fi "ImageName eq dfr8FAF.tmp.exe" /fo csv 2>NUL | find /I "dfr8FAF.tmp.exe">NUL
if "%ERRORLEVEL%"=="0" set/a dfr=1 && set/a MaliciousProcess+=1 && taskkill /im dfr8FAF.tmp.exe
tasklist /fi "ImageName eq install_flash_player.exe" /fo csv 2>NUL | find /I "install_flash_player.exe">NUL
if "%ERRORLEVEL%"=="0" set/a flashinstaller=1 && set/a MaliciousProcess+=1 && taskkill /im install_flash_player.exe
tasklist /fi "ImageName eq Trojan.PWS.Onlinegames" /fo csv 2>NUL | find /I "Trojan.PWS.Onlinegames">NUL
if "%ERRORLEVEL%"=="0" set/a Trojan.PWS=1 && set/a MaliciousProcess+=1 && taskkill /im Trojan.PWS.Onlinegames
tasklist /fi "ImageName eq shader_model_3.0_free_download.rar_downloader_224a.exe" /fo csv 2>NUL | find /I "shader_model_3.0_free_download.rar_downloader_224a.exe">NUL
if "%ERRORLEVEL%"=="0" set/a shader3=1 && set/a MaliciousProcess+=1 && taskkill /im shader_model_3.0_free_download.rar_downloader_224a.exe
tasklist /fi "ImageName eq Bikini02.Scr" /fo csv 2>NUL | find /I "Bikini02.Scr">NUL
if "%ERRORLEVEL%"=="0" set/a Bikini=1 && set/a MaliciousProcess+=1 && taskkill /im Bikini02.Scr
tasklist /fi "ImageName eq soft_pcp_conduit.exe" /fo csv 2>NUL | find /I "soft_pcp_conduit.exe">NUL
if "%ERRORLEVEL%"=="0" set/a softpcp=1 && set/a MaliciousProcess+=1 && taskkill /im soft_pcp_conduit.exe
tasklist /fi "ImageName eq MEMZ.exe" /fo csv 2>NUL | find /I "MEMZ.exe">NUL
if "%ERRORLEVEL%"=="0" set/a memz=1 && set/a MaliciousProcess+=1 && taskkill /im MEMZ.exe
goto FAST-SCAN-RESUL

:FAST-SCAN-RESUL
set/a TotalDetections=0
set/a RansomMSG=0
cls
echo Collecting Results...
:SUM-RANSOM
if %CryptoExten% GEQ 1 set/a RansomMSG+=1
if %EncExten% GEQ 1 set/a RansomMSG+=1
if %ChanExten%==1 set/a RansomMSG+=1
echo.
if %Tencent.QQ% GEQ 1 set/a TotalDetections+=1
if %Spy.Barby% GEQ 1 set/a TotalDetections+=1
if %AdClicker% GEQ 1 set/a TotalDetections+=1
if %AST% GEQ 1 set/a TotalDetections+=1
if %RansomMSG% GEQ 1 set/a TotalDetections+=1
if %sysguard% GEQ 1 set/a TotalDetections+=1
if %GlobalUpdate% GEQ 1 set/a TotalDetections+=1
if %ZeroDay% GEQ 1 set/a TotalDetections+=1
if %Tuto% GEQ 1 set/a TotalDetections+=1
if %AfCore% GEQ 1 set/a TotalDetections+=1
if %AnalVirus% GEQ 1 set/a TotalDetections+=1
if %GlobalProcess%==1 set/a MaliciousProcess+=1
if %AdultLinks% GEQ 1 set/a MaliciousProcess+=1
if %svchost.exe% GEQ 1 set/a TotalDetections+=1
if %Win32.Agent% GEQ 1 set/a TotalDetections+=1
if %Framework% GEQ 1 set/a TotalDetections+=1
if %Msq% GEQ 1 set/a TotalDetections+=1
if %BitMiner% GEQ 1 set/a TotalDetections+=1
if %ObFus% GEQ 1 set/a TotalDetections+=1
if %DelInject% GEQ 1 set/a TotalDetections+=1
if %AgentRW% GEQ 1 set/a TotalDetections+=1
if %AgentAG% GEQ 1 set/a TotalDetections+=1
if %AgentGF% GEQ 1 set/a TotalDetections+=1
if %AgentAC% GEQ 1 set/a TotalDetections+=1
if %AgentAQ% GEQ 1 set/a TotalDetections+=1
if %AFXRootkit% GEQ 1 set/a TotalDetections+=1
if %Agotbot% GEQ 1 set/a TotalDetections+=1
if %AOT% GEQ 1 set/a TotalDetections+=1
if %mst% GEQ 1 set/a TotalDetections+=1
if %ASR% geq 1 set/a TotalDetections+=1
if %Cas% GEQ 1 set/a TotalDetections+=1
if %arup% GEQ 1 set/a TotalDetections+=1
if %Skymm% GEQ 1 set/a TotalDetections+=1
if %ejtlzm% GEQ 1 set/a TotalDetections+=1
if %PacketAPP% GEQ 1 set/a TotalDetections+=1
if %Liner% GEQ 1 set/a TotalDetections+=1
if %OKTOOLBAR% GEQ 1 set/a TotalDetections+=1
if %ADU% GEQ 1 set/a TotalDetections+=1
if %Win32Mes% GEQ 1 set/a TotalDetections+=1
if %Winlogon% GEQ 1 set/a TotalDetections+=1
if %shginas% GEQ 1 set/a TotalDetections+=1
if %outerinfo% GEQ 1 set/a TotalDetections+=1
if %EliteCodec% GEQ 1 set/a TotalDetections+=1
if %Zlob% GEQ 1 set/a TotalDetections+=1
if %ExtensionAmoun% GEQ 1 set/a TotalDetections+=1
if %ExtensionAmount% GEQ 1 set/a TotalDetections+=1
if %FileCorruptCore% GEQ 1 set/a TotalDetections+=1
if %onenet% GEQ 1 set/a TotalDetections+=1
if %PUA% GEQ 1 set/a TotalDetections+=1
echo.
echo ExtensionSetAfter
set/a Infected=0
echo.
if %TotalDetections% GEQ 1 set/a Infected+=1
if %MaliciousProcess% GEQ 1 set/a Infected+=1
goto RESULTS-SCN
:RESULTS-SCN
cls
echo.
echo Fast Scan Results - [%TIME%]
echo.
echo ---------RESULTS------------
echo.
if %TotalDetections% GEQ 1 echo Oh no, %TotalDetections% Malicious Files found!
if %TotalDetections% EQU 0 echo Great, No Malware Found!
if %MaliciousProcess% GEQ 1 echo %MaliciousProcess% Malicious process have been found!
echo.
if %Infected% GEQ 1 echo -----Malware Info------
echo.
if %Tencent.QQ% GEQ 1 echo Win32\Tencent.QQ.Adware Found!
if %Spy.Barby% GEQ 1 echo Win32\Barby.Backdoor Found!
if %AdClicker% GEQ 1 echo Win32\Trojan.Adclicker.Spyware
if %AST% GEQ 1 echo Win32\Spyware.Ast.Backdoor
if %sysguard% GEQ 1 echo Win32.sysguard\Ransomeware
if %GlobalUpdate% GEQ 1 echo Win32\Adware.GlobalUpdate
if %ZeroDay% GEQ 1 echo Win32\ZeroDay.Generic
if %ToolBarDetect% GEQ 1 echo Win32\ToolBar.Installer
if %Tuto% GEQ 1 echo Win32\Tuto4PC.Generic.Backdoor
if %AfCore% GEQ 1 echo Backdoor\AfCore.an
if %AnalVirus% GEQ 1 echo Backdoor\analftp.Generic
if %AdultLinks% GEQ 1 echo Win32\Trojan.AdultLinks
if %tmpMal% GEQ 1 echo Win32\not-a-virus.gen
if %ScrnSaver% GEQ 1 echo Adware:Win32/Dq.A
if %VidSaver% GEQ 1 echo Adware:Win32/Generic
if %giantsav% GEQ 1 echo Adware:Win32/GiantSavings
if %IWant% GEQ 1 echo Adware:Win32/IWantThis.exe
if %dfr% GEQ 1 echo Riskware:Win32\TMP.EXE
if %flashinstaller% GEQ 1 echo Trojan.Dropper\Flash_Installer
if %Trojan.PWS% GEQ 1 echo Trojan-GameThief.Win32
if %svchost.exe% GEQ 1 echo Win32\BackdoorExploit-gen
if %Win32.Agent% GEQ 1 echo Win32.Agent\Rootkit.QQHelp
if %FrameWork% GEQ 1 echo Win32\Rootkit-gen
if %Msq% GEQ 1 echo Rookit:Win32-gen
if %BitMiner% GEQ 1 echo Miner.Virtool\Win32
if %ObFus% GEQ 1 echo Virtool:Obfuscator-gen
if %DelInject% GEQ 1 echo Virtool:DLLInjector\Win32
if %AgentRW% GEQ 1 echo Backdoor.AgentRW
if %AgentAG% GEQ 1 echo Backdoor.AgentAG
if %AgentGF% GEQ 1 echo Backdoor.AgentGF
if %AgentAC% GEQ 1 echo TrojanClicker:Win32/Agent
if %AgentAQ% GEQ 1 echo Win32_Agent_AQ_trojan
if %AFXRootkit% GEQ 1 echo Backdoor:AFXRootkit\Win32
if %Agotbot% GEQ 1 echo Backdoor:Agotbot\Win32
if %AOT% GEQ 1 echo Win32/Delf.CY trojan
if %mst% GEQ 1 echo Win32/Riskware.gen
if %ASR% GEQ 1 echo Win32/Assault.10!Trojan
if %Cas% GEQ 1 echo Win32\Riskware.downloader
if %arup% GEQ 1 echo Adware:Downloader.Spyware
if %Skymm% GEQ 1 echo AdWare.Win32.AdMoke.bc
if %ejtlzm% GEQ 1 echo TrojanDropper.Win32\DDOSER
if %PacketAPP% GEQ 1 echo Trojan:Adware.DllInjector
if %Liner% GEQ 1 echo Trojan-PSW.Win32
if %OKTOOLBAR% GEQ 1 echo Win32\Malware.generic
if %ADU% GEQ 1 echo Malware:Trojan.Riskware
if %Win32Mes% GEQ 1 echo Malware:Win32Messenger-gen
if %Winlogon% GEQ 1 echo Adware:Win32/Clickspring.C
if %shginas% GEQ 1 echo Adware:Win32/shginas
if %outerinfo% GEQ 1 echo Adware:Win32/outerinfo
if %EliteCodec% GEQ 1 echo Adware:Win32/EliteCodec-gen 
if %Zlob% GEQ 1 echo Downloader:Win32/Zlob
if %ExtensionAmoun% GEQ 1 echo MaliciousExtension[Chrome]
if %ExtensionAmount% GEQ 1 echo MaliciousExtension[Opera GX]
if %FileCorruptCore% GEQ 1 echo Trojan:FileXCorrupter
if %onenet% GEQ 1 echo PUA:01NetCom\Win32
if %PUA% GEQ 1 echo PUA:Adware\Win32
echo.
if %Infected% GEQ 1 echo Actions:
if %TotalDetections% GEQ 1 echo Malware Deleted!
if %MaliciousProcess% GEQ 1 echo Malicious Process Killed!
if %GlobalProcess% GEQ 1 echo Win32\Adware.GlobalUpdate | Action = TASKKILLED
echo.
echo.
echo.
pause> nul
goto VIRUSINTEL

:INFO
cls
echo.
echo Info Panel 1.0.2
echo.
ECHO 1 - Update History
ECHO 2 - Pc Information
ECHO 3 - Account info
ECHO 4 - Update Information
echo 5 - Go Back
echo.
SET /P OPT=Put in action here:
if %OPT%==1 GOTO UPDATEINFO
if %OPT%==2 GOTO PC-INFO
if %OPT%==3 GOTO ACCOUNTINFO
if %OPT%==4 GOTO UPDATE-INFORMATION
if %opt%==5 goto officalstart

:UPDATE-INFORMATION
set/a EnableExpirimental=0
CD %UserProfile%\AppData\Roaming\VRT
findstr "EnableExpirimental=1" VRT_Properties.txt>NUL
IF ERRORLEVEL 1 (set/a EnableExpirimental=0) ELSE (set/a EnableExpirimental=1)
cls
if %EnableExpirimental%==0 goto UPDATE-INFORMATION-DIS
echo.
if %CRITICAL%==%NORMAL% echo No Update Available!
if %CRITICAL%==1 echo New version available!
if %CRITICAL%==1 echo Version: %GetVer%
if %CRITICAL%==1 echo Status=NOT INSTALLED
if %CRITICAL%==1 echo Update Importance=CRITICAL
if %NORMAL%==1 echo New version available!
if %NORMAL%==1 echo Version: %GetVer%
if %NORMAL%==1 echo Status=NOT INSTALLED
if %NORMAL%==1 echo Update Importance=NORMAL (not essential)
if %NORMAL%==1 echo =====================================================================
if %NORMAL%==1 echo It is recommend you still download it to avoid compatibility Issues!
if %NORMAL%==1 echo =====================================================================
echo.
echo.
pause> nul
GOTO INFO

:UPDATE-INFORMARTION-DIS
cls
echo.
echo Please enable "expirimental" in options for this feature!
echo.
pause> nul
goto INFO

:PC-INFO
cls
echo.
echo Pc Information
echo.
ECHO 1 - Driver Info
ECHO 2 - Find Open Ports
ECHO 3 - General Pc Info
ECHO 4 - Display IP
echo.
ECHO 5 - Go Back
echo.

set /p opt=Please select an action:
if %opt% equ 1 goto DRIVER
if %opt% equ 2 goto OPEN-PORT
if %opt% equ 3 goto GENERAL-PC
if %opt% equ 4 goto DISPLAY-IP
if %opt% equ 5 goto INFO

:DRIVER
cls
echo.
DRIVERQUERY
echo.
pause> nul
GOTO PC-INFO

:OPEN-PORT
cls
echo.
netstat
echo.
pause> nul
GOTO PC-INFO

:DISPLAY-IP
cls
echo.
set ip_address_string="IPv4 Address"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do echo Your IP Address is: %%f
echo.
pause> nul
GOTO PC-INFO

:ACCOUNTINFO
cd %userprofile%\appdata\local\VirusRemovalTool
cls
echo.
echo.
echo Logged in as= && type Username.txt
echo.
echo.
pause> nul
GOTO INFO

:GENERAL-PC
if %os%==Windows_NT goto WINNT
goto NOCON

:WINNT
cls
echo .Using a Windows NT based system
echo ..%computername%

set system=
set manufacturer=
set model=
set serialnumber=
set osname=
set sp=
setlocal ENABLEDELAYEDEXPANSION
set "volume=C:"
set totalMem=
set availableMem=
set usedMem=

echo Getting data [Computer: %computername%]...
echo Please Wait....

REM Get Computer 

FOR /F "tokens=2 delims='='" %%A in ('wmic OS Get csname /value') do SET system=%%A

REM Get Computer Manufacturer
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Manufacturer /value') do SET manufacturer=%%A

REM Get Computer Model
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Model /value') do SET model=%%A

REM Get Computer Serial Number
FOR /F "tokens=2 delims='='" %%A in ('wmic Bios Get SerialNumber /value') do SET serialnumber=%%A

REM Get Computer OS
FOR /F "tokens=2 delims='='" %%A in ('wmic os get Name /value') do SET osname=%%A
FOR /F "tokens=1 delims='|'" %%A in ("%osname%") do SET osname=%%A

REM Get Computer OS SP
FOR /F "tokens=2 delims='='" %%A in ('wmic os get ServicePackMajorVersion /value') do SET sp=%%A

REM Get Memory
FOR /F "tokens=4" %%a in ('systeminfo ^| findstr Physical') do if defined totalMem (set availableMem=%%a) else (set totalMem=%%a)
set totalMem=%totalMem:,=%
set availableMem=%availableMem:,=%
set /a usedMem=totalMem-availableMem

FOR /f "tokens=1*delims=:" %%i IN ('fsutil volume diskfree %volume%') DO (
    SET "diskfree=!disktotal!"
    SET "disktotal=!diskavail!"
    SET "diskavail=%%j"
)
FOR /f "tokens=1,2" %%i IN ("%disktotal% %diskavail%") DO SET "disktotal=%%i"& SET "diskavail=%%j"

echo Loading Completed!

echo --------------------------------------------
echo System Name: %system%
echo Manufacturer: %manufacturer%
echo Model: %model%
echo Serial Number: %serialnumber%
echo Operating System: %osname%
echo C:\ Total: %disktotal:~0,-9% GB
echo C:\ Avail: %diskavail:~0,-9% GB
echo Total Memory: %totalMem%
echo Used  Memory: %usedMem%
echo Computer Processor: %processor_architecture%
echo Service Pack: %sp%
echo --------------------------------------------

REM Generate file
SET file="%~dp0%computername%.txt"
echo -------------------------------------------- >> %file%
echo Details For: %system% >> %file%
echo Manufacturer: %manufacturer% >> %file%
echo Model: %model% >> %file%
echo Serial Number: %serialnumber% >> %file%
echo Operating System: %osname% >> %file%
echo C:\ Total: %disktotal:~0,-9% GB >> %file%
echo C:\ Avail: %diskavail:~0,-9% GB >> %file%
echo Total Memory: %totalMem% >> %file%
echo Used  Memory: %usedMem% >> %file%
echo Computer Processor: %processor_architecture% >> %file%
echo Service Pack: %sp% >> %file%
echo -------------------------------------------- >> %file%

echo.
pause> nul
GOTO PC-INFO

goto END

:NOCON
echo Error...Invalid Operating System
echo.
pause> nul
GOTO PC-INFO

:SERVERINFO
cls
echo.
echo =============
echo SERVER INFO
echo =============
echo.
echo.
set ip_address_string="IPv4 Address"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do echo Your IP Address is: %%f
echo.
echo Server host status: N/A
echo.
echo.
pause> nul

GOTO INFO

:UPDATEINFO
cls
color 2
echo.
echo %date%
echo.
echo INFO
echo -------------------
echo.
echo First update on release day [1/25/2021] [1.0.1]
echo Personal Antivirus and optimizer!
echo.
echo Second update on [1/26/2021] [1.0.2]
echo.
echo Third update on [1/26/2021] [1.0.3]
echo.
echo Fourth update on [1/26/2021] [1.0.4] [removed loading screen]
echo.
echo Made a new update [1/27/2021] [1.0.5] [made a system scanner]
echo.
echo Hughly cleaned up not working code! from 8kb to 4kb! [1.0.6]
echo.
echo New Update General improvements [1.0.7] [UI Enhancement] [2/5/2021]
echo.
echo Added protection against my own virusses [1.0.8 Beta] [2/5/2021]
echo.
echo.
echo PAGE 1 OF 3
echo.
echo Click enter to go to the next page
echo.
echo.
pause> nul
GOTO INFO2

:INFO2
cls
color 2
echo.
echo %date%
echo.
echo INFO
echo -------------------
echo.
echo I concluded that the previous expirimental code does NOT work and i added a second page to the info section [1.0.8] [2/5/2021]
echo.
echo I cleaned up old code [1.0.8] [Bug fixes]
echo.
echo I made a Dev panel (Beta) and i improvent some messages from old code [1.0.8] [2/5/2021]
echo.
echo I finialised the protection against my own virusess [1.0.8] [2/5/2021]
echo.
echo I completely rewrote the BatchFileChecker script because it was not working correctly [1.0.9] [4/21/2021]
echo.
echo I added name and more info such as Server info and account info and improvent messages [1.0.9] [4/21/2021]
echo.
echo I added a security protocol for the "dev panel" still beta version [1.0.9] [4/22/2021]
echo.
echo I completely rewrote all counter virus scripts and made a new "virus intelligence" option [1.1.0] [4/23/2021]
echo.
echo PAGE 2 OF 3
echo.
echo Click enter to go to the next page
echo.
echo.
pause> nul
GOTO INFO3

:INFO3
cls
color 2
echo.
echo %date%
echo.
echo INFO
echo -------------------
echo.
echo I added a Log Options with VRT_Data Scanners and I added custom maxfilesize option [1.1.0] [4/24/2021]
echo.
echo I added much more virus intelligence options including Deep Virus Scan and custom Virus Scan [1.1.0] [4/24/2021]
echo.
echo I added a Optimizer menu with orginizer options and my personal optimizer [1.1.0] [4/24/2021]
echo.
echo I added lots of small fixes and improvements [1.1.0] [5/11/2021]
echo.
echo I completely renewed the "Batch file checker" script [1.1.0] [5/11/2021]
echo.
echo With a lot of stability and grammar errors we finnally upgrade to 1.1.1 [1.1.1] [5/11/2021]
echo.
echo I completely renewed the Update and i am in the progress to add a /roaming folder
echo.
echo.
echo.
pause> nul
goto IVNO:

:Exit
cls
echo.
echo If you do not exit via here some cache files may be left behind slowing you system down!
echo.
echo.
set /P c=Do you want to Exit safely[Y/N]?
if /I "%c%" EQU "Y" goto :HiddenExit
if /I "%c%" EQU "N" goto :officalstart

:HiddenExit
CD %Userprofile%\AppData\Roaming\VRT
cls
echo.
echo.
XCOPY VRT_Data.txt %Userprofile%\AppData\Roaming\VRT\Backups\VRT-Backup.txt /Q
echo.
exit
rem goodbye!

:dev
set counter=5
GOTO DevLogin

:DevLogin
cls
color 2
title Dev panel
echo.
if %counter%==0 goto :LOCKOUT
if %counter% lss 5 echo [%counter% attempts left]
echo.
echo DEV PANEL LOGIN SYSTEM
echo.
SET /P INPUT=Put in password here:
if %INPUT%==adminbypass GOTO ACCESSALLOW
if %INPUT%==else GOTO WRONGPASS

:WRONGPASS
cls
color c
echo.
set /a counter-=1
echo.
echo Wrong Password!
echo.
echo You have [%counter% attemps left]
echo.
pause> nul
GOTO DevLogin

:LOCKOUT
cd %UserProfile%\AppData\Roaming\VRT
cls
color c
echo.
echo Level 2 Security Breach!
echo.
echo.
echo ACCESSDENIED [%date%] >> VRT_Data.txt
cd %UserProfile%\AppData\Local\VirusRemovalTool
echo.
echo ACCESSDENIED >> VirusRemovalTool_CONFIG.txt
echo LEVEL 2 SECURITY BREACH [%date%] >> VRT_Data.txt
GOTO SYSLOCK

:SYSLOCK
cd %UserProfile%\AppData\Roaming\VRT
cls
echo.
echo System Lockdown In progress
echo.
echo ACCESSDENIED >> VRT_Data.TXT
echo.
pause> nul

:ACCESSALLOW
GOTO MAIN-DEV

:MAIN-DEV
cd %UserProfile%\AppData\Local\VirusRemovalTool
cls 
color 2
echo.
echo [Developer Menu]

echo Dev 1.0.1
echo.
echo.
ECHO 1 - ((CONFIG TEST))
ECHO 2 - File Maker
ECHO 3 - FTP Test
echo.
ECHO 4 - Return

SET /P OPT=Please enter a number:
if %opt% equ 1 GOTO CONFIG_TEST
if %opt% equ 2 GOTO File_Maker
if %opt% equ 3 GOTO FTP_TEST
if %opt% equ 4 GOTO officalstart

:FTP_TEST
echo.
echo 
OPEN https://c1f7-37-19-205-203.ngrok-free.app
user
password
pause>nul
exit


:File_Maker
cd %UserProfile%\desktop
cls
color 2
title FileMaker
echo.
echo Select Program Type
echo.
ECHO 1 - Folder
ECHO 2 - Files
echo.
set/p opt=Put Program Type Here:
if %OPT%==1 GOTO FOLDER
if %OPT%==2 GOTO FILE

:FOLDER
cls
echo.
set/p input=Put folder name here:
GOTO MAKE_FOLDER

:MAKE_FOLDER
md %input%
GOTO MAIN-DEV

:FILE
cls
echo.
set/p input=Put file name here:
GOTO MAKE_FILE

:MAKE_FILE
echo. >> %input%
GOTO MAIN-DEV

:CONFIG_TEST
cls
echo.
echo VirusRemovalTool Configuration tests
echo.
ECHO 1 - Dummy Files Temp
ECHO 2 - Corrupt Files 
ECHO 3 - Update [Overwrite Test]
ECHO 4 - Detection Files
echo.
ECHO 5 - Go Back

set /p opt=Please select an action
if %OPT% equ 1 GOTO DEV-FILES
if %OPT% equ 2 GOTO DEV-CORRUPT
if %OPT% equ 3 GOTO DESKTOP-UPDATE2
if %OPT% equ 4 GOTO DEV-DETECTION-FILES
if %OPT% equ 5 GOTO MAIN-DEV

:DEV-FILES
cls
cd %Userprofile%\AppData\Roaming\VRT\Temp
echo.
echo Dummy File1 >> DummyFile%RANDOM%.TXT
echo Dummy File2 >> DummyFile%RANDOM%.TXT
echo Dummy File3 >> DummyFile%RANDOM%.TXT
echo Dummy File4 >> DummyFile%RANDOM%.TXT
echo.
GOTO CONFIG_TEST

:DEV-CORRUPT
cd %UserProfile%\AppData\Roaming\VRT
echo.
rd Quarantine
DEL VRT_Data.txt
DEL VRT_Properties.txt
ECHO %RANDOM%[_]%RANDOM%] >> %RANDOM%_CORRUPT.TXT
RD Temp
echo.
cd %UserProfile%\AppData\Local\VirusRemovalTool
echo.
DEL Username.txt
GOTO CONFIG_TEST

rem ProtectCode14