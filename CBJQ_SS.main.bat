@echo off

@REM ----------------------------------------------
@REM Program Initialization Stage 1

@REM Set codepage to UTF-8(65001)
@for /F "tokens=2 delims=:" %%i in ('chcp') do @( set /A codepage=%%i ) 
@call :func_ensureACP
REM 已设定代码页，如遇乱码请检查文件编码或终端字体，通常可以得到解决。 

setlocal enabledelayedexpansion

@REM ----------------------------------------------
@REM 运行环境注意（普通玩家） 

@REM 1. 使用前请确认“用户变量设定区”的已经设置好了启动器路径。 
@REM 2. 除了“用户变量设定区”，其它都不要动。 
@REM 3. 请确保路径中不包含这些符号："[]" 

@REM ----------------------------------------------
@REM 运行环境注意（高级玩家） 

@REM 1. 从Powershell启动可能会存在LANG环境变量，缺省值优先从LANG选择。 
@REM 2. 启动参数必须选项在前服务器在后，指定多个服务器会依次触发相应操作。 
@REM 3. 关于上一节第三点的补充说明：目的路径字符串不得包含启动器储存路径字符串。 

@REM pause
@REM ----------------------------------------------
@REM 用户变量预设值区 

@set launcher_none=none

@REM ----------------------------------------------
@REM 用户变量设定区 

@REM 请确保以下六项的每一项（若有需要）都存在，不存在的目录请先行创建，否则程序无法正常运行。 

@REM 以下三行请填入启动器的储存路径(包含文件名，不加引号，不可以为空，建议使用绝对路径，没有就填“%launcher_none%”)。若移动了储存路径，可能会错误识别未存在，尝试切换或删除目的文件即可解决。 
@set launcher_worldwide=%~dp0Launchers\worldwide\snow_launcher-worldwide.exe
@set launcher_bilibili=%~dp0Launchers\snow_launcher-bilibili.exe
@set launcher_kingsoft=%~dp0Launchers\snow_launcher-kingsoft.exe

@REM 以下三行请填入启动器的目的地址(即原地址，包含文件名，不加引号，不可以为空)。路径完全相同时仅能启动一个，启动器限制。 
@set launcher_worldwide_dest=..\snow_launcher.exe
@set launcher_bilibili_dest=..\snow_launcher.exe
@set launcher_kingsoft_dest=..\snow_launcher.exe

@REM 以下两句最多启用一个。 
@set LANG_default=zh
@REM @set LANG_default=en

@set StartupSettingsName_homeland=startup-homeland.settings
@set StartupSettingsName_worldwide=startup-worldwide.settings

@set flag_enable_admin_autodetect=true

@REM ----------------------------------------------
@REM 预留的扩展选项槽，可匹配测试服渠道。 

@REM 用户区 

@set flag_enable_match_with_exslots=true

@set launcher_exslot_1_nickname=slot1
@set launcher_exslot_2_nickname=slot2
@set launcher_exslot_3_nickname=

@set launcher_exslot_1=%launcher_none%
@set launcher_exslot_2=%~dp0Launchers\slot2\snow_launcher-slot2.exe
@set launcher_exslot_3=

@set launcher_exslot_1_dest=..\snow_launcher-test.exe
@set launcher_exslot_2_dest=..\snow_launcher-test.exe
@set launcher_exslot_3_dest=

@set launcher_exslot_1_localization_type=homeland
@set launcher_exslot_2_localization_type=homeland
@set launcher_exslot_3_localization_type=

@REM 非用户区（高级） 

@set flag_allow_multimatch_on_exslots=false

@REM ----------------------------------------------
@REM 程序初始化阶段2

