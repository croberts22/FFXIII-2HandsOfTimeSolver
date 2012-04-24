//
//  HandsView.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 3/17/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandsView : UIView {
    UIImageView *left_hand;
    UIImageView *right_hand;
    
    NSArray *coordinates;
    NSArray *nodes;
    
    float spacing;
    float current_position;
    
    int chosenNode;
    int chosenNodeValue;
    
    BOOL move_foward;
}

@property (nonatomic, retain) UIImageView *left_hand;
@property (nonatomic, retain) UIImageView *right_hand;
@property (nonatomic, retain) NSArray *nodes;
@property (nonatomic, retain) NSArray *coordinates;
@property (nonatomic) int chosenNode;
@property (nonatomic) int chosenNodeValue;
@property (nonatomic) float spacing;
@property (nonatomic) float current_position;
@property (nonatomic) BOOL move_foward;

- (void)drawHands;
- (void)setInitialPosition;
- (void)animateWithRadians:(float)radians;
- (void)startAnimation;

@end
