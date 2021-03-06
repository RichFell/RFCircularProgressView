//
//  ViewController.m
//  RFCircularProgress
//
//  Created by Rich Fellure on 5/14/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
@import RFCircularProgressKit;

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

    countdown = 1.0;
    bottomViewCount = 3.0;
    self.topView.currentValue = countdown;
    self.topView.totalValue = 4.0;

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(drawBez) userInfo:nil repeats:YES];

//    [newTimer fire];
    RFProgressView *prog = [[RFProgressView alloc]initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    prog.circleColor = [UIColor blueColor];
    prog.circleWidth = 2.0;
    [self.view addSubview:prog];
}

-(void)drawBez {
    [self increasePercentage];
}
- (IBAction)increasePercentOnTap:(UIButton *)sender {
    self.topView.currentValue = ++countdown;
}

-(void)increasePercentage {
    [self.topView changeToValue:++countdown withAnimationDuration:0.95];
    if (countdown == self.topView.totalValue) {
        countdown = 0;
    }
}
@end
