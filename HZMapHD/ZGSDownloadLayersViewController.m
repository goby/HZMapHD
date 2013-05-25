//
//  ZGSDownloadLayersViewController.m
//  HZMapHD
//
//  Created by zjugis on 13-5-19.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import "ZGSDownloadLayersViewController.h"
#import "ZGSAppDelegate.h"
#import "AFDownloadRequestOperation.h"
#import "ZipArchive.h"

@interface ZGSDownloadLayersViewController () {
    NSArray *dataSource;
}
@end

@interface ZGSDownloadLayersCell : UITableViewCell<ZipArchiveDelegate> {
    AFDownloadRequestOperation *operation;
    UIColor *startColor;
    UIColor *pauseColor;
}

@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *subTitle;
@property (strong, nonatomic) UIProgressView *progress;
@property (strong, nonatomic) UIImageView *thumb;
@property (strong, nonatomic) UIButton *controlButton;
@property (copy, nonatomic)   NSString *url;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *currentSizeLabel;
@property (strong, nonatomic) UILabel *totalSizeLabel;

- (BOOL)checkLayerExist:(NSString *)layerPathName;

@end

@implementation ZGSDownloadLayersViewController
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"OfflineLayers" withExtension:@"plist"];
    dataSource = [NSArray arrayWithContentsOfURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ZGSDownloadLayersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZGSDownloadLayersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [dataSource objectAtIndex:indexPath.row];
    cell.name.text = [dict objectForKey:@"layername"];
    cell.subTitle.text = [dict objectForKey:@"description"];
    cell.tag = [[dict objectForKey:@"code"] intValue];
    cell.url = [dict objectForKey:@"url"];
    cell.progressLabel.text = [self checkCachesExist:cell.tag] ? @"100%" : @"0%";
    NSLog(@"%@", NSStringFromCGRect(cell.frame));
    return cell;
}

- (BOOL)checkCachesExist:(int)cacheCode {
    NSString *dir = [[ZGSAppDelegate offlineDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", cacheCode]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *dirs = [fileManager contentsOfDirectoryAtPath:dir error:&error];
    NSLog(@"Check Exist: %@", error);
    return (dirs != nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)cancelDownload:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(downloader:closeWithAnimated:)]) {
        [self.delegate downloader:self closeWithAnimated:YES];
    }
}

- (IBAction)doneDownload:(id)sender {
    if ([self.delegate respondsToSelector:@selector(downloader:doneWithAnimated:)]) {
        [self.delegate downloader:self doneWithAnimated:YES];
    }
}

@end


#pragma mark Cell implementation

@implementation ZGSDownloadLayersCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        startColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_download_start.png"]];
        pauseColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_download_pause.png"]];
        NSLog(@"%@", NSStringFromCGRect(self.frame));
        self.backgroundColor = [UIColor clearColor];
        self.thumb = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        self.thumb.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.thumb];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 260, 40)];
        self.name.font = [UIFont systemFontOfSize:25.0f];
        self.name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.name.backgroundColor = [UIColor clearColor];
        //self.name.textColor = [UIColor blackColor];
        self.name.opaque = NO;
        [self.contentView addSubview:self.name];
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(358, 15, 112, 40)];
        self.progressLabel.font = [UIFont systemFontOfSize:30.0f];
        //self.progressLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.progressLabel.textAlignment = NSTextAlignmentRight;
        self.progressLabel.backgroundColor = [UIColor clearColor];
        //self.name.textColor = [UIColor blackColor];
        self.progressLabel.opaque = NO;
        [self.contentView addSubview:self.progressLabel];
        
        self.subTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 360, 20)];
        self.subTitle.font = [UIFont systemFontOfSize:12.0f];
        self.subTitle.textColor = [UIColor colorWithRed:158 / 255.0
                                                  green:158 / 255.0
                                                   blue:158 / 255.0
                                                  alpha:1.0];
        self.subTitle.backgroundColor = [UIColor clearColor];
        self.subTitle.opaque = NO;
        [self.contentView addSubview:self.subTitle];
        
        self.controlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.controlButton.backgroundColor = startColor;
        self.controlButton.selected = NO;
        self.controlButton.frame = CGRectMake(470, 12, 59, 55);
        [self.controlButton addTarget:self action:@selector(controlButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.controlButton];
        
        self.progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progress.frame = CGRectMake(100, 60, 380, 20);
        [self.progress setHidden:YES];
        [self.contentView addSubview:self.progress];
    }
    return self;
}

