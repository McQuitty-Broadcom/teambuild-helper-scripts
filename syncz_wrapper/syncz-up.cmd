@echo off
setlocal

if "%SYNCZ_CONFIG_NAME%"=="" (
  set "CONFIG_NAME=syncz.yml"
) else (
  set "CONFIG_NAME=%SYNCZ_CONFIG_NAME%"
)

set "DIR=%CD%"

:search
if exist "%DIR%\%CONFIG_NAME%" (
  pushd "%DIR%" >nul
  syncz %*
  set "SYNCZ_EXIT=%ERRORLEVEL%"
  popd >nul
  exit /b %SYNCZ_EXIT%
)

for %%I in ("%DIR%\..") do set "PARENT=%%~fI"
if /I "%PARENT%"=="%DIR%" goto not_found
set "DIR=%PARENT%"
goto search

:not_found
echo syncz wrapper: %CONFIG_NAME% not found in current directory or any parent directory 1>&2
exit /b 1
