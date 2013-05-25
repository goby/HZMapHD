//
//  ZGSDownloadLayersViewController.h
//  HZMapHD
//
//  Created by zjugis on 13-5-19.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZGSDownloadLayersDelegate;
@interface ZGSDownloadLayersViewController : UITableViewController 

@property (weak, nonatomic) id<ZGSDownloadLayersDelegate> delegate;

- (IBAction)cancelDownload:(UIBarButtonItem *)sender;
- (IBAction)doneDownload:(id)sender;

@end


@protocol ZGSDownloadLayersDelegate <NSObject>

@optional
-(void)downloader:(ZGSDownloadLayersViewController *) downloader closeWithAnimated:(BOOL) animated;
-(void)downloader:(ZGSDownloadLayersViewController *) downloader doneWithAnimated:(BOOL) animated;

@end
