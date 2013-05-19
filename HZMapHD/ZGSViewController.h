//
//  ZGSViewController.h
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "ZGSLayersViewController.h"
#import "REMenu.h"

@interface ZGSViewController : UIViewController<AGSMapViewLayerDelegate,
                                                AGSLocationDisplayInfoTemplateDelegate,
                                                AGSCalloutDelegate,
                                                AGSMapViewTouchDelegate,
                                                AGSInfoTemplateDelegate,
                                                UIActionSheetDelegate,
                                                UISearchBarDelegate,
                                                ZGSLayersDelegate,
                                                CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchArea;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) REMenu *menu;
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
- (IBAction)zoomToMyPosition:(UIButton *)sender;
-(void)saveMapConfig;

@end
