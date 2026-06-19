//
//  UILabel+FF.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 5/31/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "UILabel+FF.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UILabel (FF)

+ (UILabel *)FFLabelWithFontSize:(int)size andFrame:(CGRect)frame {
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.font = [UIFont fontWithName:@"Cochin" size:size];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    label.textAlignment = UITextAlignmentCenter;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textColor = UIColorFromRGB(0x00FFFF);
    
    return label;
}

@end
