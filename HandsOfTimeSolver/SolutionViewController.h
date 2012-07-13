//
//  SolutionViewController.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/25/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NodeView.h"
#import "HandsView.h"
#import "SelectedNodeView.h"

/**
 Class that controls the solution and its children views (NodeView, SelectedNodeView, HandsView).
 @author Corey Roberts
 */
@interface SolutionViewController : UIViewController {
    NSArray *solutions;
    NSArray *nodes;
    NSArray *coordinates;
    NSArray *directions;
    NSMutableArray *finishedSteps;
    IBOutlet UITextView *writtenSolution;
    IBOutlet UIBarButtonItem *solveAnotherButton;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *nextButton;
    IBOutlet NodeView *nodeView;
    IBOutlet HandsView *handsView;
    IBOutlet SelectedNodeView *selectedNodeView;
    int currentStep;
}

@property (nonatomic, retain) NSArray *solutions;
@property (nonatomic, retain) NSArray *nodes;
@property (nonatomic, retain) NSArray *coordinates;
@property (nonatomic, retain) NSArray *directions;
@property (nonatomic, retain) NSMutableArray *finishedSteps;
@property (nonatomic, retain) UITextView *writtenSolution;
@property (nonatomic, retain) UIBarButtonItem *solveAnotherButton;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIBarButtonItem *nextButton;
@property (nonatomic, retain) NodeView *nodeView;
@property (nonatomic, retain) HandsView *handsView;
@property (nonatomic, retain) SelectedNodeView *selectedNodeView;
@property (nonatomic) int currentStep;

- (IBAction)solveAnotherButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

- (void)createDirectionalArray;
- (void)createWrittenSolution;
- (void)createGraphicSolution;

- (void)drawNodes;

- (NSArray *)getPositionForNode:(int)index;

@end
