//
//  ZGSViewController.h
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>


@interface ZGSViewController : UIViewController<AGSMapViewLayerDelegate,
                                                AGSLocationDisplayInfoTemplateDelegate,
                                                AGSCalloutDelegate,
                                                AGSMapViewTouchDelegate,
                                                CLLocationManagerDelegate,
                                                UIActionSheetDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
- (IBAction)zoomToMyPosition:(UIButton *)sender;


@end
