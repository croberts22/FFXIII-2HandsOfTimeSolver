//
//  SelectedNodeView.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 3/17/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "SelectedNodeView.h"

@implementation SelectedNodeView

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define CENTER_X (self.center.x)
#define CENTER_Y (self.center.y)

#define IPAD_PADDING (65)
#define IPHONE_PADDING (40) 

#define RADIUS (self.frame.size.width/2 - ( IS_IPAD ? IPAD_PADDING : IPHONE_PADDING ) )

#define FRAME_DIMENSION ( IS_IPAD ? 80.0f : 50.0f )
#define INNER_FRAME_DIMENSION (sqrt(pow((FRAME_DIMENSION/2.0),2)+pow((FRAME_DIMENSION/2.0),2)))

#define FRAME_RADIUS (FRAME_DIMENSION/2.0f)

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@synthesize nodes, coordinates, highlightedNodeToChoose, highlightedNodeNotToChoose;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for(int i = 0; i < coordinates.count; i++){
        NSArray *current_coordinate = [coordinates objectAtIndex:i];  
        if(i == highlightedNodeToChoose){
            [self drawHighlightedChosenNode:current_coordinate];
        }
        else if(i == highlightedNodeNotToChoose){
            [self drawHighlightedNotChosenNode:current_coordinate];
        }
    }
}

- (void)drawHighlightedChosenNode:(NSArray *)coordinate {
    //get current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);  
    
    //add glow effect
    CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 10.0f);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0, 0.0), 10.0f, UIColorFromRGB(0xAFC4F1).CGColor);
    
    //set color of circumference
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xAFC4F1).CGColor); 
    
    //draw circle
    CGRect rectangle = CGRectMake([[coordinate objectAtIndex:0] floatValue]-(FRAME_RADIUS),
                                  [[coordinate objectAtIndex:1] floatValue]-(FRAME_RADIUS),
                                  FRAME_DIMENSION, 
                                  FRAME_DIMENSION);
    CGContextAddEllipseInRect(context, rectangle);     
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillEllipseInRect(context, rectangle);
}

- (void)drawHighlightedNotChosenNode:(NSArray *)coordinate {
    //get current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);  
    
    //add glow effect
    CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 10.0f);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0, 0.0), 10.0f, UIColorFromRGB(0x7284AC).CGColor);
    
    //set color of circumference
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0x7284AC).CGColor); 
    
    //draw circle
    CGRect rectangle = CGRectMake([[coordinate objectAtIndex:0] floatValue]-(FRAME_RADIUS),
                                  [[coordinate objectAtIndex:1] floatValue]-(FRAME_RADIUS),
                                  FRAME_DIMENSION, 
                                  FRAME_DIMENSION);
    CGContextAddEllipseInRect(context, rectangle);     
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillEllipseInRect(context, rectangle);
}


@end
