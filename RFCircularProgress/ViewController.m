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

static CGFloat const denominator = 10.0;

- (void)viewDidLoad {
    [super viewDidLoad];

    countdown = 0.0;
    bottomViewCount = 3.0;

    self.topView.percent = 0.0;
//    NSTimer *newTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(drawBez) userInfo:nil repeats:YES];

//    [newTimer fire];
    RFProgressView *prog = [[RFProgressView alloc]initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    prog.circleColor = [UIColor blueColor];
    prog.circleWidth = 2.0; 
    [prog changePercent:8.0 byDenominator:10.0 withAnimationDuration:0.5];
    [self.view addSubview:prog];
}

-(void)drawBez {

}
- (IBAction)increasePercentOnTap:(UIButton *)sender {
    NSLog(@"1: %.f", countdown);
    [self.topView changePercent:++countdown byDenominator:denominator withAnimationDuration:0.95];
    if (countdown == denominator) {
        countdown = 0;
    }
    NSLog(@"3: %.f", countdown);
}

@end
