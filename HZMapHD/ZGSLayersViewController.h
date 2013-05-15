//
//  ZGSLayersViewController.h
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIFolderTableView;
@interface ZGSLayersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *layers;
@property (weak, nonatomic) IBOutlet UIFolderTableView *tableView;


@end
