//
//  matrix.c
//  HZMapHD
//
//  Created by zjugis on 13-5-18.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#include "matrix.h"
#include <stdlib.h>
#include <Accelerate/Accelerate.h>
double parameters[7];
int matrix_invert(double *matrix, int N) {
    int error = 0;
    int *pivot = (int *)malloc(sizeof(int) * (N + 1));
    int LWORK = N * N;
    double *workspace = (double *)malloc(sizeof(double) * LWORK);
    
    dgetrf_(&N, &N, matrix, &N, pivot, &error);
    
    if (error != 0) {
        return error;
    }
    
    dgetri_(&N, matrix, &N, pivot, workspace, &LWORK, &error);
    
    free(pivot);
    free(workspace);
    
    return error;
}

int matrix_multiply(double *a, double *b, double *result, int M, int K, int N) {
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1,  a,  M, b, K, 1, result, M);
    return 0;
}

int matrix_transpose(double *matrix, int N) {
    int i, j;
    double tmp;
    for (i = 0; i < N; i++) {
        for (j = 0; j < i; j++) {
            tmp = matrix[i * N + j];
            matrix[i * N + j] = matrix[j * N + i];
            matrix[j * N + i] = tmp;
        }
    }
    return 0;
}

int matrix_add(double *a, double *b, double *result, int M, int N, MATRIX_OPERATOR add) {
    M = M * N;
    if (add == MatrixAdd) N = 1;
    else if (add == MatrixMinus) N = -1;
    else return -1;
    while (--M >= 0)
        result[M] = a[M] + b[M] * N;
    return 0;
}