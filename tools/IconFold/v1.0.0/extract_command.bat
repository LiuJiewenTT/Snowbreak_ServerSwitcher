mkdir res_ico
@echo Pass the path of the folder that is going to be extracted from.
@echo You may want a clean res_ico directory. Do this yourself.
@if "%1" == "" @(
    echo No input. Exit.
    goto:eof
)

for /f "delims=" %%i in ('dir "%1" /A:A /b') do @( echo %%i & xcopy /H /R /K "%1\%%i" res_ico\ ) 
