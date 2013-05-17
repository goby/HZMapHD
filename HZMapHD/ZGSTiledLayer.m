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

#import "ZGSTiledLayer.h"
#import "ZGSTileOperation.h"
#import "ZGSTiledCacheParserDelegate.h"
#import "AFNetworking.h"
#import "FTWCache.h"

//Function to convert [UNIT] component in WKT to AGSUnits
int MakeAGSUnits(NSString* wkt){
	NSString* value ;
	BOOL _continue = YES;
 	NSScanner* scanner = [NSScanner scannerWithString:wkt];
	//Scan for the UNIT information in WKT. 
	//If WKT is for a Projected Coord System, expect two instances of UNIT, and use the second one
	while (_continue) {
		[scanner scanUpToString:@"UNIT[\"" intoString:NULL];
		[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"UNIT[\""]];
		_continue = [scanner scanUpToString:@"\"" intoString:&value];
	}
	if([@"Foot_US" isEqualToString:value] || [@"Foot" isEqualToString:value]){
		return AGSUnitsFeet;
	}else if([@"Meter" isEqualToString:value]){
		return AGSUnitsMeters;
	}else if([@"Degree" isEqualToString:value]){
		return AGSUnitsDecimalDegrees;
	}else{
		//TODO: Not handling other units like Yard, Chain, Grad, etc
		return -1;
	}
}


@implementation ZGSTiledLayer

@synthesize dataFramePath=_dataFramePath;

-(AGSUnits)units{
	return _units;
}
 
-(AGSSpatialReference *)spatialReference{
	return _fullEnvelope.spatialReference;
}
 
-(AGSEnvelope *)fullEnvelope{
	return _fullEnvelope;
}
 
-(AGSEnvelope *)initialEnvelope{
	//Assuming our initial extent is the same as the full extent
	return _fullEnvelope;
}

-(AGSTileInfo*) tileInfo{
	return _tileInfo;
}


#pragma mark -
- (id)initWithDataFramePath: (NSString *)path error:(NSError**) outError {
	if (self = [super init]) {
		self.dataFramePath = path;
		_queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:4];
		NSString* confXML = [NSString stringWithFormat:@"%@/conf.xml", path]; //[path stringByAppendingPathComponent: @"conf.xml"];
        NSURL *url = [NSURL URLWithString:confXML];
        NSString *key = [confXML MD5Hash];
        NSLog(@"%@", key);
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            [self loadConfigFromXml:data];
        }
        else {
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            AFXMLRequestOperation *requestOperation = [[AFXMLRequestOperation alloc] initWithRequest:request];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [FTWCache setObject: operation.responseData forKey:key];
                [self loadConfigWithParser:(NSXMLParser *)responseObject];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"the error is %@",error);
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"获取切片失败" message:error.localizedDescription delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:nil];
                assert(alert != nil);
                [alert show];
            }];
            [requestOperation start];
        }
    }
    return self;
}

-(void)loadConfigFromXml:(NSData *) xmlData {
    NSXMLParser*  xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    [self loadConfigWithParser:xmlParser];
}

-(void)loadConfigWithParser:(NSXMLParser *)xmlParser{
    ZGSTiledCacheParserDelegate* parserDelegate = [[ZGSTiledCacheParserDelegate alloc] init];
    [xmlParser setDelegate:parserDelegate];
    BOOL flag = [xmlParser parse];
    
    //If XML files were parsed properly...
    if([parserDelegate tileInfo]!= nil && [parserDelegate fullEnvelope]!=nil ){
        //... get the metadata
        _tileInfo = [parserDelegate tileInfo];
        _fullEnvelope = [parserDelegate fullEnvelope];
        _units = MakeAGSUnits(_fullEnvelope.spatialReference.wkt);
        [self layerDidLoad];
    }else {
        [self layerDidFailToLoad:parserDelegate.error];
    }
    
    if(flag) {
        NSLog(@"ok");
    }else{
        NSLog(@"获取指定路径的xml文件失败");
    }
}

#pragma mark -
//- (NSOperation<AGSTileOperation>*) retrieveImageAsyncForTile:(AGSTile *) tile{
//	//Create an operation to fetch tile from local cache
//	ZGSTileOperation *operation =
//		[[ZGSTileOperation alloc] initWithTile:tile
//											dataFramePath:_dataFramePath
//												   target:self 
//												   action:@selector(didFinishOperation:)];
//	//Add the operation to the queue for execution
//    [super.operationQueue addOperation:operation];
//    return [operation autorelease];
//}
//
- (void) didFinishOperation:(ZGSTileOperation*)op {
	//If tile was found ...
	if (op.data!=nil) {
		//... notify tileDelegate of success
		[super setTileData:op.data forKey:op.tile];
	}else {
		//... notify tileDelegate of failure
		//[self.tileDelegate tiledLayer:self operationDidFailToGetTile:op];
        [super setTileData:nil forKey:op.tile];
	}
}

-(void)requestTileForKey:(AGSTileKey *)key
{
    if(_queue.operationCount > 8){
        ZGSTileOperation* op = [_queue.operations objectAtIndex:0];
        [op cancel];
        NSLog(@"remove old op");
    }
    //Create an operation to fetch tile from local cache
	ZGSTileOperation *operation =
    [[ZGSTileOperation alloc] initWithTile:key
                             dataFramePath:_dataFramePath
                                    target:self
                                    action:@selector(didFinishOperation:)];
	//Add the operation to the queue for execution
    [_queue addOperation:operation];
}

-(void)cancelRequestForKey:(AGSTileKey *)key
{
    [AGSRequestOperation sharedOperationQueue];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_queue.operations];
    for (ZGSTileOperation* op in array) {
        if ([op.tile isEqualToTileKey:key] && op.isExecuting) {
            [op cancel];
            NSLog(@"Cancel:%d,%d,%d", key.level, key.column, key.row);
            break;
        }
    }
}

#pragma mark -
- (void)dealloc {
	self.dataFramePath = nil;
    [_queue cancelAllOperations];
}

@end

