#define UNICODE
#define _UNICODE
#include <windows.h>
#include <unistd.h>
#include <locale.h>

#include <stdio.h>
#include <io.h>
#include <string.h>
#include "utils/utils.h"
#include "utils/cJSON/cJSON.h"
#define TEMPSTR_LENGTH 2048
#define TEMPWSTR_LENGTH 2048


char path_delimeter = '\\';
char program_name[2048];
char program_name_noext[2048];
char internal_program_name[2048] = {"CBJQ_SS.QS Core"};
wchar_t internal_program_name_wstr[2048] = {L"CBJQ_SS.QS Core"};
char server_name[2048];
int server_name_length = 0;
char valid_server_filename_prefix[2048] = {"CBJQ_SS.QS."};
int valid_server_filename_prefix_length = 0;
char config_filename[2048];
char config_filename_suffix[] = {".config.json"};
const int config_content_maxsize = 512000;
const char default_start_option_str[] = {"-nopause"};
const char default_path_of_main[] = {".\\CBJQ_SS.main.bat"};


cJSON *createConfig();


int main(int argc, char **argv){
    HWND hwnd = GetConsoleWindow();
    SetConsoleOutputCP(CP_UTF8);
    setlocale(LC_CTYPE, "zh_cn.UTF-8");
    // ShowWindow(hwnd, SW_HIDE);
    // Sleep(3000);
    
    char config_content[config_content_maxsize];    // 512 KB
    char backend_path[2048];
    JaggedArray *executeCmd_args = NULL;
    char executeCmd[2048];

    char *p1 = NULL;
    char tempstr1[TEMPSTR_LENGTH];
    wchar_t tempwstr1[TEMPWSTR_LENGTH];
    wchar_t *pw1 = NULL, 
            *pw2 = NULL;
    FILE *f1 = NULL,
         *f2 = NULL;
    cJSON *cjson_root1 = NULL;
    int val1 = 0;

    printf("cmd=%s\n", argv[0]);
    
    // 获取程序文件名。
    p1 = strrchr(argv[0], path_delimeter);
    if( p1 == NULL ){
        strcpy(program_name, argv[0]);
    }
    else {
        strcpy(program_name, p1+1);
    }
    printf("program_name=%s\n", program_name);
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
    memset(executeCmd, 0, sizeof(executeCmd)*1.0/sizeof(char));

    cJSON *cjson_main = cJSON_GetObjectItem(cjson_root1, "path_of_main");
    strncpy(backend_path, cJSON_GetStringValue(cjson_main), sizeof(backend_path)*1.0/sizeof(char));
    
    executeCmd_args = create_empty_jagged_array();
    append_row_element(executeCmd_args, )

    return 0;
}


cJSON *createConfig(){
    cJSON *root = cJSON_CreateObject();

    cJSON_AddStringToObject(root, "server_nickname", server_name);
    cJSON_AddStringToObject(root, "start_option_str", default_start_option_str);
    cJSON_AddStringToObject(root, "path_of_main", default_path_of_main);
    
    return root;
}
