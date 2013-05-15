//
//  ZGSHorizonCurl.m
//  HZMapHD
//
//  Created by zjugis on 13-5-15.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import "ZGSHorizonCurl.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation ZGSHorizonCurl

-(void)perform{
    UIViewController *current = self.sourceViewController;
    UIViewController *next = self.destinationViewController;
    //CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    next.modalPresentationStyle = UIModalPresentationFullScreen;
    next.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [current presentViewController:next animated:YES completion:^{
        //
    }];
}

@end
