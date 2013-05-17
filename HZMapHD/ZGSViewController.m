//
//  ZGSViewController.m
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import "ZGSViewController.h"
#import "ZGSTiledLayer.h"
#import "ZGSLayersViewController.h"

// Seven parameters
#define ScaleTranslation 0
#define XRotation        0
#define XTranslation     0
#define YRotation        0
#define YTranslation     0
#define ZRotation        0
#define ZTranslation     0

@interface ZGSViewController () {
    NSArray *_selectedLayers;
    AGSGraphicsLayer *_graphicsLayer;
}

@end

@implementation ZGSViewController

@synthesize locationManager = _locationManager;

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //_locationManager.distanceFilter = 20;
    }
    
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //bind delegate
    self.mapView.layerDelegate = self;
    self.mapView.touchDelegate = self;
    self.mapView.backgroundColor = [UIColor colorWithRed:255.0 / 255.0 green:255 / 255.0 blue:222.0 / 255.0 alpha:0.3];
    self.mapView.gridLineColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:222.0 / 255.0 alpha:0.3];
    self.mapView.gridLineWidth = 0;
    //self.mapView.locationDisplay.dataSource = self;
    NSError *err;
    ZGSTiledLayer *tiledLyr = [[ZGSTiledLayer alloc] initWithDataFramePath:@"http://202.121.180.49/arcgiscache/hzgh/Layers"
                                                                     error:&err];
    
    //If layer was initialized properly, add to the map
    if (tiledLyr != nil) {
        [self.mapView addMapLayer:tiledLyr withName:@"Tiled Base Map"];
        
        _graphicsLayer = [AGSGraphicsLayer graphicsLayer];
        [self.mapView addMapLayer:_graphicsLayer withName:@"Graphics Layer"];
    } else {
        //layer encountered an error
        NSLog(@"Error encountered: %@", err);
    }
    
    double xmin, ymin, xmax, ymax;
    /* xmin = 40496418.8722965;
     ymin = 3319960.4319613;
     xmax = 40542545.7777764;
     ymax = 3381623.52026086; */
    xmin =  61233.7016445426;
    ymin =  52585.8605198758;
    xmax = 107066.301644543;
    ymax = 114185.708449647;
    //AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKT:@"PROJCS[\"Xian_1980_3_Degree_GK_Zone_40\",GEOGCS[\"GCS_Xian_1980\",DATUM[\"D_\",SPHEROID[\"Xian_1980\",6378140.0,298.257]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"False_Easting\",40500000.0],PARAMETER[\"False_Northing\",0.0],PARAMETER[\"Central_Meridian\",120.0],PARAMETER[\"Scale_Factor\",1.0],PARAMETER[\"Latitude_Of_Origin\",0.0],UNIT[\"Meter\",1.0]]"];
    AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKID:2437];
    AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:xmin ymin:ymin xmax:xmax ymax:ymax spatialReference:sr];
    [self.mapView zoomToEnvelope:env animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Location Manager delegate -
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    CGPoint point;
    point.x = newLocation.coordinate.longitude;
    point.y = newLocation.coordinate.latitude;
    
    //CGPoint hzPoint = [self lngLat2LocalGCS:point];
    
    //AGSPoint *mappoint =[[AGSPoint alloc] initWithX:hzPoint.x y:hzPoint.y spatialReference:nil ];
}

- (CGPoint)lngLat2LocalGCS:(CGPoint)point {
    CGPoint newPoint;
    newPoint.x = (1 + ScaleTranslation) * point.x + XTranslation;
    newPoint.y = (1 + ScaleTranslation) * point.y + YTranslation;
    return newPoint;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)zoomToMyPosition:(UIButton *)sender {
    [self.mapView centerAtPoint:self.mapView.locationDisplay.mapLocation animated:YES];
}

