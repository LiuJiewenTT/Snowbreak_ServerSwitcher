# IconFold
 A series of tools made for folders' icons. It's aimed to manage the icon used.
 
 This toolkit is made **for Windows** platform.

## Installation
 Thers is no need of installation. Just store these things in some place.

 There might be some EXE version. (That is, programs being packed into *.exe* files.)

## Using
 You should run in some terminal, like *cmd.exe* and *Power Shell*.
> You are ought to run in the location of the programs' directory. Otherwise the *res_ico* would be located at somewhere else.
> 
> You may ignore this notice if you are really sure about what you are doing and if it's up to your expectation. 

 Type "/?" as the only parameter to the program to see help message.

### General Options

| Option | Desc. |
|--------|-------|
| /?     | Show help message |
| /S     | Do with search. i.e. recursive. |
| /AICO  | Affect all icons  |

### File Desc.

#### Main programs

| Program | Desc. |
|---------|-------|
| apply_ico | Apply prepared resources the specific folder, or even the subfolders. |
| clean_ico | Clean the *.ini* and the corresponding, or all instead, *.ico* of some folders given.  |
| enable_ico | Enable the configuration existed. |
| disable_ico | Disable the configration existed. |

#### Assistant programs

| Program | Desc. |
|---------|-------|
| extract_command | Extract resouce from an already customized folder. |

#### res_ico

Files prepared in *res_ico* and *template_of_res_ico* are **hidden** by default. This is because the files are extracted from a folder customized by the tool of *icofx*.

To show them, change the settings of explorer.

To list the items, execute this command in the cmd (example):
``` shell
dir /A:A res_ico
```

To del the items, execute this command in the cmd (example):
``` shell
del /F /A:A res_ico\*
```

## License

**MIT**
