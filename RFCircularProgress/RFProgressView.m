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
    UIBezierPath *insetCirclePath;
    CGFloat startPoint;
    BOOL filling;
}

-(void)awakeFromNib {
    [super awakeFromNib];
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

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    [self drawCircle];
    [self layoutTopLabel];
}

//Draws the two circles using Belzier path.
-(void)drawCircle {
    //Use these angles in order to create the circular path our CAShapeLayer will follow
    startAngle = M_PI * 1.5;
    endAngle = startAngle + (M_PI * 2);
    startPoint = 0.0;
    filling = YES;

    float circWidth = self.circleWidth ? self.circleWidth : 1.0;

    circlePath = circlePath ? circlePath : [UIBezierPath bezierPath];

    [circlePath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2,
                                             CGRectGetHeight(self.frame)/2)
                          radius:CGRectGetWidth(self.frame)/2 - circWidth/2
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];

    progressLayer = progressLayer ? progressLayer : [[CAShapeLayer alloc] init];            //If have already been initialized, create the CAShapeLayer

    [progressLayer setPath: circlePath.CGPath];

    [progressLayer setStrokeColor:self.circleColor.CGColor];
    [progressLayer setFillColor:[UIColor clearColor].CGColor];
    [progressLayer setLineWidth:self.circleWidth];

    [progressLayer setStrokeStart:0.0];

    CGFloat strokeEnd = self.percent > 1.0 ? self.percent/100 : self.percent;
    [progressLayer setStrokeEnd:strokeEnd];

    [self.layer addSublayer:progressLayer];

    //If set to show the insetCircle, then we want to dislay it
    if (!self.hidesInsetCircle) {
        float insetCircWidth = self.insetCircleWidth ? self.insetCircleWidth : 1.0;

        insetCirclePath = [UIBezierPath bezierPath];

        [insetCirclePath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2,
                                                 CGRectGetHeight(self.frame)/2)
                              radius:CGRectGetWidth(self.frame)/2 - circWidth/2 - insetCircWidth/2
                          startAngle:startAngle
                            endAngle:endAngle
                           clockwise:YES];
        [insetCirclePath setLineWidth:insetCircWidth];
        UIColor *setCircleColor = self.insetCircleColor ? self.insetCircleColor : [UIColor blackColor];
        [setCircleColor setStroke];
        [insetCirclePath stroke];
    }
}

/**
 Description: Add, and layout the center label
 */
-(void)layoutTopLabel {
    //Find the points so that the Label is centered in the View
    centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    CGFloat width = CGRectGetWidth(self.frame)/2;
    CGFloat height = CGRectGetHeight(self.frame)/2;
    CGFloat xOrigin = centerPoint.x - (width / 2);
    CGFloat yOrigin = centerPoint.y - (height / 2);
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, width, height)];
    self.titleLabel.textColor = self.titleLabelTextColor ? self.titleLabelTextColor : [UIColor blackColor];
    self.titleLabel.text = self.titleLabelText;
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:self.titleLabelFontSize ? self.titleLabelFontSize : 30.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.backgroundColor = self.titleLabelBackgroundColor ? self.titleLabelBackgroundColor : [UIColor clearColor];
    [self addSubview:self.titleLabel];
}

/**
 Description: Animates the Progress bar to the given percent

 :newPecent: New percent to move the progress bar to from scale of 0.0 to 1.0
 */
-(void)changePercent:(CGFloat)numerator byDenominator:(CGFloat)denominator withAnimationDuration:(CGFloat)duration{
    NSLog(@"2: %.f", numerator);
    if (numerator) {
        
        [self addAnimation:numerator byDenominator:denominator withDuration:duration];
        self.titleLabel.text = [NSString stringWithFormat:@"%.f", numerator];

        if (numerator == denominator) {
            filling = !filling;
        }
    }

}

-(void)addAnimation:(CGFloat)numerator byDenominator:(CGFloat)denominator withDuration:(CGFloat)duration {
    CABasicAnimation *animateStrokeEnd;
    if (filling) {
        animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    }
    else {
        animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    }
    animateStrokeEnd.duration  = numerator == denominator ? 0.0 : duration;
    startPoint = self.percent == 1.0 ? 0.0 : self.percent;
    animateStrokeEnd.fromValue = @(startPoint);
    self.percent = numerator/denominator;
    animateStrokeEnd.toValue   = @(self.percent);
    animateStrokeEnd.fillMode = kCAFillModeBoth;
    [animateStrokeEnd setRemovedOnCompletion:NO];
    [progressLayer addAnimation:animateStrokeEnd forKey:nil];

}

-(void)setStartingPercent:(CGFloat)numerator byDenominator:(CGFloat)denominator {
    self.percent = numerator/denominator;
    self.titleLabel.text = [NSString stringWithFormat:@"%.f", numerator];
    [self drawCircle];
}

@end













