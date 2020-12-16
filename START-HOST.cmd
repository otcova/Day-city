cd "%~dp0"

git restore .
if %errorlevel% neq 0 exit /b %errorlevel%

git pull
if %errorlevel% neq 0 exit /b %errorlevel%

set /p HOST_NAME=<"./scripts/current-host.txt"
if %errorlevel% neq 0 exit /b %errorlevel%

IF "%HOST_NAME%" == "none" (
    echo Anyone is hosting
    goto choice
) ELSE (
    echo "%HOST_NAME% is hosting"
    pause
    exit
)

:choice
set /P c=Want to host[y/n]? 
if /I "%c%" EQU "y" goto :host_server
if /I "%c%" EQU "n" exit
goto :choice
:host_server

set /p THIS_HOST_NAME=<"./scripts/this-host-name.txt"
echo %THIS_HOST_NAME%>="./scripts/current-host.txt"

git add .
git commit -a -m "-"
:name_push
git push
if %errorlevel% neq 0 goto name_push


echo " --- START SERVER --- "

cd "./scripts"
rem wscript.exe invis.vbs open-game-host.cmd
start open-game-host.cmd
exit