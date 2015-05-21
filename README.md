# RFCircularProgressView
CircularProgressView, that is IBDesignable, and has many additional customizations that can be made in IB. Comes with a label in the middle, which also has some customizations available in IB. 

How to use in IB:

  Add a UIView to your Storyboard
  
  Change the class of the view to RFProgressView
  
  Open the Attribute Inspector, and customize.
  
Available Customizations:

  Progress Bar - Color, Width, Current Value, Total Value, if once a rotation is complete, it will continuously rotate, clearing the full bar, then refilling it. 
  
  Inset Bar- Appearance, Color, Width
  
  Label- Font size, text, background color, text color
  
Usage:

    It is important to make sure that the currentValue, and totalValue are set for the progress bar before trying to use it. 

  -(void)changePercent:(CGFloat)numerator byDenominator:(CGFloat)denominator
    
    Description:
      Call on the instance of your RFProgressView, pass in the numerator, and denominator for percentage completed you want to show. 
      Animates the Progress bar to desired completion. 

    Can also just change the value for the currentValue property, and that will animate the Progress to that amount of completion. 
