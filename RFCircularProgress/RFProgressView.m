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
    CGFloat percent;
    BOOL inIB;
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
    inIB = true;
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
    filling = YES;

    float circWidth = self.circleWidth ? self.circleWidth : 1.0;

    circlePath = [UIBezierPath bezierPath];

    [circlePath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2,
                                             CGRectGetHeight(self.frame)/2)
                          radius:CGRectGetWidth(self.frame)/2 - circWidth/2
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];

    [self addCALayerToPath:circlePath];
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

-(void)addCALayerToPath:(UIBezierPath *)path {
    progressLayer = [[CAShapeLayer alloc] init];

    [progressLayer setPath: circlePath.CGPath];

    [progressLayer setStrokeColor:self.circleColor.CGColor];
    [progressLayer setFillColor:[UIColor clearColor].CGColor];
    [progressLayer setLineWidth:self.circleWidth];

    [progressLayer setStrokeStart:0.0];

    percent = inIB ? self.currentValue/self.totalValue : 0.0;
    [progressLayer setStrokeEnd:percent];

    [self.layer addSublayer:progressLayer];

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
-(void)changeToValue:(CGFloat)value withAnimationDuration:(CGFloat)duration{

    self.currentValue = value;
    [self addAnimationWithDuration:duration];
    self.titleLabel.text = [NSString stringWithFormat:@"%.f", value];

    if (self.currentValue == self.totalValue) {
        if (!filling) {
        }
        filling = !filling;
    }


}

-(void)addAnimationWithDuration:(CGFloat)duration {
    CABasicAnimation *animateStroke;
    if (filling) {
        animateStroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    }
    else {
        animateStroke = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    }
    animateStroke.fillMode = kCAFillModeBoth;
    animateStroke.duration = duration;
    startPoint = percent == 1.0 ? 0.0 : percent;
    animateStroke.fromValue = @(startPoint);
    percent = self.currentValue/self.totalValue;
    animateStroke.toValue = @(percent);
    [animateStroke setRemovedOnCompletion:NO];
    animateStroke.delegate = self;
    [progressLayer addAnimation:animateStroke forKey:nil];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if (percent == 1.0 && filling) {
            [progressLayer removeFromSuperlayer];
            progressLayer = nil;
            percent = 0.0;
            [self addCALayerToPath:circlePath];
//            CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
//            [basicAnim setValue:@(0.0) forKey:@"strokeStart"];
        }
    }
}

//-(void)animationDidStart:(CAAnimation *)anim {
//
//}
//-(void)reset
//{
//    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    endAnimation.duration = 0.0;
//    endAnimation.toValue = @(0.0);
//    [endAnimation setRemovedOnCompletion:YES];
//    [progressLayer addAnimation:endAnimation forKey:nil];
//
//    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
//    startAnimation.duration = 0.0;
//    startAnimation.toValue = @(0.0);
//    [startAnimation setRemovedOnCompletion:YES];
//    [progressLayer addAnimation:startAnimation forKey:nil];
//}
-(void)setStartingPercent:(CGFloat)numerator byDenominator:(CGFloat)denominator {
    percent = numerator/denominator;
    self.titleLabel.text = [NSString stringWithFormat:@"%.f", numerator];
    [self drawCircle];
}

@end













