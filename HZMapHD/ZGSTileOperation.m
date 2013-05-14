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

#import "ZGSTileOperation.h"
#import "FTWCache.h"
#import "AFImageRequestOperation.h"

@implementation ZGSTileOperation

@synthesize tile=_tile;
@synthesize target=_target;
@synthesize action=_action;
@synthesize allLayersPath=_allLayersPath;
@synthesize data=_data;

- (id)initWithTile:(AGSTileKey *)tile dataFramePath:(NSString *)path target:(id)target action:(SEL)action {
	
	if (self = [super init]) {
		self.target = target;
		self.action = action;
		self.allLayersPath = [NSString stringWithFormat:@"%@/_allLayers", path];//[path stringByAppendingPathComponent:@"_alllayers"]  ;
		self.tile = tile;
		
	}
	return self;
}

-(void)main {
	//Fetch the tile for the requested Level, Row, Column
	@try {
		//Level ('L' followed by 2 decimal digits)
		NSString *decLevel = [NSString stringWithFormat:@"L%02d",self.tile.level];
		//Row ('R' followed by 8 hex digits)
		NSString *hexRow = [NSString stringWithFormat:@"R%08x",self.tile.row];
		//Column ('C' followed by 8 hex digits)  
		NSString *hexCol = [NSString stringWithFormat:@"C%08x",self.tile.column];
		
        NSString* imageUrl = [NSString stringWithFormat:@"%@/%@/%@/%@.png",_allLayersPath, decLevel,hexRow, hexCol];
        NSURL *aURL = [NSURL URLWithString:imageUrl];
        NSString *key = [imageUrl MD5Hash];
        _data = [FTWCache objectForKey:key];
        if (!_data) {
            [self requestData:aURL];
        }
        else {
            [_target performSelector:_action withObject:self];
        }
        
        //
        //NSLog(@"%@", aURL);
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
	}
}

- (void)requestData:(NSURL*) url
{
    if (!_operation) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        _operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
            _data = UIImagePNGRepresentation(image);
            [_target performSelector:_action withObject:self];
        }]; 
    }
    [_operation start];
}

-(void)cancel{
    [_operation cancel];
    [super cancel];
}

@end


