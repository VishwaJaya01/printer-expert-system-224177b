@echo off
setlocal
cd /d "%~dp0"
if defined SWIPL if exist "%SWIPL%" goto found
set "SWIPL="
for /f "delims=" %%P in ('where swipl.exe 2^>nul') do if not defined SWIPL set "SWIPL=%%P"
if defined SWIPL goto found
if exist "%ProgramFiles%\swipl\bin\swipl.exe" set "SWIPL=%ProgramFiles%\swipl\bin\swipl.exe"
if defined SWIPL goto found
if exist "%LOCALAPPDATA%\Programs\swipl\bin\swipl.exe" set "SWIPL=%LOCALAPPDATA%\Programs\swipl\bin\swipl.exe"
if defined SWIPL goto found
echo SWI-Prolog was not found. Install it from https://www.swi-prolog.org/download/stable
echo Or set SWIPL to the full path of swipl.exe as described in README.md.
pause
exit /b 1
:found
if /i "%~1"=="test" goto tests
if /i "%~1"=="demo" goto demo
if not "%~1"=="" goto usage
"%SWIPL%" -q -s src/main.pl
exit /b %errorlevel%
:tests
"%SWIPL%" -q -s tests/test_engine.pl
exit /b %errorlevel%
:demo
"%SWIPL%" -q -s src/main.pl -- --demo
exit /b %errorlevel%
:usage
echo Usage: run.cmd [demo^|test]
exit /b 2
