//
//  AppDelegate.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/21/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "AppDelegate.h"

#import "HandsOfTimeViewController.h"
#import "RegisterViewController.h"
#import "GANTracker.h"
#import "Appirater.h"

static const NSInteger kGANDispatchPeriodSec = 10;

@implementation AppDelegate

@synthesize splashView, savedSequence, savedSolution;

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController = _navController;

- (void)dealloc
{
    [[GANTracker sharedTracker] stopTracker];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* Google Analytics */
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-30743118-1" 
                                           dispatchPeriod:kGANDispatchPeriodSec 
                                                 delegate:nil];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[HandsOfTimeViewController alloc] initWithNibName:@"HandsOfTimeViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[HandsOfTimeViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    
    self.navController = [[[UINavigationController alloc] initWithRootViewController:_viewController] autorelease];
    self.navController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    [self fadeDefaultScreen];
    [self registerAppDefaults];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"registered"]){
        RegisterViewController *RVC = [[[RegisterViewController alloc] init] autorelease];
        [self presentModalView:RVC withTransition:UIModalTransitionStyleCoverVertical];
    }
    
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)registerAppDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *objects = [[[NSArray alloc] initWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], nil] autorelease];
    NSArray *keys = [[[NSArray alloc] initWithObjects:@"animations", @"registered", nil] autorelease];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [defaults registerDefaults:appDefaults];
}

- (void)fadeDefaultScreen {
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"]; 
	[_window addSubview:splashView]; 
	[_window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:1.0]; 
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/* Modal View Controller Delegation */
- (void)presentModalView:(UIViewController *)vc withTransition:(UIModalTransitionStyle)transition {
    [vc setModalTransitionStyle:transition];
    [self.viewController presentModalViewController:vc animated:YES];
}

- (void)popModalView {
    [self.viewController dismissModalViewControllerAnimated:YES];
}

@end
