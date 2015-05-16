# RFCircularProgressView
CircularProgressView, that is IBDesignable, and has many additional customizations that can be made in IB. Comes with a label in the middle, which also has some customizations available in IB. 

How to use in IB:

  Add a UIView to your Storyboard
  
  Change the class of the view to RFProgressView
  
  Open the Attribute Inspector, and customize.
  
Available Customizations:

  Progress Bar - Color, Width, Percent completed
  
  Inset Bar- Appearance, Color, Width
  
  Label- Font size, text, background color, text color
  
Methods:

  -(void)changePercent:(CGFloat)numerator byDenominator:(CGFloat)denominator
    
    Description:
      Call on the instance of your RFProgressView, pass in the numerator, and denominator for percentage completed you want to show. 
      Animates the Progress bar to desired completion. 
