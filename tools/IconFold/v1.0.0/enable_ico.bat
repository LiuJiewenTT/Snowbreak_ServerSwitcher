@if "%1" == "/?" (
	@echo This program is used to enable an ico to some specific directory and the subdirectories.
	@echo Pass path as the first parameter and options in the followings.
	@echo The second parameter should be option of /S, meaning also applies to subdirectories. Default is no.
	@echo The third parameter should be option of /AICO, meaning affecting all icons.

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
if /I "%2" == "/S" ( echo Enable with Search? [Yes] ) else ( echo Enable with Search? [No] )

set ls=dir /b /A
set lss=dir /b /S /A:D

if /I "%2" == "/S" (
	attrib "%~1" +R
	attrib "%~1"
	call:main "%1\desktop.ini"
	for /f "usebackq delims=" %%i in (`%lss% "%1"`) do (
		@REM echo %%i
		attrib "%%i" +R
		attrib "%%i"
		for /f "usebackq delims=" %%j in (`%ls% "%%i" ^| findstr "^desktop.ini$"`) do (
			@REM echo %%i\%%j
			call:main "%%i\%%j"
		)
		if "%3" == "/AICO" (
			for /f "usebackq delims=" %%j in (`%ls% "%%i" ^| findstr ".ico$"`) do (
				call:main "%%i\%%j"
			)
		)
	)
) else (
	attrib "%1" +R
	attrib "%1"
	for /f "usebackq delims=" %%i in (`%ls% "%1" ^| findstr "^desktop.ini$"`) do (
		call:main "%1\%%i"
	)
	if "%3" == "/AICO" (
		for /f "usebackq delims=" %%j in (`%ls% "%%i" ^| findstr ".ico$"`) do (
			call:main "%%i\%%j"
		)
	)
)

@echo on
@goto:eof

:main
	if not exist "%~1" (
			goto:eof
	)

	@REM echo %~1
	attrib "%~1" +S +H +R
	attrib "%~1"
goto:eof

