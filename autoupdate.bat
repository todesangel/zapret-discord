@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Текущая локальная версия
set "LOCAL_VERSION=1.7.2b"

:: Ссылки на GitHub
set "GITHUB_VERSION_URL=https://raw.githubusercontent.com/Flowseal/zapret-discord-youtube/main/.service/version.txt"
set "GITHUB_DOWNLOAD_URL=https://github.com/Flowseal/zapret-discord-youtube/releases/latest/download/zapret-discord-youtube-"

:: Получить последнюю версию с GitHub
for /f "delims=" %%A in ('powershell -Command "(Invoke-WebRequest -Uri \"%GITHUB_VERSION_URL%\" -Headers @{\"Cache-Control\"=\"no-cache\"} -TimeoutSec 5).Content.Trim()" 2^>nul') do set "GITHUB_VERSION=%%A"

if not defined GITHUB_VERSION (
    echo [ОШИБКА] Не удалось получить последнюю версию. Проверьте интернет.
    pause
    exit /b
)

echo Локальная версия: %LOCAL_VERSION%
echo Доступна версия: %GITHUB_VERSION%

if "%LOCAL_VERSION%"=="%GITHUB_VERSION%" (
    echo У вас установлена последняя версия.
    pause
    exit /b
)

echo Найдена новая версия: %GITHUB_VERSION%

set /p "ANSWER=Скачать и установить новую версию? (Y/N) [Y]: "
if /i "%ANSWER%"=="N" exit /b

set "ARCHIVE=%TEMP%\zapret-discord-youtube-%GITHUB_VERSION%.rar"
powershell -Command "Invoke-WebRequest -Uri '%GITHUB_DOWNLOAD_URL%%GITHUB_VERSION%.rar' -OutFile '%ARCHIVE%'"

if not exist "%ARCHIVE%" (
    echo [ОШИБКА] Не удалось скачать архив.
    pause
    exit /b
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
    exit /b
)

echo Обновление завершено! Перезапустите программу.
pause
exit /b