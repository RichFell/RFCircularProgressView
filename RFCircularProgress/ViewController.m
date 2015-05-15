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
@property (weak, nonatomic) IBOutlet RFProgressView *testLabel;

@end

@implementation ViewController
{
    CGFloat countdown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.testLabel setup];

    countdown = 0.0;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(drawBez) userInfo:nil repeats:true];
}

-(void)drawBez {
    [self.testLabel changePercent:++countdown];
    countdown = countdown++;
}

@end