#pragma mark - Storyboard Segue -
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showLayersList"]) {
        ZGSLayersViewController *layerVC = [segue destinationViewController];
        layerVC.selectedLayers = _selectedLayers;
        [layerVC setDelegate:self];
    }
}

#pragma mark - ArcGIS Map View delegate -
- (void)mapViewDidLoad:(AGSMapView *)mapView {
    // comment to disable the GPS on start up
    //self.mapView.gps.autoPanMode = AGSGPSAutoPanModeCompassNavigation;
    self.mapView.locationDisplay.infoTemplateDelegate = self;
    NSLog(@"%@", self.mapView.locationDisplay.class);
    self.mapView.callout.delegate = self;
    [self registerAsObserver];
    //[self.mapView.locationDisplay startDataSource];
}

#pragma mark - ArcGIS Map View Touch delegate -
- (void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics {
    printf("[X: %.0f, Y: %.0f]\n", mappoint.x, mappoint.y);
}

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics {
    [_searchArea resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
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
        //printf("[X: %.0f, Y: %.0f]\n",self.mapView.locationDisplay.mapLocation.x, self.mapView.locationDisplay.mapLocation.y);
    }
}

- (void)layerView:(ZGSLayersViewController *)viewController selected:(NSArray *)selectedLayers {
    _selectedLayers = selectedLayers;
    [_graphicsLayer removeAllGraphics];
    for (NSNumber *code in selectedLayers) {
        NSArray *points = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:code.stringValue withExtension:@"plist"]];
        for (NSDictionary *item in points) {
            double x = [[NSString stringWithFormat:@"%@", [item objectForKey:@"x"]] doubleValue];
            double y = [[NSString stringWithFormat:@"%@", [item objectForKey:@"y"]] doubleValue];
            AGSPoint *point = [AGSPoint pointWithX:x y:y spatialReference:nil];
            //[point setValue:[item objectForKey:@"stan_name"] forKey:@"title"];
            [self addGraphicAtPoint:point withAttributes:item];
        }
    }
    //_graphicsLayer
}

- (void)addGraphicAtPoint:(AGSPoint *)point withAttributes:(NSDictionary *)attributes {
    AGSPictureMarkerSymbol *picMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"pin_pink_48.png"];
    picMarkerSymbol.size = CGSizeMake(48, 48);
    picMarkerSymbol.offset = CGPointMake(0, 24);
    AGSGraphic *myGraphic = [AGSGraphic graphicWithGeometry:point
                                                     symbol:picMarkerSymbol
                                                 attributes:attributes
                                       infoTemplateDelegate:self];
    //Add the graphic to the Graphics layer
    [_graphicsLayer addGraphic:myGraphic];
}

- (void)didClickAccessoryButtonForCallout:(AGSCallout *)callout {
    //
}

- (NSString *)titleForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)mapPoint {
    return [graphic attributeAsStringForKey:@"stan_name"];
}

- (IBAction)popupMenu:(UIBarButtonItem *)sender {
    [self showMenu:sender.tag];
}

- (void)showMenu:(int)button {
    if (_menu.isOpen) return [_menu close];
    
    // Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
    //
    NSArray *points = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Menu" withExtension:@"plist"]];
    NSDictionary *menu = [points objectAtIndex:button - 1];
    
    NSArray *subMenus = [menu objectForKey:@"submenu"];
    
    NSMutableArray *menuItems = [[NSMutableArray alloc]init];
    
    for (NSDictionary *submenu in subMenus) {
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:[submenu objectForKey:@"title"]
                                                    subtitle:[submenu objectForKey:@"subtitle"]
                                                       image:[UIImage imageNamed:[submenu objectForKey:@"icon"]]
                                            highlightedImage:nil
                                                      action: ^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                      }];
        item.tag = [[submenu objectForKey:@"code"] intValue];
        [menuItems addObject:item];
    }
    
    _menu = [[REMenu alloc] initWithItems:menuItems ];
    _menu.cornerRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(1, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromToolbar:self.toolbar];
}

@end
