//
//  ViewController.m
//  RFCircularProgress
//
//  Created by Rich Fellure on 5/14/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import <RFCircularProgressKit/RFCircularProgressKit.h>
#import "RFProgressView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RFProgressView *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.testLabel setup];

//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(drawBez) userInfo:nil repeats:false];

}

-(void)drawBez {
    UIBezierPath *bez = [UIBezierPath bezierPath];
    [bez moveToPoint:CGPointMake(100.0, 100.0)];
    [bez addLineToPoint:CGPointMake(200.0, 40.0)];
    [bez addLineToPoint:CGPointMake(160, 140)];
    [bez addLineToPoint:CGPointMake(40.0, 140)];
    [bez addLineToPoint:CGPointMake(0.0, 40.0)];
    [bez closePath];

    bez.lineWidth = 20.0;
    [[UIColor redColor]setFill];
    [bez fill];

}

@end
