//
//  SelectedNodeView.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 3/17/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedNodeView : UIView {
    NSArray *nodes;
    NSArray *coordinates;
    int highlightedNodeToChoose;
    int highlightedNodeNotToChoose;
}

@property (nonatomic, retain) NSArray *nodes;
@property (nonatomic, retain) NSArray *coordinates;
@property (nonatomic) int highlightedNodeToChoose;
@property (nonatomic) int highlightedNodeNotToChoose;

- (void)drawHighlightedChosenNode:(NSArray *)coordinate;
- (void)drawHighlightedNotChosenNode:(NSArray *)coordinate;
@end
