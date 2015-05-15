//
//  CPLabel.h
//  RFCircularProgress
//
//  Created by Rich Fellure on 5/14/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RFProgressView : UIView


//Inspecatbles for the Circle
@property IBInspectable CGFloat circleWidth;
@property IBInspectable UIColor *circleColor;
@property IBInspectable CGFloat percent;

@property IBInspectable BOOL hidesInsetCircle;
@property IBInspectable UIColor *insetCircleColor;
@property IBInspectable CGFloat insetCircleWidth;

//Inspectables for the main label, so we can manipulate it in IB
@property IBInspectable NSString *mainLabelText;
@property IBInspectable UIColor *mainLabelTextColor;
@property IBInspectable UIColor *mainLabelBackgroundColor;

//Elements, or possible elements to be placed in the view
@property UILabel *mainLabel;

//Instance methods
-(void)changePercent:(CGFloat)newPercent;

@end
