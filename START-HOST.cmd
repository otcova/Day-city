@echo off
cd "%~dp0"

rem ---------------

if exist "./data/bad-host-close.txt" (
    goto exist_close
) else (
    goto good_close
)

:exist_close
set /p BAD_HOST=<"./data/bad-host-close.txt"
if "%BAD_HOST%" neq "open" (
    goto good_close
)
:bad_close
echo Last sesion you don't closed well the host.
set /p HOST_NAME=<"./data/current-host.txt"
IF "%HOST_NAME%" == "none" (
    git add .
    git commit -a -m "++"
    set x=(git pull)
)
pause
goto final

:good_close
echo open>"./data/bad-host-close.txt"

rem ------------------

git restore .
if %errorlevel% neq 0 goto final

set x=(git pull)
if %errorlevel% neq 0 goto final

set /p HOST_NAME=<"./data/current-host.txt"
if %errorlevel% neq 0 goto final

IF "%HOST_NAME%" == "none" (
    echo Anyone is hosting
    goto choice
) ELSE (
    echo "%HOST_NAME% is hosting"
    pause
    goto final
)

:choice
set /P c=Want to host[y/n]? 
if /I "%c%" EQU "y" goto :host_server
if /I "%c%" EQU "n" goto final
goto :choice
:host_server

set /p THIS_HOST_NAME=<"./data/this-host-name.txt"
echo %THIS_HOST_NAME%>="./data/current-host.txt"

git add .
git commit -a -m "-"
:name_push
git push
if %errorlevel% neq 0 goto name_push


echo " --- START SERVER --- "
cd "%~dp0/Server"
java -Xms2G -Xmx2G -jar "./paper-1.16.4-325.jar" nogui

cd "%~dp0/data"
echo none>="current-host.txt"

cd "%~dp0"
git add .
git commit -a -m "+"
:last_push
git push
if %errorlevel% neq 0 goto last_push

:final
echo closed>"./data/bad-host-close.txt"