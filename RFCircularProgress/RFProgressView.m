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

#pragma mark - Methods for drawing on the View

//Draws the two circles using Belzier path.
-(void)drawCircle {
    //Use these angles in order to create the circular path our CAShapeLayer will follow
    startAngle = M_PI * 1.5;
    endAngle = startAngle + (M_PI * 2);
    filling = YES;
    self.currentValue = inIB ? self.currentValue : [self.delegate startingValueForProgressView:self];
    self.totalValue = inIB ? self.totalValue : [self.delegate totalValueForProgressView:self];
    float circWidth = self.circleWidth ? self.circleWidth : 1.0;

    circlePath = [UIBezierPath bezierPath];

    [circlePath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2,
                                             CGRectGetHeight(self.frame)/2)
                          radius:CGRectGetWidth(self.frame)/2 - circWidth/2
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];

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

        [self addLayerToPath:insetCirclePath withLayer:[CAShapeLayer new]
                   withColor:self.insetCircleColor
                    andWidth:self.insetCircleWidth
         andPercentCompleted:1.0];
    }

    //Have to add this after the inset, or the insetCircle will be on top of the progressLayer
    [self addProgressLayer];
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
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                           size:self.titleLabelFontSize ? self.titleLabelFontSize : 30.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.backgroundColor = self.titleLabelBackgroundColor ? self.titleLabelBackgroundColor : [UIColor clearColor];
    [self addSubview:self.titleLabel];
}

#pragma mark - Instance Method for animating the completion
/**
 Description: Animates the Progress bar to the given percent

 :value: The Value you want the progressView to animate to

 :duration: The duration of the desired animation
 */
-(void)changeToValue:(CGFloat)value withAnimationDuration:(CGFloat)duration{

    self.currentValue = value;
    [self addAnimationWithDuration:duration];
    self.titleLabel.text = [NSString stringWithFormat:@"%.f", value];

    if (self.currentValue == self.totalValue && self.continuous) {
        filling = !filling;
    }
}

#pragma mark - Methods for drawing a layer on top of the Bezier path
-(void)addProgressLayer {
    progressLayer = [[CAShapeLayer alloc] init];

    CGFloat complete = inIB ? self.currentValue/self.totalValue : [self.delegate startingValueForProgressView:self]/[self.delegate totalValueForProgressView:self];
    [self addLayerToPath:circlePath withLayer:progressLayer withColor:self.circleColor andWidth:self.circleWidth andPercentCompleted: complete];

}

-(void)addLayerToPath:(UIBezierPath *)path withLayer:(CAShapeLayer *)layer withColor:(UIColor *)color andWidth:(CGFloat)width andPercentCompleted:(CGFloat)percentage {
    [layer setPath: path.CGPath];
    [layer setStrokeColor:color.CGColor];
    [layer setFillColor:[UIColor clearColor].CGColor];
    [layer setLineWidth:width];
    [layer setStrokeStart:0.0];
    [layer setStrokeEnd:percentage];

    [self.layer addSublayer:layer];
}

#pragma mark - methods to help with the animation
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
        if (percent == 1.0 && filling && self.continuous) {
            [progressLayer removeFromSuperlayer];
            progressLayer = nil;
            percent = 0.0;
            [self addProgressLayer];
        }
    }
}

-(void)setStartingPercent:(CGFloat)numerator byDenominator:(CGFloat)denominator {
    percent = numerator/denominator;
    self.titleLabel.text = [NSString stringWithFormat:@"%.f", numerator];
    [self drawCircle];
}

@end













