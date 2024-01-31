---
LANG: zh_CN.UTF-8
date: 2024-01-31 14:48:00 +0800
---


# 《尘白禁区》服务器切换器

简介：此程序用于切换不同渠道的启动器，以连接到不同的《尘白禁区》服务器。

快速跳转：[使用](#使用), [配置方法](#配置方法), [GUI](#guis).

![icon](icon1.png)

项目地址：<https://github.com/LiuJiewenTT/Snowbreak_ServerSwitcher>
说明页链接：<https://liujiewentt.github.io/Snowbreak_ServerSwitcher/README>

## 痛点

不知道启动器更新的方式，担心不同渠道的启动器混乱。

## 可行性分析

已知：

1. 启动器名称没有任何影响，可以自己修改，不同启动器可以共存。
2. 官服和B服共用相同的数据，仅启动器不同。
3. 已有工具基于以上原理实现了切换。
4. 符号链接通常对程序透明。

故：

1. 可以使用符号链接实现共存和替换。
2. 基本不会有影响启动器更新时文件名对应关系的可能。也就是说，不会乱覆盖，也不用自己手动重命名，不会有这种需求的可能。

## 优势

在2023年7月开服时，已经有人用易语言制作了一个启动器。

后来，西山居更新了启动器（发布1.1版本“夏日过年”时），这意味着各个渠道的启动器都要更新。

由于不清楚软件实现，不清楚软件特性，也没有观察过当时更新的过程（本人那时只玩一个渠道），本人也无法确保会不会保留自己改的文件名，故决定使用符号链接。

> 使用符号链接的好处在于，如果直接访问，那么链接是透明的，程序无感访问真实文件（除非有特殊判定）。还有一个好处在于，如果是使用删除和移动缓存的新文件过来，也不影响任何东西，不需要重命名。

本程序使用Windows系统下运行于`cmd.exe`（命令提示符）的`.bat`批处理脚本实现。代码开放，完全开源，安全可查。

> - 非易语言程序，不会被杀毒软件误杀（360，仅未知程序运行提醒），放心使用。
> - 非powershell脚本(.ps1)，没有麻烦。
> - 没有高危操作，不需要管理员权限启动。

> 如果不放心担心被其它程序或其它人修改程序产生不良影响，可以在【属性】->【安全】删除普通用户“写入”权限、保留“执行”权限。

<strong style= "color:red"> 此外，在游戏目录内（启动器原始位置），不同渠道的启动器可以共用相同的文件名。</strong>也就是说，如果你不是一起开那么一个桌面快捷方式就足够了。（此时也不用担心更新可能出现混乱导致快捷方式或是其它程序（如，Razor Cortex）出现路径错误。）

当然，如果你就是要多个一起开，那，如果可以的话，本程序也可以通过修改配置满足你。

> 具体什么问题可以联系作者，有空会协助解决。

## 备注

1. 本程序在设计时考虑到了一些“安全”方面的问题，比如：
   1. 切换启动器时（删除旧链接创建新链接）保证真正的启动器（可能是更新后的，从符号链接变回普通文件（程序）的启动器）**不会被错删**。
2. 支持中文（保证不乱码）和英文。（Support zh_CN and en_US.）

## 使用

> 首次启动前需要完成配置，具体看[下一部分](#配置方法)说明。

### 注意事项

*补充说明：请确保真正的启动器所在目录下有`preference.json`文件，如果没有这个文件，启动器会以为是第一次运行，进而无法定位到正确的游戏数据目录。*

运行环境注意（普通玩家）
1. 使用前请确认“用户变量设定区”的已经设置好了启动器路径。
2. 除了“用户变量设定区”，其它都不要动。
3. 请确保路径中不包含这些符号：“`[` `]`”

运行环境注意（高级玩家）
1. 从Powershell启动可能会存在`LANG`环境变量，程序将优先从`LANG`选择`mLANG`缺省值。
2. 启动参数必须选项在前服务器在后，指定多个服务器会依次触发操作。
3. 上部分第三点具体说明：目的路径字符串不得包含启动器储存路径字符串。

完成配置后，可使用[<strong style="color:red">GUI</strong>](#guis)进行操作。

### 参数

**启动参数必须选项在前服务器在后，指定多个服务器会依次触发操作。**

1. `-nopause`：从命令行启动可以指定该参数，使得程序结束时不暂停。
2. **`-nostart`**：仅切换启动器，不顺带启动程序。

程序已经根据当前情况预设好了三种服务器（名）：

1. `worldwide`：国际服
2. `bilibili`：B服
3. `kingsoft`（金山）：官服

例1：

``` bat
CBJQ_SS.main bilibili
```

例2：

``` bat
CBJQ_SS.main.bat bilibili
```

例3：

``` bat
CBJQ_SS.main.bat -nostart bilibili
```

例4：

``` bat
CBJQ_SS.main.bat -nostart -nopause bilibili
```

例5：

``` bat
CBJQ_SS.main.bat -nostart -nopause bilibili kingsoft worldwide
```

## 配置方法

> 请按照[注意事项](#注意事项)和脚本内的说明进行配置。

**请在安装好一个版本后开始配置**。

> 以下为示例，看得懂的可以自行配置。

1. 选择一个位置，比如启动器所在的位置。例如：`M:\Program Files\Snow\`。

2. 将发行的压缩包内的文件夹`Snowbreak_ServerSwitcher`解压到这个位置。

3. 把原启动器拖入：`Snowbreak_ServerSwitcher\Launchers\`文件夹内。

4. 把原启动器所在目录下的`preference.json`复制到启动器新位置。

   > 补充说明：请确保真正的启动器所在目录下有`preference.json`文件，如果没有这个文件，启动器会以为是第一次运行，进而无法定位到正确的游戏数据目录。

5. 把你要的其它渠道的安装包（如：`CBJQ_Setup.exe`）用解压软件打开，打开`app.7z`（压缩包内的压缩包）。

6. 将里面的启动器复制到刚才那个启动器的新位置去，把它们放到一起（同一目录）。

7. 给不同启动器重命名。

8. 来到脚本`Snowbreak_ServerSwitcher\CBJQ_SS.main.bat`中的“用户变量设定区”，设置说明了的*6个*变量。（没有就设为`%launcher_none%`）

   > `launcher_worldwide`, `launcher_bilibili`, `launcher_kingsoft`；（没有就设为`%launcher_none%`）
   > `launcher_worldwide_dest`, `launcher_bilibili_dest`, `launcher_kingsoft_dest`。（目的位置，就是原本应该在的路径）

   **首尾不要有多余的空格！**示例：

   ``` bat
   @set launcher_worldwide=%~dp0Launchers\snow_launcher-worldwide.exe
   @set launcher_bilibili=%~dp0Launchers\snow_launcher-bilibili.exe
   @set launcher_kingsoft=%~dp0Launchers\snow_launcher-kingsoft.exe
   
   @set launcher_worldwide_dest=..\snow_launcher.exe
   @set launcher_bilibili_dest=..\snow_launcher.exe
   @set launcher_kingsoft_dest=..\snow_launcher.exe
   ```

   不会改参数就按这里的命名，然后复制这一段将对应代码替换。

9. 使用命令行按照上述参数示例启动/切换启动器；或使用[<strong style="color:red">GUI</strong>](#guis)操作。

   > 也可以用配置好的几个文件，给这几个文件创好桌面快捷方式，然后双击启动：
   >
   > - 切换+启动：`尘白禁区**（切换+启动）.bat`
   > - 仅切换，不自动启动：`尘白禁区**（切换）.bat`

## GUIs

可用GUI程序：

1. 项目：[CBJQ_SS_FrontEnd-tk](https://github.com/LiuJiewenTT/CBJQ_SS_FrontEnd-tk)。

## LICENSE

本项目遵循MIT开源协议。

本项目内置[`IconFold` `v1.0.0`](https://github.com/LiuJiewenTT/IconFold) （MIT开源协议）实现文件夹图标的设置。可以删除tools文件夹。

