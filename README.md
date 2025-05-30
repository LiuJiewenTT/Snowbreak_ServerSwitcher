---
LANG: zh_CN.UTF-8
date: 2025-05-25 22:21:00 +0800
permalink: /
redirect_from:
  - /README/
---

# 《尘白禁区》服务器切换器

<div style="align-items: center; justify-content: center; display: flex; margin: 10px;">
    <img src="辰星-云篆 团子.jpg" style=" max-height: 300px; height: 100%; aspect-ratio: 1; width: auto;"/>
</div>

<div style="align-items: center; justify-content: center; display: flex; margin: 10px; gap: 10px">
   <img alt="GitHub Downloads (all assets, all releases)" src="https://img.shields.io/github/downloads/LiuJiewenTT/Snowbreak_ServerSwitcher/total">
   <img alt="GitHub Release" src="https://img.shields.io/github/v/release/LiuJiewenTT/Snowbreak_ServerSwitcher">
   <img alt="GitHub Actions Workflow Status" src="https://img.shields.io/github/actions/workflow/status/LiuJiewenTT/Snowbreak_ServerSwitcher/jekyll-gh-pages.yml">
   <img alt="GitHub License" src="https://img.shields.io/github/license/LiuJiewenTT/Snowbreak_ServerSwitcher">
</div>

本工具可以帮助你切换游玩不同服务器的《尘白禁区》游戏（Windows PC端）。

