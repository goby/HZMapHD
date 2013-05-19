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

@class AGSPoint;
@class AGSLOD;
@class AGSSpatialReference;
@class AGSTileInfo;
@class AGSEnvelope;
@interface ZGSTiledCacheParserDelegate : NSObject<NSXMLParserDelegate> {
@protected
    NSString *_currentElement;
    
    int _dpi;
    int _WKID;
    int _level;
    double _xmin, _ymin, _xmax, _ymax;
    double _resolution, _scale;
    int _startTileRow, _endTileRow, _startTileColumn, _endTileColumn;
    double _tileOriginX, _tileOriginY;
    
    CGSize _tileSize;
    CGFloat _tileWidth,  _tileHeight;
    
    NSString *_tileFormat;
    
    NSMutableString *_WKT;
    AGSPoint *_tileOrigin;
    
    AGSLOD *_lod;
    NSMutableArray *_lods;
    AGSSpatialReference *_spatialReference;
    
    AGSEnvelope *_fullEnvelope;
    AGSTileInfo *_tileCacheInfo;
    NSError *_error;
}
@property (nonatomic, retain, readwrite) NSString *currentElement;
@property (nonatomic, retain, readwrite) NSString *tileFormat;
@property (nonatomic, retain, readwrite) NSMutableString *WKT;
@property (nonatomic, retain, readwrite) AGSPoint *tileOrigin;
@property (nonatomic, retain, readwrite) AGSLOD *lod;
@property (nonatomic, retain, readwrite) NSMutableArray *lods;
@property (nonatomic, retain, readwrite) AGSSpatialReference *spatialReference;
@property (nonatomic, retain, readwrite) AGSEnvelope *fullEnvelope;
@property (nonatomic, retain, readwrite) AGSTileInfo *tileInfo;
@property (nonatomic, retain, readwrite) NSError *error;



@end
