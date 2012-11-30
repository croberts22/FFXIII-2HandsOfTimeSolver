//
//  RecentPuzzleCell.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 11/28/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "RecentPuzzleCell.h"
#import "TTTAttributedLabel.h"
#import "UIColor+FF.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define TEXT_FONT_SIZE ( IS_IPAD ? 20.0f : 16.0f )
#define DETAIL_TEXT_FONT_SIZE ( IS_IPAD ? 14.0f : 12.0f )

@implementation RecentPuzzleCell

@synthesize puzzle, details;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.puzzle = [[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)] autorelease];
        self.details = [[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 30, 300, 20)] autorelease];
        
        self.puzzle.numberOfLines = 1;
        self.puzzle.font = [UIFont fontWithName:@"Georgia-Bold" size:TEXT_FONT_SIZE];
        self.puzzle.backgroundColor = [UIColor clearColor];
        
        self.details.numberOfLines = 2;
        self.details.font = [UIFont fontWithName:@"Georgia" size:DETAIL_TEXT_FONT_SIZE];
        self.details.textColor = [UIColor grayColor];
        self.details.backgroundColor = [UIColor clearColor];
        
        [self addSubview:puzzle];
        [self addSubview:details];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPuzzleText:(NSString *)string {
    [self.puzzle setText:string afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRegularExpression *oneRegEx = [[NSRegularExpression alloc] initWithPattern:@"1" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *twoRegEx = [[NSRegularExpression alloc] initWithPattern:@"2" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *threeRegEx = [[NSRegularExpression alloc] initWithPattern:@"3" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *fourRegEx = [[NSRegularExpression alloc] initWithPattern:@"4" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *fiveRegEx = [[NSRegularExpression alloc] initWithPattern:@"5" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *sixRegEx = [[NSRegularExpression alloc] initWithPattern:@"6" options:NSRegularExpressionCaseInsensitive error:nil];
        
        UIFont *font = [UIFont fontWithName:@"Georgia-Bold" size:TEXT_FONT_SIZE];
        CTFontRef numberFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
        
        [oneRegEx enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if(font) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)numberFont range:result.range];
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor FFColorRed] CGColor] range:result.range];
            }
        }];

        [twoRegEx enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if(font) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)numberFont range:result.range];
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor FFColorOrange] CGColor] range:result.range];
            }
        }];
        
        [threeRegEx enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if(font) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)numberFont range:result.range];
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor FFColorGreen] CGColor] range:result.range];
            }
        }];
        
        [fourRegEx enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if(font) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)numberFont range:result.range];
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor FFColorTurquoise] CGColor] range:result.range];
            }
        }];
             
        [fiveRegEx enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if(font) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)numberFont range:result.range];
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor FFColorPurple] CGColor] range:result.range];
            }
        }];
        
        [sixRegEx enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if(font) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)numberFont range:result.range];
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor FFColorPink] CGColor] range:result.range];
            }
        }];
        
        
        CFRelease(font);
        
        return mutableAttributedString;
    }];
}

- (void)setDetailsText:(NSString *)string withUsername:(NSString *)username {
    [self.details setText:string afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange usernameRange = [[mutableAttributedString string] rangeOfString:username options:NSCaseInsensitiveSearch];
        UIFont *usernameFont = [UIFont fontWithName:@"Georgia-Bold" size:DETAIL_TEXT_FONT_SIZE];
        CTFontRef userFont = CTFontCreateWithName((CFStringRef)usernameFont.fontName, usernameFont.pointSize, NULL);
        UIColor *userColor = [UIColor lightGrayColor];
        
        if (userFont) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)userFont range:usernameRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:userColor range:usernameRange];
            CFRelease(userFont);
        }
        
        return mutableAttributedString;
    }];

}

@end
