//
//  Puzzle.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 4/3/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Puzzle : NSObject {
    NSString *sequence;
    NSArray *solution;
    NSString *user;
    NSString *string_timestamp;
    NSString *string_sequence;
    int timestamp;
}

@property (nonatomic, retain) NSString *sequence;
@property (nonatomic, retain) NSArray *solution;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *string_timestamp;
@property (nonatomic, retain) NSString *string_sequence;
@property (nonatomic) int timestamp;

@end
