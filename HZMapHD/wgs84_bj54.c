//
//  wgs84_bj54.c
//  HZMapHD
//
//  Created by zjugis on 13-5-18.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#include <stdio.h>
#include <math.h>
#include <CoreGraphics/CoreGraphics.h>
#include "matrix.h"
#include "coord_transformer.h"

extern double parameters[7];

void wgs84_bj54(const coord* wgs84, coord* bj54){
    double result[3];
    double factor[] = {
        1, 0, 0, wgs84->x,         0, -wgs84->z,  wgs84->y,
        0, 1, 0, wgs84->y,  wgs84->z,         0, -wgs84->x,
        0, 0, 1, wgs84->z, -wgs84->y,  wgs84->x,         0 };
    matrix_multiply(factor, parameters, result, 3, 7, 1);
    bj54->x = result[0];
    bj54->y = result[1];
    bj54->z = result[2];
}
