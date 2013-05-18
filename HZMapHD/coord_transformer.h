//
//  coord_transformer.h
//  HZMapHD
//
//  Created by zjugis on 13-5-18.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#ifndef HZMapHD_coord_transformer_h
#define HZMapHD_coord_transformer_h

typedef struct {
    double x;
    double y;
    double z;
} coord;

void wgs84_bj54(const coord* wgs84, coord* bj54);

#endif
