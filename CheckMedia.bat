@echo off

set CmdName=CertUtil
set HashMethod=MD5
set MasterFile=CheckMediaMaster.txt
set ResultFile=%TEMP%\CheckMediaResult.txt
set CurrentPath=%~dp0

pushd %CurrentPath%

if exist %ResultFile% del %ResultFile%
for /R .\ %%f in (*.*) do call :PrintFileHash "%%~f"
echo %~nx0:
if exist %MasterFile% (
	fc %MasterFile% %ResultFile% >NUL && echo PASSED || echo FAILED
) else (
	echo %MasterFile% is not found
)

if "%1"=="" (
	pause
)
exit /b 0

:PrintFileHash
set Hash=
for /f "usebackq delims=" %%h in (`%CmdName% -hashfile "%~1" %HashMethod% ^| find /v "%HashMethod%" ^| find /v "%CmdName%:"`) do set Hash=%%h
if "%Hash%" == "" if "%~z1" == "0" (
	set Hash=d41d8cd98f00b204e9800998ecf8427e
) else (
	exit /b 0
)
if "%~nx1" == "%MasterFile%" exit /b 0
set Hash=%Hash: =%
setlocal EnableDelayedExpansion
set PathToConvert=%~f1
set FilePath=!PathToConvert:*%CurrentPath%=!
echo %Hash% %FilePath%
echo %Hash% %FilePath% >> %ResultFile%
exit /b 0
