//
//  AboutViewController.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/25/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import "AboutViewController.h"
#import "RegexKitLite.h"
#import "ASIHTTPRequest.h"

@interface AboutViewController()
@property (nonatomic, retain) AppDelegate *delegate;
@end

@implementation AboutViewController

@synthesize homeButton, about, emailButton, yesButton, noButton, backgroundButton, username, indicator, version;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)createBackground {
    //Create the gradient and add it to our view's root layer
    UIColor *colorOne = [UIColor colorWithRed:0.0 green:0.125 blue:0.18 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:0.0 green:0.00 blue:0.05 alpha:1.0];
    CAGradientLayer *gradientLayer = [[[CAGradientLayer alloc] init] autorelease];
    gradientLayer.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width+703, SCREEN_HEIGHT);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil]];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"About/Settings (AboutViewController)" withError:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackground];
    
    self.indicator.alpha = 0.0f;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"animations"]){
        self.yesButton.selected = YES;
        self.noButton.selected = NO;
    }
    else{
        self.yesButton.selected = NO;
        self.noButton.selected = YES;
    }
    self.about.alpha = 0.0f;
    self.about.scrollView.bounces = NO;
    
    NSString *header;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        header = @"<body link=#00FFFF vlink=#00FFFF alink=#00FFFF><div style='text-align: center; font-family: \"Cochin\", \"Georgia\"; font-size: 12px; color: white; background-color: clear'>";
    }
    else{
        header = @"<body link=#00FFFF vlink=#00FFFF alink=#00FFFF><div style='text-align: center; font-family: \"Cochin\", \"Georgia\"; font-size: 24px; color: white; background-color: clear'>";
    }
    NSString *author = @"The Hands of Time Solver for Final Fantasy XIII-2 is designed by me, Corey Roberts!<br /><br />";
    NSString *why = @"I wrote this app because I know that many people consider the Hands of Time puzzle to be a very frustrating and time-consuming puzzle.  Many people guess and end up taking a lot of time on them. This app helps reduce that time so they can continue on with the story.<br /><br />";
    NSString *why2 = @"If you found a bug or some error in a solution, you can either submit it at this <a href='http://ffxiii-2handsoftimesolver.blogspot.com'>link</a> or send me an email directly. I also don't mind comments of appreciation or constructive criticism. Your contribution helps! :)<br /><br />";
    NSString *copyright = @"<br />The Final Fantasy XIII-2 logo and Mog are properties of Square Enix.<br />";
    NSString *footer = @"</div></body>";
    [self.about loadHTMLString:[NSString stringWithFormat:@"%@%@%@%@%@%@", header, author, why, why2, copyright, footer] baseURL:nil];
    
    NSString *versionString = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    self.version.text = versionString;
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

- (IBAction)homeButtonPressed:(id)sender {
    [delegate popModalView];
}

- (IBAction)emailButtonPressed:(id)sender {
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setToRecipients:[NSArray arrayWithObject:@"croberts22@utexas.edu"]];
        [mailVC setSubject:@"FFXIII-2 Solver Support"];
        [self presentModalViewController:mailVC animated:YES];
        [mailVC release];
    }
}


- (IBAction)backgroundButtonPressed:(id)sender {
    [self.username resignFirstResponder];
}

- (IBAction)yesButtonPressed:(id)sender {
    yesButton.selected = TRUE;
    noButton.selected = FALSE;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"animations"];
}

- (IBAction)noButtonPressed:(id)sender {
    yesButton.selected = FALSE;
    noButton.selected = TRUE;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"animations"];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([self.username.text isEqualToString:@""]){
        self.username.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.username.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]) {
        self.username.text = @"";
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.username.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]) {
        self.username.text = @"";
        [textField resignFirstResponder];
        return YES;
    }
    
    [self checkUsername];
    [textField resignFirstResponder];
    return YES;
}

- (void)checkUsername {
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

    NSString *API_Call = [NSString stringWithFormat:@"http://ffxiii-2.texasdrums.com/api/v1/update_user.php?old_username=%@&new_username=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], username.text];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_Call]];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:.5f animations:^{
        self.about.alpha = 1.0f;
    }];
}

#pragma mark - ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request {
    if([request.responseString isEqualToString:@"200 OK"]){
        NSLog(@"Username accepted.");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"registered"];
        [defaults setObject:self.username.text forKey:@"username"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Your username has been changed."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay."
                                              otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"username"];
    }
    else {
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
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    // Do nothing.
}

- (void)hideIndicator {
    if(self.indicator.alpha > 0.0f){
        float delay = 0.5f;
        [UIView beginAnimations:@"hideIndicator" context:NULL];
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

@end
