//
//  ViewController.m
//  RFCircularProgress
//
//  Created by Rich Fellure on 5/14/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "RFProgressView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RFProgressView *topView;
@property (weak, nonatomic) IBOutlet RFProgressView *bottomView;

@end

@implementation ViewController
{
    CGFloat countdown;
    CGFloat bottomViewCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    countdown = 0.0;
    bottomViewCount = 3.0;

    self.topView.percent = 0.0;
    [self.bottomView setStartingPercent:8.0 byDenominator:12.0];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(drawBez) userInfo:nil repeats:YES];

    RFProgressView *prog = [[RFProgressView alloc]initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    prog.circleColor = [UIColor blueColor];
    prog.circleWidth = 2.0; 
    [prog changePercent:8.0 byDenominator:10.0 withAnimationDuration:0.5];
    [self.view addSubview:prog];
}

-(void)drawBez {
    if (countdown < 10.0) {
        [self.topView changePercent:++countdown byDenominator:10.0 withAnimationDuration:0.5];
    }
    else {
        countdown = 0.0;
        [self.topView changePercent:countdown byDenominator:60.0 withAnimationDuration:0.0];
        [self.bottomView changePercent:++bottomViewCount byDenominator:12.0 withAnimationDuration:0.5];
    }

}

@end
