#include "jagged_array.h"
#include <stdlib.h>
#include <stdio.h>

// 创建锯齿数组
JaggedArray* create_jagged_array(size_t row_count, const size_t *row_lengths) {
    JaggedArray *array = malloc(sizeof(JaggedArray));
    if (!array) return NULL;

    array->data = malloc(row_count * sizeof(int*));
    array->row_lengths = malloc(row_count * sizeof(size_t));
    array->row_count = row_count;

    if (!array->data || !array->row_lengths) {
        free(array->data);
        free(array->row_lengths);
        free(array);
        return NULL;
    }

    for (size_t i = 0; i < row_count; i++) {
        array->row_lengths[i] = row_lengths[i];
        array->data[i] = malloc(row_lengths[i] * sizeof(int));
        if (!array->data[i]) {
            for (size_t j = 0; j < i; j++) {
                free(array->data[j]);
            }
            free(array->data);
            free(array->row_lengths);
            free(array);
            return NULL;
        }
    }

    return array;
}

// 初始化锯齿数组
void initialize_jagged_array(JaggedArray *array) {
    for (size_t i = 0; i < array->row_count; i++) {
        for (size_t j = 0; j < array->row_lengths[i]; j++) {
            array->data[i][j] = 0;  // 或者其他默认值
        }
    }
}

int append_empty_row_element(JaggedArray *array){
    size_t row_count = array->row_count + 1;
    void *p = NULL;
    p = realloc(array->data, row_count * sizeof(int*));
    if( !p ){
        return 0;
    }
    p = realloc(array->row_lengths, row_count * sizeof(size_t));
    if( !p ){
        return 0;
    }
    array = (JaggedArray *)p;
    array->row_count = row_count;
    array->data[row_count-1] = NULL;
    array->row_lengths[row_count-1] = 0;
    return 1;
}

int append_row_element(JaggedArray *array, int *row, int row_length){
    int retv = append_empty_row_element(array);
    if( !retv ){
        return retv;
    }
    array->data[array->row_count-1] = row;
    array->row_lengths[array->row_count-1] = row_length;
    return 1;
}

// 访问数组元素
int get_element(const JaggedArray *array, size_t row, size_t col) {
    if (row >= array->row_count || col >= array->row_lengths[row]) {
        fprintf(stderr, "Index out of bounds\n");
        exit(EXIT_FAILURE);
    }
    return array->data[row][col];
}

void set_element(JaggedArray *array, size_t row, size_t col, int value) {
    if (row >= array->row_count || col >= array->row_lengths[row]) {
        fprintf(stderr, "Index out of bounds\n");
        exit(EXIT_FAILURE);
    }
    array->data[row][col] = value;
}

// 销毁锯齿数组
void destroy_jagged_array(JaggedArray *array) {
    for (size_t i = 0; i < array->row_count; i++) {
        free(array->data[i]);
    }
    free(array->data);
    free(array->row_lengths);
    free(array);
}
