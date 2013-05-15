//
//  ZGSSubLayerViewController.m
//  HZMapHD
//
//  Created by zjugis on 13-5-14.
//  Copyright (c) 2013年 zgis. All rights reserved.
//

#import "ZGSSubLayersViewController.h"
#define COLUMN 4

@interface ZGSSubLayersViewController ()

@end

@implementation ZGSSubLayersViewController

@synthesize layersViewController=_layersViewController;
@synthesize subLayers = _subLayers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_furley.png"]];
    
    // init cates show
    int total = self.subLayers.count;
#define ROWHEIHT 70
    int rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
    
    for (int i=0; i<total; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        NSDictionary *data = [self.subLayers objectAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(80*column, ROWHEIHT*row, 80, ROWHEIHT)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(15, 15, 50, 50);
        btn.tag = i;
        [btn addTarget:self.layersViewController action:@selector(subLayerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       
        [btn setBackgroundImage:[UIImage imageNamed:[[data objectForKey:@"thumb"] stringByAppendingFormat:@".png"]]
                       forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:[[data objectForKey:@"thumb"] stringByAppendingFormat:@"_selected.png"]]
                       forState:UIControlStateSelected];
        
        [view addSubview:btn];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 80, 14)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor colorWithRed:204/255.0
                                        green:204/255.0
                                         blue:204/255.0
                                        alpha:1.0];
        lbl.font = [UIFont systemFontOfSize:12.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = [data objectForKey:@"name"];
        [view addSubview:lbl];
        
        [self.view addSubview:view];
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = (ROWHEIHT + 10) * rows;
    self.view.frame = viewFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonCheck:(UIButton *)sender {
    
}

@end
