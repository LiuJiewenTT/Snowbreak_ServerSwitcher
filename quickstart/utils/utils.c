#include "utils.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <windows.h>
#include <unistd.h>


int file_exists(const char *filename) {
    return access(filename, F_OK) != -1;
}


wchar_t *convertCharToWChar(const char* message){
    // 将 char 字符串转换为 wchar_t 字符串
    int len = MultiByteToWideChar(CP_UTF8, 0, message, -1, NULL, 0);
    wchar_t* wMessage = (wchar_t*)malloc(len * sizeof(wchar_t));
    MultiByteToWideChar(CP_UTF8, 0, message, -1, wMessage, len);
    return wMessage;
}


char* concatenateArgs(int argc, const char *argv[]) {
    // 计算所需的总长度
    size_t total_length = 0;
    for (int i = 0; i < argc; i++) {
        total_length += strlen(argv[i]) + 1; // +1 是为了空格或终止符
    }

    // 分配所需的内存
    char *result = malloc(total_length * sizeof(char));
    if (!result) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }

    // 初始化结果字符串
    result[0] = '\0';

    // 拼接每一个参数
    for (int i = 0; i < argc; i++) {
        strcat(result, argv[i]);
        if (i < argc - 1) {
            strcat(result, " ");
        }
    }

    return result;
}

