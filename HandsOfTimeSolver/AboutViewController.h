//
//  AboutViewController.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/25/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate, UIWebViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate> {
    IBOutlet UIButton *homeButton;
    IBOutlet UIWebView *about;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *yesButton;
    IBOutlet UIButton *noButton;
    IBOutlet UIButton *backgroundButton;
    IBOutlet UITextField *username;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *version;
    NSMutableData *received_data;
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
@property (nonatomic, retain) NSMutableData *received_data;

- (void)createBackground;
- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)yesButtonPressed:(id)sender;
- (IBAction)noButtonPressed:(id)sender;
- (IBAction)backgroundButtonPressed:(id)sender;

@end