@ if not defined mLANG (
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

set flag_nostart=false
set flag_noswitch=false
set flag_nopause=false
set flag_hasAdminPrivilege=false

set threshold_abort=11
set exit_value=0
set retv_range_startup_start=6
set GameConfigsHome=%APPDATA%\..\Local\Game\Saved
set StartupSettingsDir_path=%GameConfigsHome%\PersistentDownloadDir
set startwrapper=CBJQ_SS.StartWrapper.exe

if /I "%flag_enable_admin_autodetect%" == "true" (
    call :detect_admin_privilege
    if /I "!flag_hasAdminPrivilege!" == "true" (
        if /I "%mLANG%" == "zh" ( echo [INFO] 已检测到管理员权限。 ) else ( echo [INFO] Administrator privileges detected. )
        @REM 不经过wrapper可以在GUI看到启动器运行信息。（当前版本） 
        @REM set "startwrapper="
    ) else (
        if /I "%mLANG%" == "zh" ( echo [INFO] 未检测到管理员权限。 ) else ( echo [INFO] Administrator privileges not detected. )
    )
)

if defined startwrapper (
    set startwrapper="%startwrapper%"
)

:loop1

@ if "%~1" == "" (
    @REM 无参数，仅输出程序信息。 
    goto:loop1_break
) else if "%~1" == "-nostart" (
    set flag_nostart=true
) else if "%~1" == "-noswitch" (
    set flag_noswitch=true
) else if "%~1" == "-nopause" (
    set flag_nopause=true
) else (
    @ if /I "%~1" == "worldwide" (
        if /I "%mLANG%" == "zh" ( echo [INFO] 启动国际服 ) else ( echo [INFO] Start Option: worldwide )
        if /I "%flag_noswitch%" == "false" (
            call :func_updateSymlink "%launcher_worldwide_dest%" "%launcher_worldwide%"
            if ERRORLEVEL %threshold_abort% (
                if /I "%mLANG%" == "zh" ( echo [ERROR] 【终止】：程序异常终止！ ) else ( echo [ERROR] [Abort]: Program Abort^^! )
                goto:loop1_break
            )

            call :switchStartupSetting "worldwide" 
            if /I "!exit_value!" GEQ "%retv_range_startup_start%" if /I "!exit_value!" NEQ "7" ( 
                shift /1
                goto:loop1
            )
        )
        if exist "%launcher_worldwide%" ( 
            if /I "%mLANG%" == "zh" ( echo [INFO] 存在实际启动器文件。 ) else ( echo [INFO] The real launcher file exists. ) 
        ) else (
            if /I "%mLANG%" == "zh" ( echo [INFO] 不存在实际启动器文件。 ) else ( echo [INFO] The real launcher file does not exist. ) 
        )
        if /I "%flag_nostart%" == "false" ( 
            call %startwrapper% "%launcher_worldwide_dest%" 
            if ERRORLEVEL 1 (
                if /I "%mLANG%" == "zh" ( echo [ERROR] 【已检测到】：不存在此服务器的可执行启动器！ ) else ( echo [ERROR] [Detected]: Runnable launcher to this server does not exist^^! )
                set exit_value=2
                if not exist "%launcher_worldwide%" (
                    if /I "%mLANG%" == "zh" ( echo [ERROR] 不存在实际启动器文件。 ) else ( echo [ERROR] The real launcher file does not exist. ) 
                    set exit_value=10
                )
            )
        )
        
    ) else if /I "%~1" == "bilibili" (
        if /I "%mLANG%" == "zh" ( echo [INFO] 启动B服 ) else ( echo [INFO] Start Option: bilibili )
        if /I "%flag_noswitch%" == "false" (
            call :func_updateSymlink "%launcher_bilibili_dest%" "%launcher_bilibili%"
            if ERRORLEVEL %threshold_abort% (
                if /I "%mLANG%" == "zh" ( echo [ERROR] 【终止】：程序异常终止！ ) else ( echo [ERROR] [Abort]: Program Abort^^! )
                goto:loop1_break
            )

            call :switchStartupSetting "homeland" 
            if /I "!exit_value!" GEQ "%retv_range_startup_start%" if /I "!exit_value!" NEQ "7" ( 
                shift /1
                goto:loop1
            )
        )
        if exist "%launcher_bilibili%" ( 
            if /I "%mLANG%" == "zh" ( echo [INFO] 存在实际启动器文件。 ) else ( echo [INFO] The real launcher file exists. ) 
        ) else (
            if /I "%mLANG%" == "zh" ( echo [INFO] 不存在实际启动器文件。 ) else ( echo [INFO] The real launcher file does not exist. ) 
        )
        if /I "%flag_nostart%" == "false" ( 
            call %startwrapper% "%launcher_bilibili_dest%" 
            if ERRORLEVEL 1 (
                if /I "%mLANG%" == "zh" ( echo [ERROR] 【已检测到】：不存在此服务器的可执行启动器！ ) else ( echo [ERROR] [Detected]: Runnable launcher to this server does not exist^^! )
                set exit_value=2
                if not exist "%launcher_bilibili%" (
                    if /I "%mLANG%" == "zh" ( echo [ERROR] 不存在实际启动器文件。 ) else ( echo [ERROR] The real launcher file does not exist. ) 
                    set exit_value=10
                )
            )
        )
        
    ) else if /I "%~1" == "kingsoft" (
        if /I "%mLANG%" == "zh" ( echo [INFO] 启动官服 ) else ( echo [INFO] Start Option: kingsoft )
        if /I "%flag_noswitch%" == "false" (
            call :func_updateSymlink "%launcher_kingsoft_dest%" "%launcher_kingsoft%"
            if ERRORLEVEL %threshold_abort% (
                if /I "%mLANG%" == "zh" ( echo [ERROR] 【终止】：程序异常终止！ ) else ( echo [ERROR] [Abort]: Program Abort^^! )
                goto:loop1_break
            )

            call :switchStartupSetting "homeland" 
            if /I "!exit_value!" GEQ "%retv_range_startup_start%" if /I "!exit_value!" NEQ "7" ( 
                shift /1
                goto:loop1
            )
        )
        if exist "%launcher_kingsoft%" ( 
            if /I "%mLANG%" == "zh" ( echo [INFO] 存在实际启动器文件。 ) else ( echo [INFO] The real launcher file exists. ) 
        ) else (
            if /I "%mLANG%" == "zh" ( echo [INFO] 不存在实际启动器文件。 ) else ( echo [INFO] The real launcher file does not exist. ) 
        )
        if /I "%flag_nostart%" == "false" ( 
            call %startwrapper% "%launcher_kingsoft_dest%" 
            if ERRORLEVEL 1 (
                if /I "%mLANG%" == "zh" ( echo [ERROR] 【已检测到】：不存在此服务器的可执行启动器！ ) else ( echo [ERROR] [Detected]: Runnable launcher to this server does not exist^^! )
                set exit_value=2
                if not exist "%launcher_kingsoft%" (
                    if /I "%mLANG%" == "zh" ( echo [ERROR] 不存在实际启动器文件。 ) else ( echo [ERROR] The real launcher file does not exist. ) 
                    set exit_value=10
                )
            )
        )
        
    ) else (
        set flag_matched_on_exslots=false
        set flag_exslot_match_loopbreak=false
        if /I "%flag_enable_match_with_exslots%" == "true" (
            if /I "%mLANG%" == "zh" ( echo [INFO] 尝试在预留槽位匹配此服务器的启动器配置。【%~1】 ) else ( echo [INFO] Try to match the launcher of this server in the reserved slots. [%~1] )
            
            for /L %%i in (1, 1, 3) do (            
                if /I "!flag_exslot_match_loopbreak!" == "false" (
                    if /I "%mLANG%" == "zh" ( echo [INFO] 尝试在预留槽位【%%i】匹配此服务器的启动器配置。 ) else ( echo [INFO] Try to match the launcher of this server in the reserved slot No.%%i. ) 
                    if "%~1" == "!launcher_exslot_%%i_nickname!" (
                        if /I "%mLANG%" == "zh" ( echo [INFO] 匹配成功。 ) else ( echo [INFO] The match was successful. )
                        set flag_matched_on_exslots=true
                        if /I "%flag_allow_multimatch_on_exslots%" == "false" (
                            set flag_exslot_match_loopbreak=true
                        )
                        
                        if /I "%mLANG%" == "zh" ( echo [INFO] 启动!launcher_exslot_%%i_nickname! ) else ( echo [INFO] Start Option: !launcher_exslot_%%i_nickname! )
                        if /I "%flag_noswitch%" == "false" (
                            call :func_updateSymlink "!launcher_exslot_%%i_dest!" "!launcher_exslot_%%i!"
                            if ERRORLEVEL %threshold_abort% (
                                if /I "%mLANG%" == "zh" ( echo [ERROR] 【终止】：程序异常终止！ ) else ( echo [ERROR] [Abort]: Program Abort^^! )
                                goto:loop1_break
                            )

                            call :switchStartupSetting "!launcher_exslot_%%i_localization_type!" 
                            if /I "!exit_value!" GEQ "%retv_range_startup_start%" if /I "!exit_value!" NEQ "7" ( 
                                shift /1
                                goto:loop1
                            )
                        )
                        if exist "!launcher_exslot_%%i!" ( 
                            if /I "%mLANG%" == "zh" ( echo [INFO] 存在实际启动器文件。 ) else ( echo [INFO] The real launcher file exists. ) 
                        ) else (
                            if /I "%mLANG%" == "zh" ( echo [INFO] 不存在实际启动器文件。 ) else ( echo [INFO] The real launcher file does not exist. ) 
                        )
                        if /I "%flag_nostart%" == "false" ( 
                            call %startwrapper% "!launcher_exslot_%%i_dest!" 
                            if ERRORLEVEL 1 (
                                if /I "%mLANG%" == "zh" ( echo [ERROR] 【已检测到】：不存在此服务器的可执行启动器！ ) else ( echo [ERROR] [Detected]: Runnable launcher to this server does not exist^^! )
                                set exit_value=2
                                if not exist "!launcher_exslot_%%i!" (
                                    if /I "%mLANG%" == "zh" ( echo [ERROR] 不存在实际启动器文件。 ) else ( echo [ERROR] The real launcher file does not exist. ) 
                                    set exit_value=10
                                )
                            )
                        )
                        
                    )
                )

            )
        )

        if /I "!flag_matched_on_exslots!" == "false" (
            if /I "%mLANG%" == "zh" ( echo [ERROR] 【未知】：未配置此服务器的启动器！【%~1】 ) else ( echo [ERROR] [Unknown]: Launcher to this server is not configured^^! [%~1] )
            set exit_value=3
        )
    )
)
shift /1

goto:loop1
:loop1_break

@REM ----------------------------------------------


@REM 程序退出 
echo exit_value=%exit_value%
set "StartupSettingsName_homeland="
set "StartupSettingsName_worldwide="
if /I "%flag_nopause%" NEQ "true" ( pause )
@REM @endlocal
@ EXIT /B %exit_value%

@REM ----------------------------------------------
@REM exit_value含义 
@REM 备注：仅能返回最后的错误代码。 

@REM 1  指示未完成设定的错误，约等于未知错误。 
@REM 2  不存在可执行的启动器。 
@REM 3  切服器未找到此服务器启动选项的配置。 
@REM 4  目的地的启动器并非符号链接，非本程序创建。 
@REM 5  启动器链接失败。 
@REM 6  目的地的启动设置文件并非符号链接，非本程序创建。 
@REM 7  切服器未找到此服务器所需的启动配置实际文件。 
@REM 8  启动设置链接失败。 
@REM 9  在未启用国服国际服支持的情景下断开链接失败。 
@REM 10 不存在实际启动器文件。 
@REM ----------------------------------------------

:func_ensureACP
    @if /I %codepage% NEQ 65001 ( 
        echo "[LOG]: Active code page is not 65001(UTF-8). [%codepage%]"
        chcp 65001
    )
@ goto:eof

:func_programinfo_en_us
    @echo Snowbreak_ServerSwitcher(CBJQ_SS)
    @echo Description: This is a server switcher for CBJQ(Snowbreak: Containment Zone) implemented with Windows bat script.
    @echo Author: LiuJiewenTT
    @echo Version: 1.2.1
    @echo File Version: 1.2.1
    @echo Date: 2024-06-08
    @echo Note：Github Repo：^<https://github.com/LiuJiewenTT/Snowbreak_ServerSwitcher^>
    @echo       Author's Email：^<liuljwtt@163.com^>
@ goto:eof

:func_programinfo_zh_cn
    @echo 尘白禁区服务器切换器(CBJQ_SS)
    @echo 描述: 这是一个使用Windows批处理脚本实现的尘白禁区服务器切换器。
    @echo 作者: LiuJiewenTT
    @echo 版本: 1.2.1
    @echo 文件版本: 1.2.1
    @echo 日期: 2024-06-08
    @echo 备注：Github项目链接：^<https://github.com/LiuJiewenTT/Snowbreak_ServerSwitcher^>
    @echo       作者Email地址：^<liuljwtt@163.com^>
@ goto:eof

:detect_admin_privilege
    @REM method 1
    net session >nul 2>&1 
    @REM method 2
    @REM openfiles >nul 2>&1 
    if ERRORLEVEL 1 (
        set flag_hasAdminPrivilege=false
    ) else (
        set flag_hasAdminPrivilege=true
    )
@ goto:eof

:func_updateSymlink
@REM param1: Name of launcher (It can be a path).
@REM param2: Path to expected real launcher (It can be a relative path).

    set launcherpath=%~1
    set launchername=%~nx1
    set reallauncherpath=%~2
    if /I "%mLANG%" == "zh" ( echo [INFO] 【启动器目的地路径】：%launcherpath% ) else ( echo [INFO] [Destination of Launcher]: %launcherpath% )
    if /I "%mLANG%" == "zh" ( echo [INFO] 【启动器文件名】：%launchername%) else ( echo [INFO] [Filename of Launcher]: %launchername% )
    if /I "%mLANG%" == "zh" ( echo [INFO] 【启动器储存路径】：%reallauncherpath%) else ( echo [INFO] [Store Path of Launcher]: %reallauncherpath% )

    dir "%launcherpath%" 2>nul | findstr "<SYMLINK>" | findstr /E /C:"[%reallauncherpath%]"

    if ERRORLEVEL 1 (
        if exist "%launcherpath%" (
            for /f "delims=" %%i in ('dir "%launcherpath%" ^| findstr /C:"%launchername%"') do (
                echo [INFO] [Existed, old] %%i
            )
            dir "%launcherpath%" | findstr "<SYMLINK>"
            if ERRORLEVEL 1 (
                set exit_value=4
                if /I "%mLANG%" == "zh" ( 
                    echo [ERROR] 目的地的启动器并非符号链接，非本程序创建。为保证真的启动器不被错删，程序终止。使用程序前，请按照说明做好准备。 
                ) else ( 
                    echo ^
[ERROR] Launcher in destination is not a SYMLINK, which means it was not created by this program. ^
To avoid deleting real launcher by mistake, this program will be terminated. ^
Before using this program, please follow the instructions to set up. 
                )
                if /I "%flag_nopause%" NEQ "true" ( pause )
                @REM endlocal
                @ EXIT /B %threshold_abort%
            )
            if /I "%mLANG%" == "zh" ( echo [INFO] 删除旧符号链接 ) else ( echo [INFO] Deleting old SYMLINK... )
            del "%launcherpath%"
        ) else (
            if /I "%mLANG%" == "zh" ( echo [INFO] 目的地不存在启动器 ) else ( echo [INFO] Launcher does not exist in destination. )
        )
        if /I "%mLANG%" == "zh" ( echo [INFO] 准备替换 ) else ( echo [INFO] Replacing... )
        mklink "%launcherpath%" "%reallauncherpath%"
    ) else (
        if /I "%mLANG%" == "zh" ( echo [INFO] 新启动器链接已存在 ) else ( echo [INFO] Link to the new launcher has been ready. )
    )
    dir "%launcherpath%" | findstr "<SYMLINK>" | findstr /E /C:"[%reallauncherpath%]"
    if ERRORLEVEL 1 (
        if /I "%mLANG%" == "zh" ( echo [ERROR] 链接失败 ) else ( echo [ERROR] Failed to link. )
        set exit_value=5
    ) else (
        if /I "%mLANG%" == "zh" ( echo [INFO] 启动器链接已完全准备好。 ) else ( echo [INFO] Everything about the link to the launcher is ready. )
    )
@ goto:eof

:switchStartupSetting
    if /I "%mLANG%" == "zh" ( echo [INFO] 【启动设置目录】：%StartupSettingsDir_path%。 ) else ( echo [INFO] [Directory]: %StartupSettingsDir_path%. )

    @REM 出现此默认值表示运行错误 
    set RealStartupSettingsName=Startup.Settings.none
    set flag_StartupSettings=none
    set flag_isHomeland=0
    set flag_isWorldwide=0
    set flag_all_exist=false

    if defined StartupSettingsName_homeland if defined StartupSettingsName_worldwide (
        set flag_all_exist=true
    )
    
    if /I "%mLANG%" == "zh" ( echo [INFO] 当前请求的启动设置拥有者：%~1。 ) else ( echo [INFO] Current requested owner of Startup Settings: %~1. )
    if exist "%StartupSettingsDir_path%\startup.settings" (
        dir "%StartupSettingsDir_path%\startup.settings" 2>nul | findstr "<SYMLINK>"
        if ERRORLEVEL 1 if /I "%flag_all_exist%" == "true" (
            if /I "%mLANG%" == "zh" ( 
                echo [ERROR] 当前启动设置文件并非符号链接，请继续配置。 
                echo [INFO] 【目录】：%StartupSettingsDir_path%
            ) else ( 
                echo [ERROR] Current Startup Settings file is not a link, please configure further. 
                echo [INFO] [Directory]: %StartupSettingsDir_path%
            )
            set exit_value=6
            goto:eof
        ) else (
            if /I "%mLANG%" == "zh" ( echo [INFO] 国服国际服兼容支持特性未在程序配置中启用。 ) else ( echo [INFO] Support for playing both homeland and worldwide is not enabled in program configuration. )
            goto:eof
        )
        dir "%StartupSettingsDir_path%\startup.settings" 2>nul | findstr "<SYMLINK>" | findstr /E /C:"[.\%StartupSettingsName_homeland%]"
        if ERRORLEVEL 1 (
            @ REM pass
        ) else (
            set flag_isHomeland=1
            if /I "%mLANG%" == "zh" ( echo [INFO] 当前启动设置属于国服。 ) else ( echo [INFO] Current Startup Settings belong to homeland. )
            set flag_StartupSettings=homeland
        )
        dir "%StartupSettingsDir_path%\startup.settings" 2>nul | findstr "<SYMLINK>" | findstr /E /C:"[.\%StartupSettingsName_worldwide%]"
        if ERRORLEVEL 1 (
            @ REM pass
        ) else (
            set flag_isWorldwide=1
            if /I "%mLANG%" == "zh" ( echo [INFO] 当前启动设置属于国际服。 ) else ( echo [INFO] Current Startup Settings belong to worldwide. )
            set flag_StartupSettings=worldwide
        )
    )
    @REM echo %RealStartupSettingsName%
    if "%~1" == "homeland" (
        if defined StartupSettingsName_homeland set RealStartupSettingsName=%StartupSettingsName_homeland%
    ) else if "%~1" == "worldwide" (
        if defined StartupSettingsName_worldwide set RealStartupSettingsName=%StartupSettingsName_worldwide%
    )
    @REM echo %RealStartupSettingsName%
    if exist "%StartupSettingsDir_path%\%RealStartupSettingsName%" (
        if /I "%mLANG%" == "zh" ( echo [INFO] 对应启动设置存在，可以继续。 ) else ( echo [INFO] Corresponding file exists, good to go. )
    ) else (
        if /I "%flag_all_exist%" == "true" (
            set exit_value=7
            if /I "%mLANG%" == "zh" ( 
                echo [INFO] 对应的启动设置实际文件不存在，请做好重命名工作。 
                echo [INFO] 【目录】：%StartupSettingsDir_path%
                echo [INFO] 【需要的文件名】：%RealStartupSettingsName%
            ) else ( 
                echo [INFO] Corresponding actual file does not exist, check your renaming work. 
                echo [INFO] [Directory]: %StartupSettingsDir_path%
                echo [INFO] [Required Filename]: %RealStartupSettingsName%
            )
        ) else (
            if /I "%mLANG%" == "zh" ( echo [INFO] 国服国际服兼容支持特性未在程序配置中启用。 ) else ( echo [INFO] Support for playing both homeland and worldwide is not enabled in program configuration. )
            if /I "%mLANG%" == "zh" ( echo [INFO] 正在断开启动设置链接。 ) else ( echo [INFO] Breaking link to old Startup Settings. )
            del "%StartupSettingsDir_path%\startup.settings"
            if ERRORLEVEL 1 (
                if /I "%mLANG%" == "zh" ( echo [INFO] 启动设置链接断开失败。 ) else ( echo [INFO] Fail to break the link to the Startup Settings. )
                set exit_value=9
            ) else (
                if /I "%mLANG%" == "zh" ( echo [INFO] 启动设置链接断开成功。 ) else ( echo [INFO] Succeed to break the link to the Startup Settings. )
            )
            goto:eof
        )
    )
    if "%~1" NEQ "%flag_StartupSettings%" (
        if /I "%mLANG%" == "zh" ( echo [INFO] 准备切换启动设置。 ) else ( echo [INFO] Switching Startup Settings. )
        set flag_delete_startupsettings=false
        if exist "%StartupSettingsDir_path%\startup.settings" set flag_delete_startupsettings=true
        if "%flag_StartupSettings%" NEQ "none" set flag_delete_startupsettings=true
        if /I "!flag_delete_startupsettings!" == "true" (
            if /I "%mLANG%" == "zh" ( echo [INFO] 正在删除旧启动设置（或其链接）。 ) else ( echo [INFO] Deleting Old Startup Settings ^(or its link^). )
            del "%StartupSettingsDir_path%\startup.settings"
            if ERRORLEVEL 1 (
                if /I "%mLANG%" == "zh" ( echo [INFO] 删除失败。 ) else ( echo [INFO] Failed to delete. )
                goto:eof
            )
        ) else (
            if /I "%mLANG%" == "zh" ( echo [INFO] 当前不存在启动设置链接。 ) else ( echo [INFO] There is no Startup Settings link existed for now. )
        )
        if /I "%mLANG%" == "zh" ( echo [INFO] 准备链接到新启动设置。 ) else ( echo [INFO] Linking to new Startup Settings. )
        @REM mklink "%StartupSettingsDir_path%\startup.settings" "%StartupSettingsDir_path%\%RealStartupSettingsName%"
        mklink "%StartupSettingsDir_path%\startup.settings" ".\%RealStartupSettingsName%"
        if ERRORLEVEL 1 (
            if /I "%mLANG%" == "zh" ( echo [INFO] 启动设置链接失败。 ) else ( echo [INFO] Fail to link Startup Settings. )
            set exit_value=8
        ) else (
            if /I "%mLANG%" == "zh" ( echo [INFO] 启动设置链接创建成功。 ) else ( echo [INFO] Succeed in creating Startup Settings link. )
        )
    ) else if /I "%exit_value%" LSS "6" (
        if /I "%mLANG%" == "zh" ( echo [INFO] 启动设置已就绪，无需操作。 ) else ( echo [INFO] Startup Settings have been ready and need no further operation. )
    )
@ goto:eof
