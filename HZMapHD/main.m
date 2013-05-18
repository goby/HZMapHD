//
//  main.m
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZGSAppDelegate.h"
#include "matrix.h"

void print(double *matrix, int N);

int main(int argc, char *argv[]) {
    int N = 3;
    double A[N * N], D[N * N],
    B[] = { 1, 3, 2,
        1, 0, 0,
        1, 2, 2 },
    C[] = { 0, 0, 2,
        7, 5, 0,
        2, 1, 1 };
    A[0] = 1; A[1] = 1; A[2] = 7;
    A[3] = 1; A[4] = 2; A[5] = 1;
    A[6] = 1; A[7] = 1; A[8] = 3;
    matrix_invert(A, N);
    
    print(A, N);
    
    //        [ -1.25  -1.0   3.25 ]
    // A^-1 = [  0.5    1.0  -1.5  ]
    //        [  0.25   0.0  -0.25 ]
    
    matrix_multiply(B, C, D, N, N, N);
    
    print(D, N);
        
    matrix_add(B, C, D, N, N, MatrixAdd);
    
    print(D, N);
    
    matrix_add(B, C, D, N, N, MatrixMinus);
    
    print(D, N);
    
    matrix_transpose(B, N);

    print(B, N);
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([ZGSAppDelegate class]));
    }
}

void print(double *matrix, int N){
    int i , j;
    for (i = 0; i < N; i++) {
        for (j = 0;  j< N; j++) {
            printf("%.2f\t", matrix[i * N + j]);
        }
        printf("\n");
    }
}
