@echo off

:: Change directory to location of this batch file
cd %~dp0

:: Check elevation
net file 1>nul || goto get_elevation
goto init

:init
    if not -%1-==-- goto handle_options
    if not exist var echo 0 > var && echo Created var

:main
    :: Read variable into memory
    set /p toggle=<var
    set /p prev=<var

    :: Check toggle
    if %toggle% equ 0 echo 1 > var && goto switch_on
    :: else case
    if %errorlevel% equ 0 echo 0 > var && goto switch_off

    :: Error occured if this line is reached
    goto handle_error

:switch_on
    sc config vgc start= system|| goto handle_error
    echo Switched On
    goto end

:switch_off
    sc config vgc start= disabled || goto handle_error
    echo Switched Off
    goto end

:handle_options
    if %1 equ 1 goto switch_on
    if %1 equ on goto switch_on
    if %1 equ 0 goto switch_off
    if %1 equ off goto switch_off
    echo Invalid option
    goto main  

:get_elevation
    echo Requires elevation
    pause
    goto end

:handle_error
    echo Error level^: %errorlevel%
    echo %prev% > var && echo var set to^: %prev%
    pause

:end
