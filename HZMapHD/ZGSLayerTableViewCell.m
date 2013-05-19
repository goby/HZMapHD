//
//  ZGSLayerTableViewCell.m
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import "ZGSLayerTableViewCell.h"

@implementation ZGSLayerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tmall_bg_main"]];
        self.thumb = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 32, 32)];
        self.thumb.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.thumb];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(44, 6, 230, 20)];
        self.name.font = [UIFont systemFontOfSize:16.0f];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.textColor = [UIColor whiteColor];
        self.name.opaque = NO;
        [self.contentView addSubview:self.name];
        
        self.subTitle = [[UILabel alloc] initWithFrame:CGRectMake(44, 26, 230, 14)];
        self.subTitle.font = [UIFont systemFontOfSize:12.0f];
        self.subTitle.textColor = [UIColor colorWithRed:158/255.0
                                                  green:158/255.0
                                                   blue:158/255.0
                                                  alpha:1.0];
        self.subTitle.backgroundColor = [UIColor clearColor];
        self.subTitle.opaque = NO;
        [self.contentView addSubview:self.subTitle];
        
        UILabel *sLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 44)];
        sLine1.backgroundColor = [UIColor colorWithRed:198/255.0
                                                 green:198/255.0
                                                  blue:198/255.0
                                                 alpha:1.0];
        [self.contentView addSubview:sLine1];
        
//        UILabel *sLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, 320, 1)];
//        sLine2.backgroundColor = [UIColor whiteColor];
//        
//        [self.contentView addSubview:sLine2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
