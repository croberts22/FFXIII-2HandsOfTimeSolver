//
//  RecentPuzzlesViewController.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 4/3/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RecentPuzzlesViewController : UIViewController<NSURLConnectionDelegate> {
    IBOutlet UITableView *puzzlesTable;
    IBOutlet UIButton *refreshButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *status;
    IBOutlet UILabel *updateLabel;
    NSMutableArray *puzzles;
    NSMutableData *received_data;
    NSTimer *timer;
    int since;
    int num_updated_rows;
}

@property (nonatomic, retain) UITableView *puzzlesTable;
@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UILabel *updateLabel;
@property (nonatomic, retain) NSMutableArray *puzzles;
@property (nonatomic, retain) NSMutableData *received_data;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) int since;
@property (nonatomic) int num_updated_rows;

@end
