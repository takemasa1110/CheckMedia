@echo off

set CmdName=CertUtil
set HashMethod=MD5
set MasterFile=CheckMediaMaster.txt
set ResultTempFile=%TEMP%\CheckMediaResultTemp.txt
set ResultFile=%TEMP%\CheckMediaResult.txt
set CurrentPath=%~dp0
set WPSettingsFile=System Volume Information\WPSettings.dat
set IndexerVolumeGuidFile=System Volume Information\IndexerVolumeGuid

pushd %CurrentPath%

if exist %ResultTempFile% del %ResultTempFile%
if exist %ResultFile% del %ResultFile%
for /R .\ %%f in (*.*) do call :PrintFileHash "%%~f"
sort /+34 < %ResultTempFile% > %ResultFile%
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

set Hash=%Hash: =%
setlocal EnableDelayedExpansion
set PathToConvert=%~f1
set FilePath=!PathToConvert:*%CurrentPath%=!
if "%FilePath%" == "%MasterFile%" exit /b 0
if "%FilePath%" == "%WPSettingsFile%" exit /b 0
if "%FilePath%" == "%IndexerVolumeGuidFile%" exit /b 0
echo %Hash% %FilePath%
echo %Hash% %FilePath% >> %ResultTempFile%
exit /b 0
