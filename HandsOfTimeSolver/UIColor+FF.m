//
//  UIColor+FF.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 5/31/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "UIColor+FF.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (FF)

+ (UIColor *)FFColorRed {
    return [UIColor redColor];
}

+ (UIColor *)FFColorOrange {
    return [UIColor orangeColor];
}

+ (UIColor *)FFColorGreen {
    return [UIColor greenColor];
}

+ (UIColor *)FFColorTurquoise {
    return UIColorFromRGB(0x00FFFF);
}

+ (UIColor *)FFColorPurple {
    return UIColorFromRGB(0x8936EF);
}

+ (UIColor *)FFColorPink {
    return UIColorFromRGB(0xF984EF);
}


@end
