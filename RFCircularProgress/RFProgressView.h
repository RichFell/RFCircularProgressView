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

//Inspectables for the main label, so we can manipulate it in IB
@property IBInspectable NSString *mainLabelText;
@property IBInspectable UIColor *mainLabelBackgroundColor;
@property IBInspectable UIColor *mainLabelTextColor;



//Elements, or possible elements to be placed in the view
@property UILabel *mainLabel;


@end
