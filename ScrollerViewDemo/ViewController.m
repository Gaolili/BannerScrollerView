//
//  ViewController.m
//  ScrollerViewDemo
//
//  Created by gaolili on 15/8/14.
//  Copyright (c) 2015年 mRocker. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 568
#define IMAGEVIEW_COUNT 3




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * imar = @[@"image_1",@"image_2",@"image_3"];
    
    BannerView *banner = [[BannerView alloc]initWithFrame:self.view.bounds animation:YES isURLImage:NO];
    banner.imageArr = imar;
    [self.view addSubview:banner];
}




@end
