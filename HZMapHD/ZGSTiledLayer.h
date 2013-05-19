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

@interface ZGSTiledLayer : AGSTiledLayer  {
@protected
    NSString *_dataFramePath;
    AGSTileInfo *_tileInfo;
    AGSEnvelope *_fullEnvelope;
    AGSUnits _units;
    NSOperationQueue *_queue;
}

@property (nonatomic, retain, readwrite) NSString *dataFramePath;
- (id)initWithDataFramePath:(NSString *)path error:(NSError **)outError;

@end
