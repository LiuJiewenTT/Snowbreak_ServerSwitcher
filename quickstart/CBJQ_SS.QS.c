#include <windows.h>
#define UNICODE
#define _UNICODE
#include <locale.h>

#include <stdio.h>
#include <io.h>
#include <string.h>
#include <utils/cJSON/cJSON.h>
#define TEMPSTR_LENGTH 2048
#define TEMPWSTR_LENGTH 2048


wchar_t *convertCharToWChar(const char* message){
    // 将 char 字符串转换为 wchar_t 字符串
    int len = MultiByteToWideChar(CP_UTF8, 0, message, -1, NULL, 0);
    wchar_t* wMessage = (wchar_t*)malloc(len * sizeof(wchar_t));
    MultiByteToWideChar(CP_UTF8, 0, message, -1, wMessage, len);
    return wMessage;
}
#define WCharChar(x) (convertCharToWChar(x))

#define free2NULL(x) free(x);x=NULL;


char path_delimeter = '\\';
char program_name[2048];
char program_name_noext[2048];
char internal_program_name[2048] = {"CBJQ_SS.QS Core"};
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
        sprintf(tempstr1, "错误：程序文件名不符合要求，应以\"%s\"起始。", valid_server_filename_prefix);
        printf("%s\n", tempstr1);
        // swprintf(tempwstr1, MultiByteToWideChar(CP_UTF8, 0, tempstr1, -1, NULL, 0), L"%s", tempstr1);
        pw1 = WCharChar(tempstr1);
        pw2 = WCharChar(internal_program_name);
        MessageBoxW(hwnd, (pw1), (pw2), MB_OK);
        free2NULL(pw1);
        free2NULL(pw2);
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
        sprintf(tempstr1, "错误：程序文件名内不含server指示信息。");
        printf("%s\n", tempstr1);
        // swprintf(tempwstr1, MultiByteToWideChar(CP_UTF8, 0, tempstr1, -1, NULL, 0), L"%s", tempstr1);
        pw1 = WCharChar(tempstr1);
        pw2 = WCharChar(internal_program_name);
        MessageBoxW(hwnd, (pw1), (pw2), MB_OK);
        free2NULL(pw1);
        free2NULL(pw2);
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
        cjson_root1 =  createConfig();
        memset(config_content, 0, config_content_maxsize);
        sprintf(config_content, "%s\n\0", cJSON_Print(cjson_root1));
        // strcpy(config_content, cJSON_Print(cjson_root1));
        printf("%d\n", ftell(f1));
        printf("%d\n", strlen(config_content));
        config_content[strlen(config_content)] = 0;
        config_content[strlen(config_content)+1] = 0;
        config_content[strlen(config_content)+2] = 0;
        config_content[strlen(config_content)+3] = 0;
        config_content[strlen(config_content)+4] = 0;
        // memset(config_content+strlen(config_content), 0, config_content_maxsize-strlen(config_content));
        fflush(f1);
        fprintf_s(f1, "%s", config_content);
        fflush(f1);
        // fprintf(f1, "a");
        printf("%d\n", ftell(f1));

        fseek(f1, 0, SEEK_END);
        printf("%d\n", ftell(f1));
        fseek(f1, 0, SEEK_SET);
        printf("config_content:\n==%s=%d=\n", config_content, strlen(config_content));
        fclose(f1);
        cJSON_Delete(cjson_root1);
    }
    // 读取配置信息。
    f1 = fopen(config_filename, "r");
    if( f1 == NULL ){
        printf("配置文件打开失败。\n");
        return 0;
    }
    memset(config_content, 0, config_content_maxsize);
    // fread(config_content, sizeof(char), config_content_maxsize, f1);
    // fread(config_content, sizeof(char), 4095, f1);  // 4K 出问题。
    // fread(config_content, config_content_maxsize, 1, f1);
    fread(config_content, 4095, 1, f1);     // 4K 出问题。
    // fread(config_content, sizeof(char), 200, f1);
    if(feof(f1)){
        printf("eof:%d\n", ftell(f1));
    }
    printf("config_content:\n===%s=%d==\n", config_content, strlen(config_content));
    fseek(f1, -4, SEEK_END);
    memset(config_content, 0, config_content_maxsize);
    fread(config_content, sizeof(char), config_content_maxsize, f1);
    printf("config_content:\n==%s=%d=\n", config_content+3, strlen(config_content));
    fseek(f1, 0, SEEK_END);
    printf("%d", ftell(f1));
    fseek(f1, 0, SEEK_SET);
    cjson_root1 = cJSON_Parse(config_content);
    if( cjson_root1 == NULL ){
        printf("错误：配置解析失败。\n");
    }
    fclose(f1);

    // 这里是看起来没问题，但是写进文件里就发现strlen和ftell的结果插值与换行的次数总是对得上。
    printf("CRLF=%d\n", strlen("\n\r"));
    printf("CR=%d\n", strlen("\n"));
    printf("LF=%d\n", strlen("\r"));

    return 0;
}


cJSON *createConfig(){
    cJSON *root = cJSON_CreateObject();

    cJSON_AddStringToObject(root, "server_nickname", server_name);
    cJSON_AddStringToObject(root, "start_option_str", default_start_option_str);
    cJSON_AddStringToObject(root, "path_of_main", default_path_of_main);
    
    return root;
}
