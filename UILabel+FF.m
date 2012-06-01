//
//  UILabel+FF.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 5/31/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "UILabel+FF.h"

@implementation UILabel (FF)

+ (UILabel *)FFLabelWithFrame:(CGRect)frame andFontSize:(int)size{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.font = [UIFont fontWithName:@"Cochin" size:size];
    
    return label;
}

@end
