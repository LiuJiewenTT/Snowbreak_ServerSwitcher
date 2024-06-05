#define UNICODE
#define _UNICODE
#include <windows.h>
#include <unistd.h>
#include <locale.h>

#include <stdio.h>
#include <io.h>
#include <string.h>
#include "program_info.h"
#include "utils/utils.h"
// #include "utils/utils_cpp.h"
#include "utils/cJSON/cJSON.h"
#define TEMPSTR_LENGTH 2048
#define TEMPWSTR_LENGTH 2048

// 本页特设宏定义区
#define cjson_pcheck_IsNotString(x, exit_flag) \
    if(cjson_pcheck_judgeInvalidString(x)){\
        printf("Error: %s 的值不是合法字符串。\n", #x );\
        exit_flag=1;\
    }\


char path_delimeter = '\\';
char program_name[2048];
char program_name_noext[2048];
char program_working_dir[2048];
char internal_program_name[2048] = {INTERNAL_PROGRAM_NAME};
wchar_t internal_program_name_wstr[2048] = {TEXT(INTERNAL_PROGRAM_NAME)};
char server_name[2048];
int server_name_length = 0;
char valid_server_filename_prefix[2048] = {"CBJQ_SS.QS."};
int valid_server_filename_prefix_length = 0;
char config_filename[2048];
char config_filename_suffix[] = {".config.json"};
const int config_content_maxsize = 512000;
const char default_start_option_str[] = {"-nopause"};
const char default_path_of_main[] = {".\\CBJQ_SS.main.bat"};
char icon_path[2048];


// 创建配置
cJSON *createConfig();
// 收集配置
cJSON *collectConfig();
// 写入配置
int writeConfig(cJSON *config, const char *filename);
// 保存配置
int saveConfig();


int main(int argc, char **argv){
    char *p1 = NULL;
    char tempstr1[TEMPSTR_LENGTH];
    wchar_t tempwstr1[TEMPWSTR_LENGTH];
    wchar_t *pw1 = NULL, 
            *pw2 = NULL;
    FILE *f1 = NULL,
         *f2 = NULL;
    cJSON *cjson_root1 = NULL;
    int val1 = 0;

    HWND hwnd = GetConsoleWindow();
    SetConsoleOutputCP(CP_UTF8);
    setlocale(LC_CTYPE, "zh_cn.UTF-8");
    HICON hIcon = NULL;
    sprintf(tempstr1, "%s.hide", argv[0]);
    if( file_exists(tempstr1) ){
        ShowWindow(hwnd, SW_HIDE);
        sprintf(tempstr1, "%s.log", argv[0]);
        freopen(tempstr1, "w", stdout);
        printf("hide. [PID=%d].\n", getpid());
        // Sleep(3000);
    }

    char config_content[config_content_maxsize];    // 512 KB
    char backend_path[2048];
    char backend_path_abspath[2048];
    char start_options_str[2048];
    char executeCmd[2048];

    // 打印程序信息。
    #define temp_divider "####################################"
    printf("%s\n", temp_divider);
    printf("%s\nVersion: %s\nAuthor Name: %s\nAuthor Email: %s\n", PROGRAM_NAME_PRETTY, PROGRAM_VERSION, AUTHOR_NAME, AUTHOR_EMAIL);
    printf("%s\n", temp_divider);
    #undef temp_divider

    printf("cmd=%s\n", argv[0]);
    
    // 获取程序文件名。
    p1 = strrchr(argv[0], path_delimeter);
    if( p1 == NULL ){
        strcpy(program_name, argv[0]);
        sprintf(program_working_dir, ".\\");
    }
    else {
        strcpy(program_name, p1+1);
        strncpy(program_working_dir, argv[0], p1-argv[0]);
        program_working_dir[p1-argv[0]] = 0;
    }
    printf("program_name=%s\n", program_name);
    
    // 检查程序文件名。
    valid_server_filename_prefix_length = strlen(valid_server_filename_prefix);
    val1 = strncmp(program_name, valid_server_filename_prefix, valid_server_filename_prefix_length);
    if( val1 != 0 ){
        swprintf(tempwstr1, TEMPWSTR_LENGTH, L"错误：程序文件名不符合要求，应以\"%s\"起始。", valid_server_filename_prefix);
        printf("%ls\n", tempwstr1);
        MessageBox(hwnd, (tempwstr1), (internal_program_name_wstr), MB_OK);
        return 0;
    }

    // 查找server指示信息。
    p1 = strrchr(program_name, '.');
    if( p1 == NULL ){
        printf("Cannot find character '.'.\n");
        return 0;
    }
    server_name_length = (p1-program_name)-valid_server_filename_prefix_length;
    printf("server_name_length=%d\n", server_name_length);
    if( server_name_length <= 0 ){
        swprintf(tempwstr1, TEMPWSTR_LENGTH, L"错误：程序文件名内不含server指示信息。");
        printf("%ls\n", tempwstr1);
        MessageBox(hwnd, (tempwstr1), (internal_program_name_wstr), MB_OK);
        return 0;
    }
    strncpy(program_name_noext, program_name, p1-program_name);
    program_name_noext[p1-program_name] = 0;
    strncpy(server_name, program_name + valid_server_filename_prefix_length, server_name_length);
    server_name[server_name_length] = 0;
    printf("server_name=%s\n", server_name);
    
    // 检查配置文件。
    sprintf(config_filename, "%s%s", program_name_noext, config_filename_suffix);
    if( access(config_filename, 0|2|4) ){
        printf("不存在(可读取、写入的)配置文件。\n");
        f1 = fopen(config_filename, "w");
        if( f1 == NULL ){
            printf("配置文件创建失败。\n");
            return 0;
        }
        // 创建并写入配置信息。
        cjson_root1 =  createConfig();
        memset(config_content, 0, config_content_maxsize);
        sprintf(config_content, "%s", cJSON_Print(cjson_root1));
        // strcpy(config_content, cJSON_Print(cjson_root1));
        fprintf_s(f1, "%s", config_content);
        printf("config_content(%d):\n===%s===\n", strlen(config_content), config_content);
        fclose(f1);
        cJSON_Delete(cjson_root1);
    }
    // 读取配置信息。
    f1 = fopen(config_filename, "rb");
    if( f1 == NULL ){
        printf("配置文件打开失败。\n");
        return 0;
    }
    memset(config_content, 0, config_content_maxsize);
    fread(config_content, sizeof(char), config_content_maxsize, f1);
    printf("config_content(%d):\n===%s===\n", strlen(config_content), config_content);
    cjson_root1 = cJSON_Parse(config_content);
    if( cjson_root1 == NULL ){
        swprintf(tempwstr1, TEMPWSTR_LENGTH, L"错误：配置解析失败。");
        printf("%ls\n", tempwstr1);
        fclose(f1);
        MessageBox(hwnd, (tempwstr1), (internal_program_name_wstr), MB_OK);
        return 0;
    }
    fclose(f1);
    
    memset(backend_path, 0, sizeof(backend_path)*1.0/sizeof(char));
    memset(backend_path_abspath, 0, sizeof(backend_path_abspath)*1.0/sizeof(char));
    memset(executeCmd, 0, sizeof(executeCmd)*1.0/sizeof(char));

    // 获取json参数
    int exit_flag1 = 0;
    cJSON *cjson_main = cJSON_GetObjectItem(cjson_root1, "path_of_main");
    cjson_pcheck_IsNotString(cjson_main, exit_flag1) else {
        strncpy(backend_path, cJSON_GetStringValue(cjson_main), sizeof(backend_path)*1.0/sizeof(char));
        printf("backend_path=%s\n", backend_path);
    }
    cJSON *cjson_startOptions = cJSON_GetObjectItem(cjson_root1, "start_option_str");
    cjson_pcheck_IsNotString(cjson_startOptions, exit_flag1) else {
        strncpy(start_options_str, cJSON_GetStringValue(cjson_startOptions), sizeof(start_options_str)*1.0/sizeof(char));
        printf("start_options_str=%s\n", start_options_str);
    }
    cJSON *cjson_serverName = cJSON_GetObjectItem(cjson_root1, "server_nickname");
    cjson_pcheck_IsNotString(cjson_serverName, exit_flag1) else {
        strncpy(server_name, cJSON_GetStringValue(cjson_serverName), sizeof(server_name)*1.0/sizeof(char));
        printf("server_name=%s\n", server_name);
    }
    cJSON *cjson_icon = cJSON_GetObjectItem(cjson_root1, "icon");
    
    // 补充并更新配置，随后退出。
    if(exit_flag1){
        saveConfig();
        return EXIT_FAILURE;
    }

    if( !cjson_pcheck_judgeInvalidString(cjson_icon) ){        
        strncpy(icon_path, cJSON_GetStringValue(cjson_icon), sizeof(icon_path)*1.0/sizeof(char));
        printf("icon_path=%s\n", icon_path);
        // 加载并设置图标
        swprintf(tempwstr1, TEMPWSTR_LENGTH, L"%hs", icon_path);
        hIcon = (HICON)LoadImage(NULL, tempwstr1, IMAGE_ICON, 0, 0, LR_LOADFROMFILE); 
        // 图标加载失败处理
        if (hIcon == NULL) {
            swprintf(tempwstr1, TEMPWSTR_LENGTH, L"Error: Failed to load icon from file!\nIcon File: %hs", icon_path);
            printf("%ls\n", tempwstr1);
            MessageBox(hwnd, tempwstr1, internal_program_name_wstr, MB_ICONERROR);
            // return EXIT_FAILURE;
        }
        else {
            // 设置图标
            SendMessage(hwnd, WM_SETICON, ICON_BIG, (LPARAM)hIcon);
            SendMessage(hwnd, WM_SETICON, ICON_SMALL, (LPARAM)hIcon);
            SendMessage(hwnd, WM_SETICON, ICON_SMALL2, (LPARAM)hIcon);
            // 释放图标句柄
            DestroyIcon(hIcon);
            // system("pause");
        }        
    }

    // 处理路径
    p1 = _fullpath(backend_path_abspath, backend_path, 2048);
    if( p1 ==NULL ){
        swprintf(tempwstr1, TEMPWSTR_LENGTH, L"错误：绝对路径推算失败。");
        printf("%ls\n", tempwstr1);
        MessageBox(hwnd, (tempwstr1), (internal_program_name_wstr), MB_OK);
        return 0;
    }
    printf("backend_path_abspath=%s\n", backend_path_abspath);
    
    // 启动！
    printf("启动！\n");
    fflush(stdout);
    // execlp("cmd", "/C", backend_path_abspath, start_options_str, server_name);
    spawnlp(_P_WAIT, "cmd", "/C", backend_path_abspath, start_options_str, server_name, NULL);

    return 0;
}


cJSON *createConfig(){
    cJSON *root = cJSON_CreateObject();

    cJSON_AddStringToObject(root, "server_nickname", server_name);
    cJSON_AddStringToObject(root, "start_option_str", default_start_option_str);
    cJSON_AddStringToObject(root, "path_of_main", default_path_of_main);
    cJSON_AddNullToObject(root, "icon");

    return root;
}


cJSON *collectConfig(){
    cJSON *root = cJSON_CreateObject();
    cJSON_AddStringToObject(root, "server_nickname", server_name);
    cJSON_AddStringToObject(root, "start_option_str", default_start_option_str);
    cJSON_AddStringToObject(root, "path_of_main", default_path_of_main);
    if( icon_path[0] ){
        cJSON_AddStringToObject(root, "icon", icon_path);
    }
    else {
        cJSON_AddNullToObject(root, "icon");
    }
    return root;
}


int writeConfig(cJSON *config, const char *filename){
    FILE *f = fopen(filename, "w");
    if( f == NULL ) return 0;
    fprintf(f, "%s", cJSON_Print(config));
    fclose(f);
    return 1;
}


int saveConfig() {
    int retv = 0;
    cJSON *config = collectConfig();
    retv = writeConfig(config, config_filename);
    cJSON_Delete(config);
    return retv;
}
