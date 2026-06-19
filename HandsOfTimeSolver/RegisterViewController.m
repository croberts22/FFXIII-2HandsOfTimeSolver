//
//  RegisterViewController.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 4/5/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegexKitLite.h"
#import "UILabel+FF.h"
#import "ASIHTTPRequest.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IPHONE_FONTSIZE (18)
#define IPAD_FONTSIZE (24)

@interface RegisterViewController ()
@property (nonatomic, retain) AppDelegate *delegate;
@end

@implementation RegisterViewController

@synthesize delegate;
@synthesize username, backgroundButton, registerButton, received_data, indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)createBackground {
    //Create the gradient and add it to our view's root layer
    UIColor *colorOne = [UIColor colorWithRed:0.0 green:0.125 blue:0.18 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:0.0 green:0.00 blue:0.05 alpha:1.0];
    CAGradientLayer *gradientLayer = [[[CAGradientLayer alloc] init] autorelease];
    
    gradientLayer.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil]];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Registration (RegisterViewController)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackground];
    self.indicator.alpha = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.username becomeFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    else{
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
}

- (IBAction)backgroundButtonPressed:(id)sender {
    [username resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self registerButtonPressed:nil];
    return YES;
}

- (void)hideIndicator {
    if(self.indicator.alpha > 0.0f){
        float delay = 0.5f;
        [UIView beginAnimations:@"hideIndicator" context:NULL];
        [UIView setAnimationDelay:delay];
        [UIView setAnimationDuration:delay];
        self.indicator.alpha = 0.0f;
        [UIView commitAnimations];
    }
}

- (void)displayIndicator {
    float delay = 0.5f;
    [UIView beginAnimations:@"displayIndicator" context:NULL];
    [UIView setAnimationDuration:delay];
    self.indicator.alpha = 1.0f;
    [UIView commitAnimations];
}

- (IBAction)registerButtonPressed:(id)sender {
    if([username.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Please enter a username."  
                                                       delegate:nil 
                                              cancelButtonTitle:@"Okay." 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release]; 
    }
    //check if username has any bad symbols
    else if([username.text isMatchedByRegex:@"[^a-zA-Z0-9]"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Your username contains invalid characters. Please only use alphanumeric characters."  
                                                       delegate:nil 
                                              cancelButtonTitle:@"Okay." 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else {
        [self sendUsername];
    }
}

- (void)sendUsername {
    [self performSelectorOnMainThread:@selector(displayIndicator) withObject:nil waitUntilDone:YES];
    

    NSString *API_Call = [NSString stringWithFormat:@"%@username=%@", API_REGISTER_USERNAME, username.text];

    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:API_Call]];
    NSLog(@"API Request: %@", API_Call);
    [request setCompletionBlock:^{
        NSString *data = [request responseString];
        if([data isEqualToString:@"200 OK"]){
            NSLog(@"Username accepted.");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"registered"];
            [defaults setObject:self.username.text forKey:@"username"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" 
                                                            message:@"Your username has been registered. Thanks!"
                                                           delegate:self 
                                                  cancelButtonTitle:@"Okay." 
                                                  otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        }
        else if([data isEqualToString:@"302 Username Taken"]){
            NSString *message = [NSString stringWithFormat:@"The username '%@' is already taken. Please choose another username.", self.username.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                            message:message
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Okay." 
                                                  otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        }
        
        [self hideIndicator];
    }];
    [request setFailedBlock:^ {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                        message:[NSString stringWithFormat:@"%@.", [[request error] localizedDescription]]
                                                       delegate:nil 
                                              cancelButtonTitle:@":( Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        [self hideIndicator];
    }];
    
    [request startAsynchronous];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [delegate popModalView];
}

@end
