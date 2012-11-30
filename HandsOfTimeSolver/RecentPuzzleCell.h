//
//  RecentPuzzleCell.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 11/28/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTAttributedLabel;

@interface RecentPuzzleCell : UITableViewCell {
    TTTAttributedLabel *puzzle;
    TTTAttributedLabel *details;
}

@property (nonatomic, strong) TTTAttributedLabel *puzzle;
@property (nonatomic, strong) TTTAttributedLabel *details;

- (void)setPuzzleText:(NSString *)string;
- (void)setDetailsText:(NSString *)string withUsername:(NSString *)username;

@end
