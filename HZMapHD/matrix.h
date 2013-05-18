//
//  matrix.h
//  HZMapHD
//
//  Created by zjugis on 13-5-18.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#ifndef HZMapHD_matrix_h
#define HZMapHD_matrix_h

typedef enum {
    MatrixAdd,
    MatrixMinus
} MATRIX_OPERATOR;

int matrix_invert(double *matrix, int N);
int matrix_multiply(double *a, double *b, double *result,int M, int K, int N);
int matrix_transpose(double *matrix, int N);
int matrix_add(double *a, double *b, double *result, int M, int N, MATRIX_OPERATOR add);
#endif
