//
//  ZGSSubLayerViewController.h
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGSLayersViewController;

@interface ZGSSubLayersViewController : UIViewController

@property (strong, nonatomic) NSArray *subLayers;
@property (strong, nonatomic) NSArray *selectedLayers;
@property (strong, nonatomic) ZGSLayersViewController *layersViewController;

@end
