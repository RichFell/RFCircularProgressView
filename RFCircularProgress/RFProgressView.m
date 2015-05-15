//
//  CPLabel.m
//  RFCircularProgress
//
//  Created by Rich Fellure on 5/14/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "RFProgressView.h"

@implementation RFProgressView
{
    CGFloat startAngle;
    CGFloat endAngle;
    CGPoint centerPoint;
    BOOL hasBeenShown;
    UIBezierPath *circlePath;
    CAShapeLayer *progressLayer;
}

-(void)awakeFromNib {
    //prefer to call this here, as drawRect can be cumbersome.
    [self layoutTopLabel];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //Have to call drawCircle here for it to show in IB
    [self drawCircle];
}

-(void)prepareForInterfaceBuilder {
    //Adjusting backgroundColor and things is better done here than in drawRect
    [self layoutTopLabel];
}

-(void)setup {
    [self drawCircle];
    [self layoutTopLabel];
}

//Draws the two circles using Belzier path.
-(void)drawCircle {
    //Have to adjust to multiplier according to the percentage given
//    float multiplier = 2 - ((self.percent / 100) * 2);
    startAngle = M_PI * 1.5;
    endAngle = startAngle + (M_PI * 2);

    float circWidth = self.circleWidth ? self.circleWidth : 1.0;

    circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2,
                                             CGRectGetHeight(self.frame)/2)
                          radius:CGRectGetWidth(self.frame)/2 - circWidth
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];

    progressLayer = [[CAShapeLayer alloc] init];

    [progressLayer setPath: circlePath.CGPath];

    [progressLayer setStrokeColor:self.circleColor.CGColor];
    [progressLayer setFillColor:[UIColor clearColor].CGColor];
    [progressLayer setLineWidth:self.circleWidth];

    [progressLayer setStrokeStart:0.0];
    CGFloat strokeEnd = (self.percent / 100);
    [progressLayer setStrokeEnd:strokeEnd];

    [self.layer addSublayer:progressLayer];
    //If set to show the insetCircle, then we want to dislay it
    if (!self.hidesInsetCircle) {
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);

        float insetCircWidth = self.insetCircleWidth ? self.insetCircleWidth : 1.0;

        UIBezierPath *insetCirclePath = [UIBezierPath bezierPath];
        [insetCirclePath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2,
                                                 CGRectGetHeight(self.frame)/2)
                              radius:CGRectGetWidth(self.frame)/2 - circWidth/2 - 10
                          startAngle:startAngle
                            endAngle:endAngle
                           clockwise:YES];
        [insetCirclePath setLineWidth:insetCircWidth];
        UIColor *setCircleColor = self.insetCircleColor ? self.insetCircleColor : [UIColor blackColor];
        [setCircleColor setStroke];
        [insetCirclePath stroke];

    }
    //We add this stroke after the inset so that it is over it.
}

-(void)layoutTopLabel {
    //Find the points so that the Label is centered in the View
    centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    CGFloat width = CGRectGetWidth(self.frame)/3;
    CGFloat height = CGRectGetHeight(self.frame)/3;
    CGFloat xOrigin = centerPoint.x - (width / 2);
    CGFloat yOrigin = centerPoint.y - (height / 2);
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, width, height)];
    self.mainLabel.backgroundColor = [UIColor lightGrayColor];
    self.mainLabel.textColor = self.mainLabelTextColor ? self.mainLabelTextColor : [UIColor blackColor];
    self.mainLabel.text = self.mainLabelText;
    self.mainLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:30.0];
    self.mainLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    self.mainLabel.backgroundColor = self.mainLabelBackgroundColor ? self.mainLabelBackgroundColor : [UIColor clearColor];
    [self addSubview:self.mainLabel];
}


-(void)changePercent:(CGFloat)newPercent {
    CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animateStrokeEnd.duration  = 100.0;
    animateStrokeEnd.fromValue = [NSNumber numberWithFloat:self.percent/100];
    animateStrokeEnd.toValue   = [NSNumber numberWithFloat:newPercent/100];
    [progressLayer addAnimation:animateStrokeEnd forKey:nil];
    self.percent = newPercent;
    self.mainLabel.text = @"HI";
}

@end













