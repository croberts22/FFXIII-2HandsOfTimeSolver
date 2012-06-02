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
#import "RecentPuzzlesViewController.h"
#import "UIImage-Extensions.h"
#import "GANTracker.h"
#import "Appirater.h"

static const NSInteger kGANDispatchPeriodSec = 10;

@implementation AppDelegate

@synthesize splashView, savedSequence, savedSolution, is_iPad;

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController = _navController;
@synthesize splitViewController = _splitViewController;
@synthesize masterViewController = _masterViewController;

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
        self.is_iPad = NO;
        self.viewController = [[[HandsOfTimeViewController alloc] initWithNibName:@"HandsOfTimeViewController" bundle:nil] autorelease];
        self.navController = [[[UINavigationController alloc] initWithRootViewController:_viewController] autorelease];
        self.navController.navigationBarHidden = YES;
        
        self.window.rootViewController = self.navController;
        
        [Crittercism initWithAppID: @"4fca42c32cd952044200000b" andKey:@"fqnugix7tsa1mpahtlw3h9ckxeob" andSecret:@"m4doxelxwlfhnj1b5qskrpajc8iq76tv" andMainViewController:self.navController];

    } else {
        self.is_iPad = YES;
        self.masterViewController = [[[RecentPuzzlesViewController alloc] initWithNibName:@"iPadRecentPuzzlesViewController" bundle:[NSBundle mainBundle]] autorelease];
        self.viewController = [[[HandsOfTimeViewController alloc] initWithNibName:@"iPadHandsOfTimeViewController" bundle:nil] autorelease];
        
        self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
        
        _splitViewController.viewControllers = [NSArray arrayWithObjects:self.masterViewController, self.viewController, nil];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window addSubview:_splitViewController.view];
        
        [Crittercism initWithAppID: @"4fca42c32cd952044200000b" andKey:@"fqnugix7tsa1mpahtlw3h9ckxeob" andSecret:@"m4doxelxwlfhnj1b5qskrpajc8iq76tv" andMainViewController:self.splitViewController];
        
    }
    
    [self.window makeKeyAndVisible];
    [self fadeDefaultScreen];
    [self registerAppDefaults];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"registered"]){
        if(!is_iPad){
            RegisterViewController *RVC = [[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]] autorelease];
            [self presentModalView:RVC withTransition:UIModalTransitionStyleCoverVertical];
        }
        else{
            RegisterViewController *RVC = [[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]] autorelease];
            [self presentModalView:RVC withTransition:UIModalTransitionStyleCrossDissolve];
        }
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

static inline double radians (double degrees) { return degrees * M_PI / 180; }

- (void)fadeDefaultScreen {
    if(is_iPad){
        
        UIImage *image = [UIImage imageNamed:@"Default-Landscape.png"];        
        
        UIImage *rotated_image = [image imageRotatedByDegrees:90.0];
        
        /*
        UIGraphicsBeginImageContext(image.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            CGContextRotateCTM(context, radians(180));
        }
        
        [image drawAtPoint:CGPointMake(0, 0)];
         */
        
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width-20, self.window.frame.size.height)];
        splashView.image = rotated_image;
    }
    else{
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
        splashView.image = [UIImage imageNamed:@"Default.png"];     
    }
    
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

- (void)presentDetailModalView:(UIViewController *)vc withPresentation:(UIModalPresentationStyle)presentation {
    [vc setModalPresentationStyle:presentation];
    [self.splitViewController presentModalViewController:vc animated:YES];
}

- (void)popModalView {
    [self.viewController dismissModalViewControllerAnimated:YES];
    
    // If user is using iPad, deselect the cell in RecentPuzzlesViewController.
    if(is_iPad){
        RecentPuzzlesViewController *rpvc = [self.splitViewController.viewControllers objectAtIndex:0];
        NSIndexPath *selection = [rpvc.puzzlesTable indexPathForSelectedRow];
        if (selection) {
            [rpvc.puzzlesTable deselectRowAtIndexPath:selection animated:YES];
        }
    }
}

@end
