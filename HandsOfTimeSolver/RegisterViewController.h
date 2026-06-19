//
//  RegisterViewController.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 4/5/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate, NSURLConnectionDelegate, UIAlertViewDelegate> {
    IBOutlet UITextField *username;
    IBOutlet UIButton *backgroundButton;
    IBOutlet UIButton *registerButton;
    IBOutlet UIActivityIndicatorView *indicator;
    NSMutableData *received_data;
}

@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UIButton *backgroundButton;
@property (nonatomic, retain) UIButton *registerButton;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSMutableData *received_data;

- (IBAction)backgroundButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
- (void)sendUsername;

@end
