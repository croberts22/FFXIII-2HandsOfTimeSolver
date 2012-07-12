//
//  Common.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 6/1/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "Common.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define CENTER_X (self.center.x)
#define CENTER_Y (self.center.y)

#define IPAD_PADDING (65)
#define IPHONE_PADDING (40)

#define RADIUS (self.frame.size.width/2 - ( IS_IPAD ? IPAD_PADDING : IPHONE_PADDING ) )

#define FRAME_DIMENSION ( IS_IPAD ? 75.0f : 50.0f )
#define INNER_FRAME_DIMENSION (sqrt(pow((FRAME_DIMENSION/2.0),2)+pow((FRAME_DIMENSION/2.0),2)))

#define FRAME_RADIUS (FRAME_DIMENSION/2.0f)

@implementation Common

@end
