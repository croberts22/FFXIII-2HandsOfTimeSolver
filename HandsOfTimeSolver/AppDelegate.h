//
//  AppDelegate.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/21/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HandsOfTimeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIImageView *splashView;
    NSString *savedSequence;
    NSArray *savedSolution;
}

@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) NSString *savedSequence;
@property (nonatomic, retain) NSArray *savedSolution;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) HandsOfTimeViewController *viewController;


- (void)presentModalView:(UIViewController *)vc withTransition:(UIModalTransitionStyle)transition;
- (void)popModalView;


@end
