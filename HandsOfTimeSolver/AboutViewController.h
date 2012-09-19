//
//  AboutViewController.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/25/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ASIHTTPRequest.h"

@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate, UIWebViewDelegate, UITextFieldDelegate, ASIHTTPRequestDelegate> {
    IBOutlet UIButton *homeButton;
    IBOutlet UIWebView *about;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *yesButton;
    IBOutlet UIButton *noButton;
    IBOutlet UIButton *backgroundButton;
    IBOutlet UITextField *username;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *version;
}

@property (nonatomic, retain) UIButton *homeButton;
@property (nonatomic, retain) UIWebView *about;
@property (nonatomic, retain) UIButton *emailButton;
@property (nonatomic, retain) UIButton *yesButton;
@property (nonatomic, retain) UIButton *noButton;
@property (nonatomic, retain) UIButton *backgroundButton;
@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *version;

- (void)createBackground;
- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)yesButtonPressed:(id)sender;
- (IBAction)noButtonPressed:(id)sender;
- (IBAction)backgroundButtonPressed:(id)sender;

@end
