//
//  CPLabel.h
//  RFCircularProgress
//
//  Created by Rich Fellure on 5/14/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RFProgressView;

IB_DESIGNABLE
@interface RFProgressView : UIView


//Inspecatbles for the Circle
@property IBInspectable CGFloat circleWidth;
@property IBInspectable UIColor *circleColor;
@property IBInspectable float totalValue;
@property IBInspectable (nonatomic) float currentValue;
@property IBInspectable BOOL continuous;

@property (readonly)CGFloat percentComplete;
//@property IBInspectable BOOL counterClockwise;

@property IBInspectable BOOL hidesInsetCircle;
@property IBInspectable UIColor *insetCircleColor;
@property IBInspectable CGFloat insetCircleWidth;

//Inspectables for the main label, so we can manipulate it in IB
@property IBInspectable NSString *titleLabelText;
@property IBInspectable UIColor *titleLabelTextColor;
@property IBInspectable UIColor *titleLabelBackgroundColor;
@property IBInspectable float titleLabelFontSize;

//Elements, or possible elements to be placed in the view
@property UILabel *titleLabel;

/**
 Description: Call to change the percentage of completion shown on the progress view to match the numerator divided by the denominator. Also will animate according to the Duration
 
 :numerator: The current number representing the amount completed
 
 :denominator: The total number of to decide how to find percent completion
 
 :duration: The desired duration of the animation
 */
-(void)changeToValue:(CGFloat)value withAnimationDuration:(CGFloat)duration;
//-(void)moveToValue:(CGFloat)value;

@end
