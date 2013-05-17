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

@interface ZGSViewController : UIViewController<AGSMapViewLayerDelegate,
                                                AGSLocationDisplayInfoTemplateDelegate,
                                                AGSCalloutDelegate,
                                                AGSMapViewTouchDelegate,
                                                UIActionSheetDelegate,
                                                UISearchBarDelegate,
                                                ZGSLayersDelegate,
                                                CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchArea;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
- (IBAction)zoomToMyPosition:(UIButton *)sender;


@end
