@echo off

@REM 设置代码页为UTF-8
@for /F "tokens=2 delims=:" %%i in ('chcp') do @( set /A codepage=%%i ) 
@call :func_ensureACP



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
