#ifndef JAGGED_ARRAY_H
#define JAGGED_ARRAY_H

#include <stddef.h>

// 锯齿数组类型定义
template <typename T>
struct JaggedArray{
    T **data;
    size_t *row_lengths;
    size_t row_count;
};
// template <typename T>
// typedef struct JaggedArray<T> JaggedArray<T>;

// 创建锯齿数组
template <typename T>
JaggedArray<T>* create_jagged_array(size_t row_count, const size_t *row_lengths);

// 创建空锯齿数组
#define create_empty_jagged_array(T) malloc(sizeof(JaggedArray<T>))

// 初始化锯齿数组
template <typename T>
void initialize_jagged_array(JaggedArray<T> *array);

// 添加数组空行元素
template <typename T>
int append_empty_row_element(JaggedArray<T> *array);

// 添加数组行元素
template <typename T>
int append_row_element(JaggedArray<T> *array, T *row, int row_length);

// 访问数组元素
// 获取数组元素
template <typename T>
T get_element(const JaggedArray<T> *array, size_t row, size_t col);
// 设置数组元素
template <typename T>
void set_element(JaggedArray<T> *array, size_t row, size_t col, T value);

// 销毁锯齿数组
template <typename T>
void destroy_jagged_array(JaggedArray<T> *array);

#include "jagged_array.tpp"

#endif // JAGGED_ARRAY_H
