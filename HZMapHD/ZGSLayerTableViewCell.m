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
        self.thumb = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        self.thumb.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.thumb];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 230, 20)];
        self.name.font = [UIFont systemFontOfSize:16.0f];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.textColor = [UIColor whiteColor];
        self.name.opaque = NO;
        [self.contentView addSubview:self.name];
        
        self.subTtile = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 230, 14)];
        self.subTtile.font = [UIFont systemFontOfSize:12.0f];
        self.subTtile.textColor = [UIColor colorWithRed:158/255.0
                                                  green:158/255.0
                                                   blue:158/255.0
                                                  alpha:1.0];
        self.subTtile.backgroundColor = [UIColor clearColor];
        self.subTtile.opaque = NO;
        [self.contentView addSubview:self.subTtile];
        
        UILabel *sLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 80)];
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
