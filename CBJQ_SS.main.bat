@echo off

@REM Set codepage to UTF-8(65001)
@for /F "tokens=2 delims=:" %%i in ('chcp') do @( set /A codepage=%%i ) 
@call :func_ensureACP

@REM ----------------------------------------------
@REM 用户变量设定区

@REM 以下三行请填入启动器路径(不加引号)。
@set launcher_worldwide=
@set launcher_bilibili=
@set launcher_kingsoft=

if not defined LANG (
    @REM 设置默认语言
    set LANG=zh
    @REM set LANG=en
)
set LANG

@REM ----------------------------------------------
@REM 初始化已完成，正式进入程序。

if /I "%LANG%" EQU "zh" (
    call :func_programinfo_zh_cn
) else (
    call :func_programinfo_en_us
)

@REM ----------------------------------------------
@REM 程序加载完成，开始工作。

if /I "%~1" == "worldwide" (
    if /I "%LANG%" == "zh" ( echo 启动国际服 ) else ( echo Start: worldwide )

) else if /I "%~1" == "bilibili" (
    if /I "%LANG%" == "zh" ( echo 启动B服 ) else ( echo Start: bilibili )

) else if /I "%~1" == "kingsoft" (
    if /I "%LANG%" == "zh" ( echo 启动官服 ) else ( echo Start: kingsoft )
)

@REM ----------------------------------------------

@REM 程序正常退出
@EXIT /B 0

:func_ensureACP
    @if /I %codepage% NEQ 65001 ( 
        echo "[LOG]: Active code page is not 65001(UTF-8). [%codepage%]"
        chcp 65001
    )
@goto:eof

:func_programinfo_en_us
    @echo Snowbreak_ServerSwitcher(CBJQ_SS)
    @echo Description: This is a server switcher for CBJQ(Snowbreak: Containment Zone) implemented with Windows bat script.
    @echo Author: LiuJiewenTT
    @echo Version: 1.0.0
    @echo Date: 2024-01-24
@goto:eof

:func_programinfo_zh_cn
    @echo 尘白禁区服务器切换器(CBJQ_SS)
    @echo 描述: 这是一个使用Windows批处理脚本实现的尘白禁区服务器切换器。
    @echo 作者: LiuJiewenTT
    @echo 版本: 1.0.0
    @echo 日期: 2024-01-24
@goto:eof
