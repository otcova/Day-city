cd "%~dp0"

git restore .
if %errorlevel% neq 0 exit /b %errorlevel%

git pull
if %errorlevel% neq 0 exit /b %errorlevel%

set /p HOST_NAME=<"./current-host.txt"
if %errorlevel% neq 0 exit /b %errorlevel%

IF "%HOST_NAME%" == "none" (
    echo Anyone is hosting
    goto choice
) ELSE (
    echo "%HOST_NAME% is hosting"
    pause
    goto finish
)

:choice
set /P c=Want to host[y/n]? 
if /I "%c%" EQU "y" goto :host_server
if /I "%c%" EQU "n" goto finish
goto :choice
:host_server

set /p THIS_HOST_NAME=<"./this-host-name.txt"
echo %THIS_HOST_NAME%>="./current-host.txt"

git add .
git commit -a -m "-"
:name_push
git push
if %errorlevel% neq 0 goto name_push


echo " --- START SERVER --- "

cd "./Server"
java -Xms2G -Xmx2G -jar "./paper-1.16.4-325.jar"
cd "../"

echo none>="current-host.txt"

git add .
git commit -a -m "+"
:last_push
git push
if %errorlevel% neq 0 goto last_push

:finish