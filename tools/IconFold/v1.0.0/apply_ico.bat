@if "%1" == "/?" (
	@echo This program is used to apply an ico to some specific directory and the subdirectories.
	@echo Pass path as the first parameter and options in the followings.
	@echo The second parameter should be option of /S, meaning also applies to subdirectories. Default is no.

	@echo Before running this script, make sure the source is ready. If not, run "extract_command.bat" first.

	@echo Author: LiuJiewenTT [on Github.com]	
	@echo License: MIT.

	@echo Have fun!
	@goto:eof
)

@echo off

set tmpv=%1
if "%tmpv:~-1%" == "\" (
	echo "Directory name should not be ended with '\' (not supported), please correct."
	goto:eof
)

echo Target: %~f1
if /I "%2" == "/S" ( echo Apply with Search? [Yes] ) else ( echo Apply with Search? [No] )

set ls=dir /b /A:D
set lss=dir /b /S /A:D

if /I "%2" == "/S" (
	call:main "%1"
	for /f "usebackq delims=" %%i in (`%lss% "%1"`) do (
		call:main "%%i"
	)
) else (
	call:main "%1"
	@REM for /f "usebackq delims=" %%i in (`%ls% "%1"`) do (
	@REM 	call:main "%%i"
	@REM )
)

@echo on
@goto:eof

:main
	echo [%~f1]
	xcopy /H "%~dp0res_ico\*" "%~1" /Y /Q /R
	for /f "usebackq delims=" %%i in (`dir /b "%~dp0res_ico\" /A:H`) do (
		@REM echo %%i
		attrib "%~1\%%i" +R +S +H
		attrib "%~1\%%i"
	)
	attrib "%~1" +R
goto:eof

