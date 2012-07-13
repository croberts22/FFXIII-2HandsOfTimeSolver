//
//  AppDelegate.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/21/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HandsOfTimeViewController;
@class RecentPuzzlesViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIImageView *splashView;
    NSString *savedSequence;
    NSArray *savedSolution;
    BOOL is_iPad;
}

@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) NSString *savedSequence;
@property (nonatomic, retain) NSArray *savedSolution;
@property (nonatomic, assign) BOOL is_iPad;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) RecentPuzzlesViewController *masterViewController;

@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) HandsOfTimeViewController *viewController;


- (void)presentModalView:(UIViewController *)vc withTransition:(UIModalTransitionStyle)transition;
- (void)presentDetailModalView:(UIViewController *)vc withPresentation:(UIModalPresentationStyle)presentation;
- (void)popModalView;


@end
