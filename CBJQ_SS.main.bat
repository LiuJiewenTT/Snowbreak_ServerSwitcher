@echo off

@REM ----------------------------------------------
@REM Program Initialization Stage 1

@REM Set codepage to UTF-8(65001)
@for /F "tokens=2 delims=:" %%i in ('chcp') do @( set /A codepage=%%i ) 
@call :func_ensureACP

@REM ----------------------------------------------
@REM 运行环境注意（普通玩家）

@REM 1. 使用前请确认“用户变量设定区”的已经设置好了启动器路径。
@REM 2. 除了“用户变量设定区”，其它都不要动。

@REM ----------------------------------------------
@REM 运行环境注意（高级玩家）

@REM 1. 如果从命令行启动，请使用“start”而非“call”命令。
@REM 2. 从Powershell启动可能会存在LANG环境变量，缺省值优先从LANG选择。

@REM ----------------------------------------------
@REM 用户变量预设值区

@set launcher_none=cmd.exe /C Exit /B 1

@REM ----------------------------------------------
@REM 用户变量设定区

@REM 以下三行请填入启动器路径(不加引号，不可以为空，没有就填“%launcher_none%”)。
@set launcher_worldwide=%launcher_none%
@set launcher_bilibili=%launcher_none%
@set launcher_kingsoft=%launcher_none%

@REM 以下两句最多启用一个。
@set LANG_default=zh
@REM @set LANG_default=en

@REM ----------------------------------------------
@REM 程序初始化阶段2

if not defined mLANG (
    @REM mLANG: module's LANG
    if defined LANG (
        @REM 使用环境变量选择语言
        for /f "tokens=1,* delims=_" %%i in ("%LANG%") do ( set mLANG=%%i)
    ) else (
        @REM 使用预设默认语言
        set mLANG=%LANG_default%
        if not defined mLANG (
            @REM 普通玩家不要动
            set mLANG=zh
            @REM set mLANG=en
        )
    )
    
)
set mLANG

@REM ----------------------------------------------
@REM 初始化已完成，正式进入程序。

if /I "%mLANG%" EQU "zh" (
    call :func_programinfo_zh_cn
) else (
    call :func_programinfo_en_us
)

@REM ----------------------------------------------
@REM 程序加载完成，开始工作。

if /I "%~1" == "worldwide" (
    if /I "%mLANG%" == "zh" ( echo 启动国际服 ) else ( echo Start: worldwide )
    call "%launcher_worldwide%"
    if ERRORLEVEL 1 (
        echo 出错力！
    )
) else if /I "%~1" == "bilibili" (
    if /I "%mLANG%" == "zh" ( echo 启动B服 ) else ( echo Start: bilibili )
    start "%launcher_bilibili%"
) else if /I "%~1" == "kingsoft" (
    if /I "%mLANG%" == "zh" ( echo 启动官服 ) else ( echo Start: kingsoft )
    start "%launcher_kingsoft%"
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
