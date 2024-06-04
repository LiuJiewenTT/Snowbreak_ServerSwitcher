#include <windows.h>
#define UNICODE
#define _UNICODE

#include <stdio.h>
#include <string.h>
#define TEMPSTR_LENGTH 2048
#define TEMPWSTR_LENGTH 2048


wchar_t *convertCharToWChar(const char* message){
    // 将 char 字符串转换为 wchar_t 字符串
    int len = MultiByteToWideChar(CP_ACP, 0, message, -1, NULL, 0);
    wchar_t* wMessage = (wchar_t*)malloc(len * sizeof(wchar_t));
    MultiByteToWideChar(CP_ACP, 0, message, -1, wMessage, len);
    return wMessage;
}
#define WCharChar(x) (convertCharToWChar(x))

int main(int argc, char **argv){
    HWND hwnd = GetConsoleWindow();
    SetConsoleOutputCP(CP_UTF8);
    // ShowWindow(hwnd, SW_HIDE);
    // Sleep(3000);
    char path_delimeter = '\\';
    char program_name[2048];
    char internal_program_name[2048] = {"CBJQ_SS.QS Core"};
    char server_name[2048];
    int server_name_length = 0;
    char valid_server_filename_prefix[2048] = {"CBJQ_SS.QS."};
    int valid_server_filename_prefix_length = 0;
    char *p1 = NULL;
    char tempstr1[TEMPSTR_LENGTH];
    wchar_t tempwstr1[TEMPWSTR_LENGTH];
    int val1 = 0;

    printf("cmd=%s\n", argv[0]);
    
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
        MessageBox(hwnd, (tempstr1), (internal_program_name), MB_OK);
        return 0;
    }
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
        // swprintf(tempwstr1, "%s", tempstr1);
        MessageBox(hwnd, (tempstr1), (internal_program_name), MB_OK);
        return 0;
    }
    strncpy(server_name, program_name + valid_server_filename_prefix_length, (p1-program_name)-valid_server_filename_prefix_length);
    printf("server_name=%s\n", server_name);
    return 0;
}
