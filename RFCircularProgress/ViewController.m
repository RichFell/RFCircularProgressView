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

    countdown = 0.0;
    self.testLabel.percent = 0.0;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(drawBez) userInfo:nil repeats:true];
}

-(void)drawBez {
    if (countdown <= 60.0) {
        [self.testLabel changePercent:++countdown];
        countdown = countdown++;
    }
    else {
        countdown = 0.0;
        [self.testLabel changePercent:countdown];
    }

}

@end
