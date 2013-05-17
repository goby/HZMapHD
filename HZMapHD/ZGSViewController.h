//
//  ZGSViewController.h
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@protocol ZGSLayersDelegate;

@interface ZGSViewController : UIViewController<AGSMapViewLayerDelegate,
                                                AGSLocationDisplayInfoTemplateDelegate,
                                                AGSCalloutDelegate,
                                                AGSMapViewTouchDelegate,
                                                UIActionSheetDelegate,
                                                AGSLocationDisplayDataSource,
                                                UISearchBarDelegate,
                                                ZGSLayersDelegate,
                                                CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchArea;
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
- (IBAction)zoomToMyPosition:(UIButton *)sender;

@end
