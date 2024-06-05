#ifndef JAGGED_ARRAY_H
#define JAGGED_ARRAY_H

#include <stddef.h>

// 锯齿数组类型定义
typedef struct {
    int **data;
    size_t *row_lengths;
    size_t row_count;
} JaggedArray;

// 创建锯齿数组
JaggedArray* create_jagged_array(size_t row_count, const size_t *row_lengths);

// 创建空锯齿数组
#define create_empty_jagged_array() malloc(sizeof(JaggedArray))

// 初始化锯齿数组
void initialize_jagged_array(JaggedArray *array);

// 添加数组空行元素
int append_empty_row_element(JaggedArray *array);

// 添加数组行元素
int append_row_element(JaggedArray *array, int *row, int row_length);

// 访问数组元素
int get_element(const JaggedArray *array, size_t row, size_t col);
void set_element(JaggedArray *array, size_t row, size_t col, int value);

// 销毁锯齿数组
void destroy_jagged_array(JaggedArray *array);

#endif // JAGGED_ARRAY_H
