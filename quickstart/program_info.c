#include "program_info.h"
#include <stdio.h>

#ifdef __GNUC__

const char *get_gcc_version(){
    static char gcc_version[16]={""};
    if(!gcc_version[0]){
        snprintf(gcc_version, sizeof(gcc_version)*1.0/sizeof(char), "%d.%d.%d", __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
        gcc_version[15] = 0;
    }
    return (const char *)gcc_version;
}

const char *get_gcc_build_description(){
    static char gcc_build_description[2048]={""};
    if(!gcc_build_description[0]){
        snprintf(gcc_build_description, sizeof(gcc_build_description)*1.0/sizeof(char), 
        "Build with %s v%s\nBuild Date: %s\nBuild Time: %s", BUILDER_SPECIFIC, get_gcc_version(), BUILD_DATE, BUILD_TIME);
        gcc_build_description[2047] = 0;
    }
    return (const char *)gcc_build_description;
}

#else

const char *get_build_description(){
    static char build_description[2048]={""};
    if(!build_description[0]){
        snprintf(build_description, sizeof(build_description)*1.0/sizeof(char), 
        "Build with Unknown Compiler.\nBuild Date: %s\nBuild Time: %s", BUILD_DATE, BUILD_TIME);
        build_description[2047] = 0;
    }
    return (const char *)build_description;
}

#endif
