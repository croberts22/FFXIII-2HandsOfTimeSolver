//
//  HandsView.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 3/17/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "HandsView.h"
#import <math.h>

@implementation HandsView

@synthesize left_hand, right_hand, coordinates, nodes, chosenNode, spacing, current_position, chosenNodeValue, move_foward;

#define CENTER_X (self.center.x)
#define CENTER_Y (self.center.y)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define SIZE_X ( IS_IPAD ? 30.0f : 15.0f )
#define SIZE_Y ( IS_IPAD ? 282.0f : 141.0f )

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawHands {
    if(left_hand == nil){
        left_hand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hand.png"]];
    }
    if(right_hand == nil){
        right_hand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hand.png"]];
    }
    
    CGRect frame = CGRectMake(CENTER_X - ( SIZE_X / 2), 
                              CENTER_Y - ( SIZE_Y / 2 ), 
                              SIZE_X, SIZE_Y);
    
    left_hand.frame = frame;
    right_hand.frame = frame;
    
    [self addSubview:left_hand];
    [self addSubview:right_hand];    
    
}

- (void)setInitialPosition {
    NSArray *current_coordinate = [coordinates objectAtIndex:chosenNode];
    float radians = [[current_coordinate objectAtIndex:4] floatValue];
    //we add PI/2 here since we calculated the radian values from 90 degrees (PI/2). 
    
    [UIView beginAnimations:@"begin" context:NULL];
    [UIView setAnimationDuration:0.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians + M_PI/2);
    
    left_hand.transform = transform;
    right_hand.transform = transform;
    
    [UIView commitAnimations];
}

//radians is the value of the selected node.
- (void)animateWithRadians:(float)radians {
    //group arrows together
    
    float animationDuration = 0.5f;
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"animations"]){
        animationDuration = 0.0f;
    }
    
    [UIView beginAnimations:@"closedHands" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    
    //we add PI/2 here since we calculated the radian values from 90 degrees (PI/2). 
    CGAffineTransform transform_left = CGAffineTransformMakeRotation(radians + M_PI/2);
    CGAffineTransform transform_right = CGAffineTransformMakeRotation(radians + M_PI/2);
    
    left_hand.transform = transform_left;
    right_hand.transform = transform_right;
    
    [UIView commitAnimations];
}

- (void)spreadHandsBasedOnPosition:(float)radians andValueOfNode:(int)nodeValue {
    
    float animationDuration = 0.5f;
    float delayDuration = 0.5f;
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"animations"]){
        animationDuration = 0.0f;
        delayDuration = 0.0f;
    }
    
    [UIView beginAnimations:@"spreadHands" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationDelay:delayDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    
    //we add PI/2 here since we calculated the radian values from 90 degrees (PI/2). 
    CGAffineTransform transform_left = CGAffineTransformMakeRotation(radians + (nodeValue * spacing) + M_PI/2);
    CGAffineTransform transform_right = CGAffineTransformMakeRotation(radians - (nodeValue * spacing) + M_PI/2);
    
    left_hand.transform = transform_left;
    right_hand.transform = transform_right;
    [UIView commitAnimations];
}

- (void)startAnimation {
    for(int i = 0; i < coordinates.count; i++){
        NSArray *current_coordinate = [coordinates objectAtIndex:i];
        if(i == chosenNode){
            current_position = [[current_coordinate objectAtIndex:4] floatValue];
            chosenNodeValue = [[nodes objectAtIndex:i] intValue];
            if(move_foward){
                [self animateWithRadians:current_position];
            }
            else {
                [self setInitialPosition];
            }
        }
    }
}

- (void)moveHandsBack {
    NSArray *current_coordinate = [coordinates objectAtIndex:chosenNode];
    float radians = [[current_coordinate objectAtIndex:4] floatValue];
    //we add PI/2 here since we calculated the radian values from 90 degrees (PI/2). 
    
    float animationDuration = 0.5f;
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"animations"]){
        animationDuration = 0.0f;
    }
    
    [UIView beginAnimations:@"begin" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians + M_PI/2);
    
    left_hand.transform = transform;
    right_hand.transform = transform;
    
    [UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if([animationID isEqualToString:@"closedHands"]){
        //NSLog(@"Waiting, then spreading hands...");
        [self spreadHandsBasedOnPosition:current_position andValueOfNode:chosenNodeValue];
    }
}

@end
