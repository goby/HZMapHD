// Copyright 2012 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@class AFImageRequestOperation;

@interface ZGSTileOperation : NSOperation { //<AGSTileOperation> {
@private
    id _target;
    SEL _action;
    NSString *_allLayersPath;
    AGSTileKey *_tile;
    NSData *_data;
    AFImageRequestOperation *_operation;
}

- (id)initWithTile:(AGSTileKey *)tile dataFramePath:(NSString *)path target:(id)target action:(SEL)action;


@property (nonatomic, retain) AGSTileKey *tile;

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) NSString *allLayersPath;
@property (nonatomic, retain) NSData *data;

@end
