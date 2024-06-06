#ifndef PROGRAM_INFO_H
#define PROGRAM_INFO_H

#define INTERNAL_PROGRAM_NAME "CBJQ_SS.QS Core"
#define PROGRAM_NAME_PRETTY "CBJQ_SS QuickStart"
#define PROGRAM_VERSION "v1.0.0"
#define AUTHOR_NAME "LiuJiewenTT"
#define AUTHOR_EMAIL "liuljwtt@163.com"
#define BUILD_TIMEZONE "UTC+8"

#ifdef __GNUC__
    const char *get_gcc_version();
    const char *get_gcc_build_description();
    #define GCC_VERSION get_gcc_version()
    #define BUILD_DATE __DATE__
    #define BUILD_TIME __TIME__

    #define BUILDER "GNUC"
    #ifdef __cplusplus
    #define BUILDER_SPECIFIC "GNUC(G++)"
    #else
    #define BUILDER_SPECIFIC "GNUC(GCC)"
    #endif
    #define BUILD_DESCRIPTION get_gcc_build_description()
#else
    const char *get_build_description();
    #ifdef __DATE__
    #define BUILD_DATE __DATE__
    #else
    #define BUILD_DATE "Unknown"
    #endif

    #ifdef __TIME__
    #define BUILD_TIME __TIME__
    #else
    #define BUILD_TIME "Unknown"
    #endif

    #define BUILDER "Unknown"
    #define BUILD_DESCRIPTION get_build_description()
#endif

#endif  //  PROGRAM_INFO_H