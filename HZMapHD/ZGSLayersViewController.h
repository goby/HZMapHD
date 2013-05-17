//
//  ZGSLayersViewController.h
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIFolderTableView;
@protocol ZGSLayersDelegate;

@interface ZGSLayersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *layers;
@property (strong, nonatomic) NSArray *selectedLayers;
@property (weak, nonatomic) id<ZGSLayersDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIFolderTableView *tableView;


@end


@protocol ZGSLayersDelegate <NSObject>

@optional
-(void)layerView:(ZGSLayersViewController *)viewController selected:(NSArray *) selectedLayers;

@end