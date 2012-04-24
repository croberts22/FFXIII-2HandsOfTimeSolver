//
//  NodeView.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 3/17/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodeView : UIView {
    NSArray *nodes;
    NSArray *coordinates;
}

@property (nonatomic, retain) NSArray *nodes;
@property (nonatomic, retain) NSArray *coordinates;

- (void)drawOuterCircle;
- (void)drawInnerCircle;
- (void)drawNode:(NSArray *)coordinate;

@end