快速跳转：[下载安装](#下载安装) [使用说明](#使用说明) [帮助](#帮助)
    [旧主页](old/)

项目地址：[GitHub](https://github.com/LiuJiewenTT/Snowbreak_ServerSwitcher) <br>
项目主页：[尘白禁区服务器切换器](https://liujiewentt.github.io/Snowbreak_ServerSwitcher/) 

## 背景介绍

在PC端，《尘白禁区》有三个主要的服务器可供选择，包括“官服”“B服”和“国际服”。其中，“官服”和“B服”属于国服版本。

关于PC端的官方启动器，《尘白禁区》目前有两种：**尘白禁区启动器**和*西山居（尘白）启动器*。<strong style="color:red">前者是仍在更新的原启动器，后者是极其不稳定的替代启动器，强烈建议不要使用后者，改用前者！</strong>本项目的所有内容针对前者进行适配和开发，绝不适配后者。

> 注：由于游戏本体对西山居启动器存在不完整支持，并会先行检测部分适用于它的配置文件，因此可能会导向某些bug代码。因此，即便你可以不卸载西山居启动器和删除游戏资源就改用尘白启动器，也不建议这么做，除非你缺少流量重新下载资源（[指南](#关于从西山居启动器迁移到尘白启动器，但不卸载西山居启动器和删除游戏资源)）。

由于不同服使用的内容不完全一致，也不完全兼容，因此需要做一些额外的操作才能让玩家在不同服务器间游玩。此外，游戏的资源多达20GB+，如果能共用一部分资源那是再好不过了。


<details><summary>冲突主要出现在以下几个方面：</summary>
    <ol>
        <li>资源版本：对于同时期的正式服，国服的两个服使用相同的资源，资源可以共享，无需重复下载；对于国服与国际服，两者使用的资源差异较大，资源清单文件<code>manifest.json</code>内容不互通不兼容；对于正式服与测试服，两者的资源显然不同，无法共用。</li>
        <li>设置存储：对于国服的两个服，使用的设置可以共享；对于国服和国际服，使用的设置互相冲突，无法共享。</li>
    </ol>
</details>

<details><summary>冲突的主要成因：</summary>
    <ol>
        <li>对于资源版本：资源清单的不同直接导致资源目录的不共享。此处细分两种原因：
            <ol>
                <li>启动器会检查清单文件版本和内容，如果存在出入，则会做资源校验，并在这个过程中持续覆写（过程出错则等同于破坏）。此处存在未知原因，即便从他处重新获取了正确的清单文件，也可能无法识别，而使启动器提示需要全部重新下载。</li>
                <li>如果在启动器中执行了“更新资源”，则会增减原有资源，导致原有版本无法启动，即无法进入原本的服务器。</li>
            </ol>
        </li>
        <li>对于存储的设置，按内容分：
            <ol>
                <li>缓存的服务器选择：由于国际服存在多个区服，需要选择区服，故<code>startup.settings</code>文件中会记录选择的服务器号，在游戏启动时会优先引用这个值。国服砍了切区服功能，也就使得本体只会尝试使用错误的服务器号进行登录连接，表现为持续处于鉴权状态，无法进入游戏的大厅界面。</li>
                <li>语言的选择：其实这部分设置（在<code>Game.ini</code>文件中）本来是兼容的，但是由于不同服务器之间，可能存在bug或内容缺失，导致可能出现一些意外的语言搭配，不过这部分不影响正常游戏。一个比较有趣的例子是，在上次启动的国际服中使用了英语配音，这次启动回到国服听到的语音就是英语配音。</li>
            </ol>
        </li>
    </ol>
</details>

<details><summary>冲突的应对措施：</summary>
    <ol>
        <li>对于资源版本：资源目录的路径存储在启动器同目录下的<code>preference.json</code>文件中，因此对于不同资源版本，启动器存储在不同的目录中。</li>
        <li>对于存储的设置，按内容分：
            <ol>
                <li>缓存的服务器选择：由于国服无需选择服务器，仅国际服需要，故分出两个选项，国服统一使用符号链接链接到专用的启动设置文件，国际服使用符号链接链接到另外的启动设置文件。</li>
                <li>语言的选择：这部分根据玩家需求可能比较多样，因此提供对于每个服使用的游戏设置文件的自定义功能，使用符号链接实现切换。</li>
            </ol>
        </li>
    </ol>
</details>

## 产品特点

<p style="text-align:center; font-size:2em; font-weight:bold;">统一入口、资源共享、硬盘友好、安全高效、可自定义</p>

1. 提供共用的启动器入口，支持共用快捷方式，第三方平台（如：雷游(*Razor Cortex*)等监控游戏性能的软件）无需填写多个应用入口。
2. 支持国服和国际服共存（同系统账户下）。
3. 适配可能存在的测试服。
4. 支持官服和B服资源共享，无需重复下载。
5. 支持不同服使用不同语言设置，不串台。
6. 详尽且准确的输出信息和错误纠正提示。

更多：<br>
7. 自动检测当前文件配置，高效安全。
8. 支持启动器控制台输出监控，可以了解启动器的运行情况。
9. 完全开源，大部分为脚本，完全透明安全。
10. 输出语言支持中文、英文。

## 下载安装

请转到Releases页面下载最新版本的安装包。[下载](https://github.com/LiuJiewenTT/Snowbreak_ServerSwitcher/releases)

下载后无需安装，将压缩包解压出来即可。（旧版本和特殊需求可能需要额外配置）<br>
*推荐的存储位置* 是原本尘白启动器的所在目录下，例如：`M:\Program Files\Snow\`（如果你玩过了，此处你应该还会看到一个`data`文件夹）。

> 使用方法见[【使用说明】](#使用说明)。

版本说明：

- 基础版：仅包含此核心，不包含GUI，且仅包含能运行的最小配置。
- 完整版：包含此核心和GUI，并包含更加完整、更加接近开箱即用的配置。文件名中带有`GUI`标识。
  > - GUI目前仅有 *tkinter* 实现版本。
  > - GUI通常以 *BasicPack* 的形式提供，不附带过多资源，尽可能避免版权纠纷。需要美化请自行配置。
  > - 发行包通常完成了基本配置，推荐使用附带GUI程序的版本。


> 注：若需要尘白启动器，可以在[snow_launcher_downloader](.\tools\snow_launcher_downloader\snow_launcher_downloader.html)下载（[备用](https://liujiewentt.github.io/snow_launcher_downloader/snow_launcher_downloader.html)）。下载后建议根据服名分别重命名为`snow_launcher-bilibili.exe`, `snow_launcher-kingsoft.exe`, `snow_launcher-worldwide.exe`。<br>
>（本项目亦友情提供缓存的版本，可在[此处](https://github.com/LiuJiewenTT/Snowbreak_ServerSwitcher/releases/tag/v1.2.2)下载）

### 更新安装的版本

由于发行的压缩包内带有一些初始配置文件，如果你曾经修改过其中的内容，请注意备份旧文件，更新后，可以使用VSCode等编辑器进行比对和更改。部分配置同运行脚本在一起，更新的时候可能需要特别注意。

### 配置

配置主要分为本体配置和周边配置（例如：GUI配置），详细内容可以在[旧主页](old/)查看。

本体配置：新版通常无需修改**切服器的配置**，仅需完成一些适配工作（即其他配置工作）即可（需要执行的操作会在运行过程中提示，依据提示操作即可）。

如果你使用旧版本，或者有特别的需求（例如：关闭国际服支持、切换为英文、使用测试服），那么一定要修改一些对应的配置信息。

关于GUI的配置，可以前往[CBJQ_SS_FrontEnd-tk](https://github.com/LiuJiewenTT/CBJQ_SS_FrontEnd-tk)项目页查看。<small>“过于高级/冷门”的功能配置就不表述了，在对应项目的文档中可能有详细说明。</small>

更多详细配置请参考[旧主页](old/)，那里还有旧的介绍和指引系列视频（视频教程）的链接。

## 使用说明

此部分主要分为两部分，第一部分介绍项目本体的独立使用方法，第二部分额外介绍推荐的GUI套件发行包的使用方法。对于无编程基础的人，推荐直接跳过第一部分。每一部分，可能会额外划分基础内容和进阶内容，请自行选用。

> 旧版本和特殊需求可能需要额外[配置](#配置)。
> 部分情况可能需要管理员权限才能运行，比如安装在C盘特殊目录内。

<details><summary>第1部分：本体独立使用</summary>
    由于本体无GUI程序，因此通常需要使用命令行环境进行操作。本项目做了一些简化，除进阶方法外，无需通过终端环境使用。<br>
    关于在命令行环境中使用，您可以选择<code>cmd.exe</code>或<code>wt.exe</code>(<i>Windows Terminal</i> / 终端)，不推荐选择<i>PowerShell</i>。其中，第一项为推荐的执行程序。如果您使用终端(wt)，也更推荐您使用“命令提示符”类型环境。
    <ol>
        <li><details open><summary>基础使用方法I：</summary>
            <ol>
                在发行的压缩包中，您应当会看到一个名为<code>CBJQ_SS.QS.exe</code>的程序。在部分发行包中，您还会看到<code>CBJQ_SS.QS.</code>为前缀、<code>.exe</code>为后缀，中间为服名的程序副本。需要什么中间名的副本取决于您需要一键启动什么服。此外，也<strong>推荐您将常用的副本<span title="选中，右键，发送到，桌面快捷方式">发送快捷方式到桌面</span></strong>。
                <li>双击运行准备好的<code>CBJQ_SS.QS.*.exe</code>。<i>此部分无需终端</i><br>
                    注：“*”的示例值：“bilibili”、“kingsoft”、“worldwide”
                </li>
            </ol>
        </details></li>
        <li><details open><summary>基础使用方法II：</summary>
            <ol>
                <li>双击运行准备好的“尘白禁区*服（*）.bat”脚本。<i>此部分无需终端</i><br>
                    解释：
                    <ol>
                        <li>“*服”指：B服、官服、国际服</li>
                        <li>“（*）”指：“启动”、“切换”、“启动+切换”</li>
                    </ol>
                </li>
            </ol>
        </details></li>
        <li><details><summary>进阶使用方法：</summary>
            <ol>此方法需要您启动一个命令行终端，输入命令触发程序执行。
                <li>打开命令行终端。</li>
                <li>按需使用命令：
                    <ol>
                        <li>命令解释：
                            <ol>
                                <li>程序名：<code>CBJQ_SS.main.bat</code>。用<code>CBJQ_SS.main</code>（不带扩展名）也可。
                                    <small>程序启动时总会展示版本信息。</small>
                                </li>
                                <li><details open><summary>参数解释：</summary>
                                    <ol>
                                        <li>服名，必须在所有选项之后。可选取值：<code>bilibili</code>, <code>kingsoft</code>, <code>worldwide</code>。<br>
                                            <small>你还可以启动测试服，但这就需要额外配置了。</small>
                                        </li>
                                        <li><code>-nostart</code>：执行完毕时<strong style="color:red">不启动启动器</strong>。</li>
                                        <li><code>-noswitch</code>：执行时<strong style="color:red">不切换启动器</strong>。</li>
                                        <li><code>-nopause</code>：执行完毕时<strong style="color:red">不触发暂停（“按下任意键继续”）</strong>。</li>
                                    </ol>
                                </details></li>
                            </ol>
                        </li>
                        <li><details open><summary>示例如下：</summary>
                            <ol>
                                <li>切换并启动B服：<code>CBJQ_SS.main.bat bilibili</code>。</li>
                                <li>切换并启动官服（不暂停）：<code>CBJQ_SS.main.bat -nopause kingsoft</code>。</li>
                                <li>不切换并<strong>直接启动</strong>国际服（不暂停）：<code>CBJQ_SS.main.bat -noswitch -nopause worldwide</code>。<br>
                                    <small>（即：仅启动）</small>
                                </li>
                                <li>切换<strong>但不启动</strong>国际服（不暂停）：<code>CBJQ_SS.main.bat -nostart -nopause worldwide</code>。<br>
                                    <small>（即：仅切换）</small>
                                </li>
                                <li>没什么意义的连续切服（不暂停）且不启动：<code>CBJQ_SS.main.bat -nostart -nopause bilibili kingsoft worldwide</code>。<br>
                                    <small>如果启动，则会按最后且最新的一个为准。</small>
                                </li>
                            </ol>
                        </details></li>
                    </ol>
                </li>
            </ol>
        </details></li>
    </ol>
</details>
<details><summary>第2部分：配合GUI等周围设施使用</summary>
    此部分以推荐的默认GUI程序为例，您需要使用带有GUI字样的发行包才能使用GUI。默认GUI发行版分为A版（单文件版）和B版（极速版），此项目发行通常使用的是B版，但您也可以改用A版。<small>配置步骤不在此部分。</small><br>
    以下使用<code>GUIs\CBJQ_SS_FrontEnd_tk-B-I2\CBJQ_SS_FrontEnd_tk-B-I2\CBJQ_SS_FrontEnd_tk-B-I2.exe</code>示范。
    <ol>
        <li><details open><summary>基础使用方法：</summary>
            <ol>
                <li>双击运行准备好的<code>CBJQ_SS_FrontEnd_tk-B-I2.exe</code>。<strong>推荐<span title="选中，右键，发送到，桌面快捷方式">发送到桌面快捷方式</span></strong>，并使用管理员权限启动（可以在快捷方式的属性页的兼容性选项卡中勾选）。</li>
                <li>在左侧选中你需要的服。</li>
                <li>根据需要点击按钮：“切换”、“切换并启动”、“直接启动”。<small>可以开启日志展示以观察运行状况。</small></li>
            </ol>
        </details></li>
        <li><details open><summary>进阶使用方法：</summary>
            此部分主要是调整一些配置，进而展现一些“高级”功能。
        </details></li>
    </ol>
</details>

<details><summary>不华而不实的另类使用方法，仅供爱折腾、炫技的人使用。</summary>
    如果您满足以下任意一种情况：
    <ol>
        <li>您原本使用尘白版安装包（非西山居版）安装过尘白禁区，使用的是尘白启动器，且桌面上有尘白启动器的快捷方式。</li>
        <li>正常切换过启动器，有目标名为<code>snow_launcher.exe</code>的符号链接（文件资源管理器的<i>详细信息</i>查看模式下类型显示<code>.symlink</code>且，文件大小显示0字节）。</li>
    </ol>
    那么您可以为<code>snow_launcher.exe</code>创建桌面快捷方式，双击启动就是对应服的启动器（只是这种情况切服需要用bat脚本或调整配置的QS）。
</details>

## LICENSE

本项目遵循MIT开源协议。

本项目含子项目[`CBJQ_SS.StartWrapper` (`.\startwrapper`)](https://github.com/LiuJiewenTT/CBJQ_SS.StartWrapper)（MIT开源协议）实现管理员权限下符号链接解析，以确保使用的配置文件正确。构建产品应存储在`main`所在目录；

本项目含子项目[`CBJQ_SS.QS` (`.\quickstart`)](https://github.com/LiuJiewenTT/CBJQ_SS.QS)（MIT开源协议）实现一键切换并启动。构建产品推荐在`main`所在目录使用；

本项目内置[`IconFold` `v1.0.0` (`.\tools\IconFold\v1.0.0`)](https://github.com/LiuJiewenTT/IconFold)（MIT开源协议）实现文件夹图标的设置。可以删除此目录。

本项目内置[`snow_launcher_downloader` (`.\tools\snow_launcher_downloader`)](https://github.com/LiuJiewenTT/snow_launcher_downloader)（UNLICENSE协议）实现自动下载最新版本的启动器。可以删除此目录。

本项目或其组件含[cJSON @ 3249730](https://github.com/DaveGamble/cJSON/tree/324973008ced4ea03d1626a00915d0399ecbd9db)，遵循其要求（MIT开源协议）。

### GUIs

可用GUI程序：

1. 项目：[CBJQ_SS_FrontEnd-tk](https://github.com/LiuJiewenTT/CBJQ_SS_FrontEnd-tk)。（目前仅支持中文）

## Copyrights

此部分主要列出使用的部分资源的版权声明。（排序不分先后）

| 资源位置           | 版权所有者                                   | 备注                                           |
| ------------------ | -------------------------------------------- | ---------------------------------------------- |
| 辰星-云篆 团子.jpg | *魔法少女鱼鱼熏Kaori* (B站用户UID: 66874794) |                                                |
| icon1.ico          | *魔法少女鱼鱼熏Kaori* (B站用户UID: 66874794) | 本项目第一作者自行从`辰星-云篆 团子.jpg`转换而来。 |

本项目无意冒犯，如有侵权，请联系本项目作者删除相关资源。项目作者不对资源的原始版权归属负责。

## 帮助

如果遇到任何问题，欢迎在项目页提交issue，或发送邮件至：`liuljwtt@163.com`。

以下是对于文档中部分内容的额外指南：

### 关于从西山居启动器迁移到尘白启动器，但不卸载西山居启动器和删除游戏资源

如果你已经安装了西山居启动器，但又不想卸载它，也不想删除游戏资源，那么可以尝试以下方法：

> 你需要先行下载好尘白启动器。

> 尘白启动器的资源目录默认为：启动器文件所在目录下的`data`目录。
> > 如果你使用开服安装包安装的，这个路径应该是: `[盘符]\Snow\data`。
>
> 西山居启动器的资源目录默认为：启动器文件所在目录下的`Game\cbjq`目录。
>
> > 如果你使用不早于尘白一周年的安装包安装的，这个路径通常是:` [盘符]\SeasunCBJQos\Game\cbjq`。


1. 选好尘白启动器的存放目录，运行它，修改下方的游戏资源存档目录到当前西山居版的游戏资源目录。
> 你也可以在右上角的设置（“齿轮”）图标内的界面更改资源存档目录。
2. 关闭启动器就会保存好设置（到同目录下的`preference.json`文件中）。


### 原本使用西山居启动器，现在被顶号了登录不了了怎么办？

如果你曾经使用过西山居启动器**游玩游戏**（登录过），如果你：
1. 还在继续使用。
2. 没有完全卸载西山居启动器和它下载的游戏资源，直接改用尘白启动器。

当你被顶号时，你已经保存的登录信息就失效了，你需要重新登录，这是正常情况。不正常的情况是：你后来登录不上了，那么你需要删除已保存的登录信息，它过期了，这样才能重新登录。

1. 删除西山居版安装目录下的`xg_111111639`（你可以搜索一下，你可以选择不删除而是重命名）。


### 玩了一下国际服，结果国服进不了了怎么办？

这件事是国际服配置和国服冲突造成的，区服错误，导致卡在鉴权的环节上（国内网络通常连不上国际服）。

这件事只需要删除一项区服配置即可，或者直接把这项配置所在的文件整个删掉。<strong>为了简化这个操作，我做了个专门删除这文件的脚本（文件名：`CBJQ_KickoffWorldwideServerConfigConfliction.bat`），放在了`tools`目录下，你直接运行一下就可以了。</strong>如果你找不到这个文件，可以在这里下载：[CBJQ_KickoffWorldwideServerConfigConfliction.bat](https://gist.github.com/LiuJiewenTT/e3a346c4458012416ea7d182ded7c82c#file-cbjq_kickoffworldwideserverconfigconfliction-bat)，或从以下代码块中复制：

<script src="https://gist.github.com/LiuJiewenTT/e3a346c4458012416ea7d182ded7c82c.js"></script>

冲突相关信息可见上述“冲突的主要成因”部分。如果想要更详细的信息，不妨了解一下我探索求解的日志：[国际服兼容研究](docs/国际服兼容研究/国际服兼容研究.md)。


### 怎么localization？

如果你说的是切服器的本地化，那么这是`LANG`或`mLANG`环境变量到`en`；如果你说的是游戏本体的，那么就是另一回事了，和本切服器无关。（不建议修改游戏本体的本地化，但如果想要学习和研究，可以参考这两个项目：[PC端的本地化测试工具](https://github.com/LiuJiewenTT/CBJQ_XiaoKaiGuan)、[安卓端的本地化测试工具-PC平台](https://github.com/LiuJiewenTT/CBJQ_HugFenny-PC)、[安卓端的本地化测试工具-安卓平台](https://github.com/LiuJiewenTT/CBJQ_HugFenny)）。
