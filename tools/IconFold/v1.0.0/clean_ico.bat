@if "%1" == "/?" (
	@echo This program is used to clean an ico to some specific directory and the subdirectories.
	@echo Pass path as the first parameter and options in the followings.
	@echo The second parameter should be option of /S, meaning also applies to subdirectories. Default is no.
	@echo The third parameter should be option of /AICO, meaning affecting all icons.

	@echo Author: LiuJiewenTT [on Github.com]	
	@echo License: MIT.

	@echo Have fun!
	@goto:eof
)

@echo off

setlocal enabledelayedexpansion

set tmpv=%1
if "%tmpv:~-1%" == "\" (
	echo "Directory name should not be ended with '\' (not supported), please correct."
	goto:eof
)

echo Target: %~f1
if /I "%2" == "/S" ( echo Clean with Search? [Yes] ) else ( echo Clean with Search? [No] )

set ls=dir /b /A:D
set lss=dir /b /S /A:D

set AICO=%3

if /I "%2" == "/S" (
	call:main "%1"
	@REM echo --
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
	attrib "%~1" -R
	attrib "%~1"
	
	if "%AICO%" == "/AICO" (
		@REM echo %~1
		if exist "%~1\*.ico" (
			call:isHide "%~1\*.ico"
			if /I "!isHide_retv!" EQU "0" (
				del /F "%~1\*.ico"
				if exist "%~1\*.ico" del /F "%~1\*.ico" /A:H
			) else (
				del /F "%~1\*.ico" /A:H
				if exist "%~1\*.ico" del /F "%~1\*.ico"
			)
		)
	) else (
		if not exist "%~1\desktop.ini" (
			goto:eof
		)

		@REM echo %~1

		set IconFile=NUL
		for /f "usebackq eol=[ tokens=1,* delims==" %%i in ("%~1\desktop.ini") do (
			@REM echo [%%i][%%j]
			if "%%i" == "IconFile" (
				if "%%j" NEQ "" (
					set "IconFile=%%j"
					@REM break
				)
			)
		)
		echo IconFile=!IconFile!

		@REM del /F /Q "%~1\.ico"
		if "!IconFile!" NEQ "NUL" (
			if exist "%~1\!IconFile!" (
				call:isHide "%~1\!IconFile!"
				if /I "!isHide_retv!" EQU "0" (
					del /F "%~1\!IconFile!"
				) else (
					del /F "%~1\!IconFile!" /A:H
				)
			)
		)
	)

	if exist "%~1\desktop.ini" (
		call:isHide "%~1\desktop.ini"
		if /I "!isHide_retv!" EQU "0" (
			del /F "%~1\desktop.ini"
		) else (
			del /F "%~1\desktop.ini" /A:H
		)
	)
	
goto:eof


:isHide
	@REM set a=abcde
	for /f "usebackq tokens=1,* delims=:" %%i in (`attrib "%~1"`) do ( 
		set a=%%i
	)
	set a=%a:~0,-1% 
	@REM echo %a%
	for /f "usebackq delims=" %%i in (`echo %a% ^| find /c "H"`) do ( 
		set b=%%i
	)
	@REM echo %b%
	set isHide_retv=%b%
goto:eof