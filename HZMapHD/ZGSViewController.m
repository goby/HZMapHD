//
//  ZGSViewController.m
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import "ZGSViewController.h"
#import "ZGSTiledLayer.h"

// Seven parameters
#define ScaleTranslation    0
#define XRotation           0
#define XTranslation        0
#define YRotation           0
#define YTranslation        0
#define ZRotation           0
#define ZTranslation        0

@interface ZGSViewController ()

@end

@implementation ZGSViewController

@synthesize locationManager = _locationManager;

-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //_locationManager.distanceFilter = 20;
    }
    
    return _locationManager;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //bind delegate
    self.mapView.layerDelegate = self;
    self.mapView.touchDelegate = self;
    
    NSError* err;
	ZGSTiledLayer* tiledLyr = [[ZGSTiledLayer alloc] initWithDataFramePath:@"http://202.121.180.49/arcgiscache/hzgh/Layers" error:&err];
    
	//If layer was initialized properly, add to the map
	if(tiledLyr!=nil){
        [self.mapView addMapLayer:tiledLyr withName: @"Tiled Base Map"];
        
        //graphicsLayer = [AGSGraphicsLayer graphicsLayer];
        //[self.mapView addMapLayer:graphicsLayer withName:@"Graphics Layer"];
        
	}else{
		//layer encountered an error
		NSLog(@"Error encountered: %@", err);
	}
    
    double xmin, ymin, xmax, ymax;
	/* xmin = 40496418.8722965;
	ymin = 3319960.4319613;
	xmax = 40542545.7777764;
	ymax = 3381623.52026086; */
    xmin =  61233.7016445426;
    ymin=  52585.8605198758;
    xmax = 107066.301644543;
    ymax = 114185.708449647;
	//AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKT:@"PROJCS[\"Xian_1980_3_Degree_GK_Zone_40\",GEOGCS[\"GCS_Xian_1980\",DATUM[\"D_\",SPHEROID[\"Xian_1980\",6378140.0,298.257]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"False_Easting\",40500000.0],PARAMETER[\"False_Northing\",0.0],PARAMETER[\"Central_Meridian\",120.0],PARAMETER[\"Scale_Factor\",1.0],PARAMETER[\"Latitude_Of_Origin\",0.0],UNIT[\"Meter\",1.0]]"];
	AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKID:2437];
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:xmin ymin:ymin xmax:xmax ymax:ymax spatialReference:sr];
	[self.mapView zoomToEnvelope:env animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Location Manager delegate -
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    CGPoint point;
    point.x = newLocation.coordinate.longitude;
    point.y = newLocation.coordinate.latitude;
    
    CGPoint hzPoint = [self lngLat2LocalGCS:point];
    
    //AGSPoint *mappoint =[[AGSPoint alloc] initWithX:hzPoint.x y:hzPoint.y spatialReference:nil ];
}

-(CGPoint)lngLat2LocalGCS:(CGPoint) point {
    CGPoint newPoint;
    newPoint.x = (1 + ScaleTranslation) * point.x + XTranslation;
    newPoint.y = (1 + ScaleTranslation) * point.y + YTranslation;
    return newPoint;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)zoomToMyPosition:(UIButton *)sender {
    [self.mapView centerAtPoint: self.mapView.locationDisplay.mapLocation animated:YES];
}

#pragma mark - ArcGIS Map View delegate -
-(void) mapViewDidLoad:(AGSMapView*)mapView {
	// comment to disable the GPS on start up
    //self.mapView.gps.autoPanMode = AGSGPSAutoPanModeCompassNavigation;
    self.mapView.locationDisplay.infoTemplateDelegate = self;
    self.mapView.callout.delegate = self;
    [self registerAsObserver];
	[self.mapView.locationDisplay startDataSource];
}

#pragma mark - ArcGIS Map View Touch delegate -
-(void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics{
    printf("[X: %.0f, Y: %.0f]\n",mappoint.x, mappoint.y);
}

- (void)registerAsObserver {
    [ self.mapView.locationDisplay addObserver:self
                                    forKeyPath:@"mapLocation"
                                       options:(NSKeyValueObservingOptionNew)
                                       context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"mapLocation"]) {
        //self.locationInfoLabel.text = [NSString stringWithFormat:@"[X:%.2f, Y:%.2f]",self.mapView.locationDisplay.mapLocation.x, self.mapView.locationDisplay.mapLocation.y];
    }
}

@end
