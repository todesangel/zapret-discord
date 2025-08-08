@echo off
setlocal EnableDelayedExpansion
set "LOCAL_VERSION=1.7.2b"

:: Внешние команды
if "%~1"=="status_zapret" (
    call :test_service zapret soft
    exit /b
)

if "%~1"=="check_updates" (
    call :service_check_updates soft
    exit /b
)

if "%1"=="admin" (
    echo Started with admin rights
) else (
    echo Requesting admin rights...
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

:: МЕНЮ ================================
:menu
cls
set "menu_choice=null"
echo =======================
echo 1. Install Service
echo 2. Remove Services
echo 3. Check Service Status
echo 4. Run Diagnostics
echo 5. Check Updates
echo 0. Exit
set /p menu_choice=Enter choice (0-5): 

if "%menu_choice%"=="1" goto service_install
if "%menu_choice%"=="2" goto service_remove
if "%menu_choice%"=="3" goto service_status
if "%menu_choice%"=="4" goto service_diagnostics
if "%menu_choice%"=="5" goto service_check_updates
if "%menu_choice%"=="0" exit /b
goto menu

:: (Остальные функции не меняем...)

:: АВТООБНОВЛЕНИЕ =======================
:service_check_updates
chcp 65001 > nul

:: Set current version and URLs
set "GITHUB_VERSION_URL=https://raw.githubusercontent.com/Flowseal/zapret-discord-youtube/main/.service/version.txt"
set "GITHUB_DOWNLOAD_URL=https://github.com/Flowseal/zapret-discord-youtube/releases/latest/download/zapret-discord-youtube-"

:: Получить последнюю версию с GitHub
for /f "delims=" %%A in ('powershell -Command "(Invoke-WebRequest -Uri \"%GITHUB_VERSION_URL%\" -Headers @{\"Cache-Control\"=\"no-cache\"} -TimeoutSec 5).Content.Trim()" 2^>nul') do set "GITHUB_VERSION=%%A"

if not defined GITHUB_VERSION (
    echo [ОШИБКА] Не удалось получить последнюю версию. Проверьте интернет.
    pause
    if "%1"=="soft" exit /b 
    goto menu
)

echo Локальная версия: %LOCAL_VERSION%
echo Доступна версия: %GITHUB_VERSION%

if "%LOCAL_VERSION%"=="%GITHUB_VERSION%" (
    echo У вас установлена последняя версия.
    pause
    if "%1"=="soft" exit /b 
    goto menu
)

echo Найдена новая версия: %GITHUB_VERSION%
set "CHOICE="
set /p "CHOICE=Скачать и установить новую версию? (Y/N) (default: Y): "
if "!CHOICE!"=="" set "CHOICE=Y"
if "!CHOICE!"=="y" set "CHOICE=Y"
if /i "!CHOICE!" NEQ "Y" (
    if "%1"=="soft" exit /b 
    goto menu
)

set "ARCHIVE=%TEMP%\zapret-discord-youtube-%GITHUB_VERSION%.rar"
powershell -Command "Invoke-WebRequest -Uri '%GITHUB_DOWNLOAD_URL%%GITHUB_VERSION%.rar' -OutFile '%ARCHIVE%'"

if not exist "%ARCHIVE%" (
    echo [ОШИБКА] Не удалось скачать архив.
    pause
    if "%1"=="soft" exit /b 
    goto menu
)

echo Архив скачан: %ARCHIVE%
echo Распаковка (требуется WinRAR или 7zip)...

:: Попытка найти WinRAR
set "RAR=%ProgramFiles%\WinRAR\WinRAR.exe"
if exist "%RAR%" (
    "%RAR%" x -o+ "%ARCHIVE%" "%~dp0"
) else (
    echo [ОШИБКА] WinRAR не найден. Распакуйте архив вручную: %ARCHIVE%
    pause
    if "%1"=="soft" exit /b 
    goto menu
)

echo Обновление завершено! Перезапустите программу.
pause
if "%1"=="soft" exit /b 
goto menu

:: (Дальше идут ваши остальные метки:diagnostics, install, remove и т.д.)