- (void)controlButtonTap:(UIButton *)sender {
    if (self.controlButton.selected) {
        self.controlButton.backgroundColor = startColor;
        self.progress.hidden = NO;
        self.subTitle.hidden = YES;
        [self pause];
    } else {
        self.controlButton.backgroundColor = pauseColor;
        [self download];
    }
    
    self.controlButton.selected = !self.controlButton.selected;
}

- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
}

- (void)download {
    NSString *filename = [NSString stringWithFormat:@"%d.zip", self.tag];
    filename = [[ZGSAppDelegate offlineDirectory] stringByAppendingPathComponent:filename];
    NSString *file = [NSString stringWithFormat:@"%d", self.tag];
    file =[[ZGSAppDelegate offlineDirectory] stringByAppendingPathComponent:file];
    
    // Check offline package
    if ([self checkLayerExist:filename]) {
        self.progressLabel.text = @"100%";
        [self unZip:filename toPath:file];
    } else if (!operation) {
        self.progress.hidden = NO;
        self.subTitle.hidden = YES;
        
        NSURL *url = [NSURL URLWithString:self.url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
        operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:filename shouldResume:YES];
        __typeof(&*self) __weak weakself = self;
        __block UIColor *blockStartColor = startColor;
        operation.deleteTempFileOnCancel = YES;
        [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully downloaded file to %@", filename);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.controlButton.backgroundColor = blockStartColor;
                weakself.progress.hidden = YES;
                weakself.subTitle.hidden = NO;
            });
            
            [weakself unZip:filename toPath:file];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
            float percentDone = totalBytesReadForFile / (float)totalBytesExpectedToReadForFile;
            
            [weakself.progress setProgress:percentDone animated:YES];
            weakself.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", percentDone * 100];
            //
            //            self.currentSizeLabel.text = [NSString stringWithFormat:@"CUR : %lli M",totalBytesReadForFile/1024/1024];
            //            self.totalSizeLabel.text = [NSString stringWithFormat:@"TOTAL : %lli M",totalBytesExpectedToReadForFile/1024/1024];
            
            NSLog(@"------%f", percentDone);
            NSLog(@"Operation%i: bytesRead: %d", 1, bytesRead);
            NSLog(@"Operation%i: totalBytesRead: %lld", 1, totalBytesRead);
            NSLog(@"Operation%i: totalBytesExpected: %lld", 1, totalBytesExpected);
            NSLog(@"Operation%i: totalBytesReadForFile: %lld", 1, totalBytesReadForFile);
            NSLog(@"Operation%i: totalBytesExpectedToReadForFile: %lld", 1, totalBytesExpectedToReadForFile);
        }];
        [operation start];
    } else [operation resume];
}

- (BOOL)checkLayerExist:(NSString *)layerPathName {
    return [[NSFileManager defaultManager] fileExistsAtPath:layerPathName];
}

- (void)unZip:(NSString *)zipFile toPath:(NSString *)destination {
    [self makeToastActivity];
    __typeof(&*self) __weak weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        zipArchive.delegate = self;
        [zipArchive UnzipOpenFile:zipFile];
        [zipArchive UnzipFileTo:destination overWrite:YES];
        [zipArchive UnzipCloseFile];
        // Send to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.controlButton.backgroundColor = startColor;
            [weakSelf hideToastActivity];
            [[NSNotificationCenter defaultCenter] postNotificationName:ZGSBasemapDownloaded object:destination];
        });
    });
}

- (void)pause {
    [operation pause];
}

-(void)ErrorMessage:(NSString *)msg {
    NSLog(@"%@", msg);
}

@end
