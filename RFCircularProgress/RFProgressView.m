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
}

-(void)awakeFromNib {
    [self layoutTopLabel];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawCircle];
}

-(void)prepareForInterfaceBuilder {
    [self layoutTopLabel];
}

-(void)setup {
    [self drawCircle];
    [self layoutTopLabel];
}

-(void)drawCircle {
    float multiplier = 2 - ((self.percent / 100) * 2);
    startAngle = M_PI * 1.5;
    endAngle = startAngle + (M_PI * multiplier);

    circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2,
                                             CGRectGetHeight(self.frame)/2)
                          radius:CGRectGetWidth(self.frame)/2 - self.circleWidth
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
    [circlePath setLineWidth:self.circleWidth];
    UIColor *setCircleColor = self.circleColor ? self.circleColor : [UIColor blackColor];
    [setCircleColor setStroke];
    [circlePath stroke];
}

-(void)layoutTopLabel {
    centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    CGFloat width = CGRectGetWidth(self.frame)/3;
    CGFloat height = CGRectGetHeight(self.frame)/3;
    CGFloat xOrigin = centerPoint.x - (width / 2);
    CGFloat yOrigin = centerPoint.y - (height / 2);
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, width, height)];
    self.mainLabel.backgroundColor = [UIColor lightGrayColor];
    self.mainLabel.textColor = self.mainLabelTextColor;
    self.mainLabel.text = self.mainLabelText;
    self.mainLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:30.0];
    self.mainLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mainLabel];
}


-(void)changePercent:(CGFloat)newPercent {
    self.percent = newPercent;
}

@end













