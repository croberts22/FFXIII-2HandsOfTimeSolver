//
//  Tests.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/22/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "HandsOfTimeViewController.h"
#import "SolutionViewController.h"

@interface SolverTests : GHTestCase { }
@property (retain) HandsOfTimeViewController *vc;
@end

@implementation SolverTests
@synthesize vc;

- (void)setUp {
    self.vc = [[HandsOfTimeViewController alloc] init];
    self.vc.GHUNIT_TESTING = YES;
}

- (void)tearDown {
    self.vc = nil;
}

- (void)testSubtractNumberFromGroup1 {
    NSString *result          = [vc subtractNumberFromGroup:@"1 2 3 4 5 "];
    NSString *expected_result = @"1 2 3 4 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testSubtractNumberFromGroup2 {
    NSString *result          = [vc subtractNumberFromGroup:@"1 2 3 4 5 6 7 8 9 "];
    NSString *expected_result = @"1 2 3 4 5 6 7 8 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testSubtractNumberFromGroup3 {
    NSString *result          = [vc subtractNumberFromGroup:@"1 "];
    NSString *expected_result = @"";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testSubtractNumberFromGroup4 {
    NSString *result          = [vc subtractNumberFromGroup:@"1 2 "];
    NSString *expected_result = @"1 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testAddNumberToGroup1 {
    NSString *number = @"1";
    NSString *group = @"";
    NSString *result          = [vc addNumber:number toGroup:group]; 
    NSString *expected_result = @"1 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testAddNumberToGroup2 {
    NSString *number = @"2";
    NSString *group = @"1 3 ";
    NSString *result          = [vc addNumber:number toGroup:group]; 
    NSString *expected_result = @"1 3 2 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testAddNumberToGroup3 {
    NSString *number = @"3";
    NSString *group = @"1 3 3 6 2 7 1 4 8 1 4 6 8 1 3 6 7 8 ";
    NSString *result          = [vc addNumber:number toGroup:group]; 
    NSString *expected_result = @"1 3 3 6 2 7 1 4 8 1 4 6 8 1 3 6 7 8 3 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testAddNumberToGroup4 {
    NSString *number = @"4";
    NSString *group = @"1 3 3 6 2 7 1 4 8 1 4 6 8 1 3 6 7 8 1 3 3 6 2 7 1 4 8 1 4 6 8 1 3 6 7 8 ";
    NSString *result          = [vc addNumber:number toGroup:group]; 
    NSString *expected_result = @"1 3 3 6 2 7 1 4 8 1 4 6 8 1 3 6 7 8 1 3 3 6 2 7 1 4 8 1 4 6 8 1 3 6 7 8 4 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testAddNumberToGroup5 {
    NSString *number = @"5";
    NSString *group = @"thisisgarbagetextbutitdoesntmattersincethiswillhaveafiveattheendyeah ";
    NSString *result          = [vc addNumber:number toGroup:group]; 
    NSString *expected_result = @"thisisgarbagetextbutitdoesntmattersincethiswillhaveafiveattheendyeah 5 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testAddNumberToGroup6 {
    NSString *number = @"0";
    NSString *group = @"1 2 3 4 5 ";
    NSString *result          = [vc addNumber:number toGroup:group]; 
    NSString *expected_result = @"1 2 3 4 5 ";
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue([result isEqualToString:expected_result], nil);
}

- (void)testResetButtonAction1 {
    vc.numberField.text= @"1 2 3 4 5 ";
    [vc resetButtonPressed:nil];
    NSString *result = vc.numberField.text;
    GHTestLog(@"result: %@", result);
    GHAssertNULL(result, nil);
}

- (void)testResetButtonAction2 {
    vc.numberField.text= NULL;
    [vc resetButtonPressed:nil];
    NSString *result = vc.numberField.text;
    GHTestLog(@"result: %@", result);
    GHAssertNULL(result, nil);
}

- (void)testResetButtonAction3 {
    vc.numberField.text= @"";
    [vc resetButtonPressed:nil];
    NSString *result = vc.numberField.text;
    GHTestLog(@"result: %@", result);
    GHAssertNULL(result, nil);
}

- (void)testAddRemoveResetSuite1 {
    NSString *number;
    NSString *group = @""; 
    
    NSString *result1 = @"1 2 3 4 5 6 7 8 9 ";
    NSString *result2 = @"1 2 3 4 5 ";
    NSString *result3 = NULL;
    
    //add
    for(int i = 0; i < 10; i++){
        number = [NSString stringWithFormat:@"%d", i];
        group = [vc addNumber:number toGroup:group];
    }
    GHTestLog(@"add 0-9: %@", group);
    GHAssertTrue([group isEqualToString:result1], nil);
    
    //remove
    for(int i = 0; i < 4; i++){
        group = [vc subtractNumberFromGroup:group];
    }
    GHTestLog(@"subtract last 4: %@", group);
    GHAssertTrue([group isEqualToString:result2], nil);
    
    //clear
    vc.numberField.text = group;
    [vc resetButtonPressed:nil];
    GHTestLog(@"clear: %@", vc.numberField.text);
    GHAssertTrue(vc.numberField.text == result3, nil);
}

- (void)testAddRemoveResetSuite2 {
    NSString *number;
    NSString *group = @""; 
    
    NSString *result1 = @"1 2 3 4 5 6 7 8 9 ";
    NSString *result2 = @"";
    NSString *result3 = NULL;
    
    //add
    for(int i = 0; i < 10; i++){
        number = [NSString stringWithFormat:@"%d", i];
        group = [vc addNumber:number toGroup:group];
    }
    GHTestLog(@"add all: %@", group);
    GHAssertTrue([group isEqualToString:result1], nil);
    
    //remove
    for(int i = 0; i < 10; i++){
        group = [vc subtractNumberFromGroup:group];
    }
    GHTestLog(@"subtract all: %@", group);
    GHAssertTrue([group isEqualToString:result2], nil);
    
    //clear
    vc.numberField.text = group;
    [vc resetButtonPressed:nil];
    GHTestLog(@"clear: %@", vc.numberField.text);
    GHAssertTrue(vc.numberField.text == result3, nil);
}

- (void)testParseStringToInt1 {
    NSNumber *result;
    NSNumber *expected_result = [NSNumber numberWithInt:1];
    NSString *string = @"1";
    int index = 0;
    result = [self.vc parseStringToInt:string atIndex:index];
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue(result == expected_result, nil);
}

- (void)testParseStringToInt2 {
    NSNumber *result;
    NSNumber *expected_result = [NSNumber numberWithInt:2];
    NSString *string = @"2";
    int index = 0;
    result = [self.vc parseStringToInt:string atIndex:index];
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue(result == expected_result, nil);
}

- (void)testParseStringToInt3 {
    NSNumber *result;
    NSNumber *expected_result = [NSNumber numberWithInt:5];
    NSString *string = @"123456789";
    int index = 4;
    result = [self.vc parseStringToInt:string atIndex:index];
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue(result == expected_result, nil);
}

- (void)testParseStringToInt4 {
    NSNumber *result;
    NSNumber *expected_result = [NSNumber numberWithInt:9];
    NSString *string = @"123456789";
    int index = 8;
    result = [self.vc parseStringToInt:string atIndex:index];
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    GHAssertTrue(result == expected_result, nil);
}

- (void)testParseStringToInt5 {
    NSNumber *result;
    NSNumber *expected_result;
    NSString *string = @"123456789";
    for(int index = 0; index < [string length]; index++){
        result = [self.vc parseStringToInt:string atIndex:index]; 
        expected_result = [NSNumber numberWithInt:index+1];
        GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
        GHAssertTrue(result == expected_result, nil);
    }    
}

- (void)testCreateNumbersArray1 {
    NSString *string = @"123";
    NSMutableArray *result;
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:1], 
                                [NSNumber numberWithInt:2], 
                                [NSNumber numberWithInt:3], nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    result = [self.vc createNumbersArray:string];

    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];

    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testCreateNumbersArray2 {
    NSString *string = @"123456789";
    NSMutableArray *result;
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:1], 
                                [NSNumber numberWithInt:2], 
                                [NSNumber numberWithInt:3], 
                                [NSNumber numberWithInt:4],
                                [NSNumber numberWithInt:5], 
                                [NSNumber numberWithInt:6],
                                [NSNumber numberWithInt:7], 
                                [NSNumber numberWithInt:8],
                                [NSNumber numberWithInt:9], nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    result = [self.vc createNumbersArray:string];
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testCreateNumbersArray3 {
    NSString *string = @"";
    NSMutableArray *result;
    NSArray *expected_result = NULL;
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    result = [self.vc createNumbersArray:string];
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testCreateNumbersArray4 {
    NSString *string = @"13579";
    NSMutableArray *result;
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:1], 
                                [NSNumber numberWithInt:3], 
                                [NSNumber numberWithInt:5], 
                                [NSNumber numberWithInt:7], 
                                [NSNumber numberWithInt:9], nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    result = [self.vc createNumbersArray:string];
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testCreateNumbersArray5 {
    NSString *string = @"1";
    NSMutableArray *result;
    NSArray *expected_result = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], nil];
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    result = [self.vc createNumbersArray:string];
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testSolvePuzzle1 {
    NSString *numbers = @"1 1 3 2 1";
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:0], 
                                [NSNumber numberWithInt:4], 
                                [NSNumber numberWithInt:3], 
                                [NSNumber numberWithInt:1], 
                                [NSNumber numberWithInt:2], nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    self.vc.numbers = [self.vc createNumbersArray:numbers];
    [self.vc solvePuzzle];
    NSArray *result = self.vc.solution;
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testSolvePuzzle2 {
    NSString *numbers = @"1";
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    self.vc.numbers = [self.vc createNumbersArray:numbers];
    [self.vc solvePuzzle];
    NSArray *result = self.vc.solution;
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testSolvePuzzle3 {
    NSString *numbers = @"1 1 1 1 1 1 1 1 1";
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:3],
                                [NSNumber numberWithInt:4],
                                [NSNumber numberWithInt:5],
                                [NSNumber numberWithInt:6],
                                [NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:8], nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    self.vc.numbers = [self.vc createNumbersArray:numbers];
    [self.vc solvePuzzle];
    NSArray *result = self.vc.solution;
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testSolvePuzzleReal1 {
    NSString *numbers = @"1 2 5 1 3 2 1 1 2 5";
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:9],
                                [NSNumber numberWithInt:4],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:3],
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:8],
                                [NSNumber numberWithInt:6], 
                                [NSNumber numberWithInt:5],
                                nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    self.vc.numbers = [self.vc createNumbersArray:numbers];
    [self.vc solvePuzzle];
    NSArray *result = self.vc.solution;
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testSolvePuzzleReal2 {
    NSString *numbers = @"5 4 1 1 3 3 4 2 2 1";
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:5],
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:3],
                                [NSNumber numberWithInt:4],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:9],
                                [NSNumber numberWithInt:8], 
                                [NSNumber numberWithInt:6],
                                nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    self.vc.numbers = [self.vc createNumbersArray:numbers];
    [self.vc solvePuzzle];
    NSArray *result = self.vc.solution;
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testSolvePuzzleReal3 {
    NSString *numbers = @"2 4 2 4 5 2 3 1 2 2";
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:4],
                                [NSNumber numberWithInt:9],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:5],
                                [NSNumber numberWithInt:3],
                                [NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:8], 
                                [NSNumber numberWithInt:6],
                                nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    self.vc.numbers = [self.vc createNumbersArray:numbers];
    [self.vc solvePuzzle];
    NSArray *result = self.vc.solution;
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testSolvePuzzleReal4 {
    NSString *numbers = @"3 1 2 4 1 6 6 6 2 6 3 2 6";
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:8],
                                [NSNumber numberWithInt:6],
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:10],
                                [NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:4],
                                [NSNumber numberWithInt:3], 
                                [NSNumber numberWithInt:12],
                                [NSNumber numberWithInt:5],
                                [NSNumber numberWithInt:11],
                                [NSNumber numberWithInt:9],
                                nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    self.vc.numbers = [self.vc createNumbersArray:numbers];
    [self.vc solvePuzzle];
    NSArray *result = self.vc.solution;
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

- (void)testSolvePuzzleReal5 {
    NSString *numbers = @"1 3 5 2 4 5 3 3 6 1 1 1 4";
    NSArray *expected_result = [NSArray arrayWithObjects:
                                [NSNumber numberWithInt:6],
                                [NSNumber numberWithInt:3],
                                [NSNumber numberWithInt:5],
                                [NSNumber numberWithInt:10],
                                [NSNumber numberWithInt:9],
                                [NSNumber numberWithInt:8],
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:4], 
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:11],
                                [NSNumber numberWithInt:12],
                                nil];
    
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:expected_result];
    
    self.vc.numbers = [self.vc createNumbersArray:numbers];
    [self.vc solvePuzzle];
    NSArray *result = self.vc.solution;
    
    GHTestLog(@"result: %@\nexpected_result: %@", result, expected_result);
    
    [intermediate removeObjectsInArray:result];
    
    GHAssertTrue([intermediate count] == 0, nil);
}

@end

@interface SolutionDisplayTests : GHTestCase { }
@property (retain) SolutionViewController *vc;
@end

@implementation SolutionDisplayTests

#define CENTER_X (160)
#define CENTER_Y (200)
#define RADIUS   (115)
#define FRAME_DIMENSION (50.0f)
#define INNER_FRAME_DIMENSION (sqrt(pow((FRAME_DIMENSION/2.0),2)+pow((FRAME_DIMENSION/2.0),2)))

@synthesize vc;

- (void)setUp {
    self.vc = [[SolutionViewController alloc] init];
}

- (void)tearDown {
    self.vc = nil;
}

- (void)testGetPositionForNode1 {
    //length = 1
    NSArray *sol = [[NSArray alloc] initWithObjects:@"obj1", nil];
    int index = 0;
    
    self.vc.solutions = sol;
    NSArray *result = [self.vc getPositionForNode:index];

    float spacing = 360.0 / [sol count];
    float expected_result = (-90.0 + (spacing * index)) * M_PI / 180;
    
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:4] floatValue], expected_result);
    
    GHAssertTrue([[result objectAtIndex:4] floatValue] == expected_result, nil);
}

- (void)testGetPositionForNode2 {
    //length = 15
    NSArray *sol = [[NSArray alloc] initWithObjects:@"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", nil];
    int index = 0;
    
    self.vc.solutions = sol;
    NSArray *result = [self.vc getPositionForNode:index];
    
    float spacing = 360.0 / [sol count];
    float expected_result = (-90.0 + (spacing * index)) * M_PI / 180;
    
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:4] floatValue], expected_result);
    
    GHAssertTrue([[result objectAtIndex:4] floatValue] == expected_result, nil);
}

- (void)testGetPositionForNode3 {
    //length = 30
    NSArray *sol = [[NSArray alloc] initWithObjects:@"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", nil];
    int index = 0;
    
    self.vc.solutions = sol;
    NSArray *result = [self.vc getPositionForNode:index];
    
    float spacing = 360.0 / [sol count];
    float expected_result = (-90.0 + (spacing * index)) * M_PI / 180;
    
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:4] floatValue], expected_result);
    
    GHAssertTrue([[result objectAtIndex:4] floatValue] == expected_result, nil);
}

- (void)testGetPositionForNode4 {
    //length = 40
    NSArray *sol = [[NSArray alloc] initWithObjects:@"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", nil];
    int index = 0;
    
    self.vc.solutions = sol;
    NSArray *result = [self.vc getPositionForNode:index];
    
    float spacing = 360.0 / [sol count];
    float expected_result = (-90.0 + (spacing * index)) * M_PI / 180;
    
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:4] floatValue], expected_result);
    
    GHAssertTrue([[result objectAtIndex:4] floatValue] == expected_result, nil);
}

- (void)testOriginPointsForNode1 {
    //length = 1
    NSArray *sol = [[NSArray alloc] initWithObjects:@"obj", nil];
    int index = 0;
    
    self.vc.solutions = sol;
    NSArray *result = [self.vc getPositionForNode:index];
    
    float spacing = 360.0 / [sol count];
    float position = (-90.0 + (spacing * index)) * M_PI / 180;
    
    float origin_x = CENTER_X + RADIUS * cos(position);
    float origin_y = CENTER_Y + RADIUS * sin(position);
    
    NSArray *expected_result = [NSArray arrayWithObjects:[NSNumber numberWithFloat:origin_x], [NSNumber numberWithFloat:origin_y], nil];
    
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:0] floatValue], [[expected_result objectAtIndex:0] floatValue]);
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:1] floatValue], [[expected_result objectAtIndex:1] floatValue]);                                        

    
    GHAssertTrue([[result objectAtIndex:0] floatValue] == [[expected_result objectAtIndex:0] floatValue], nil);
    GHAssertTrue([[result objectAtIndex:1] floatValue] == [[expected_result objectAtIndex:1] floatValue], nil);
}

- (void)testOriginPointsForNode2 {
    //length = 10
    NSArray *sol = [[NSArray alloc] initWithObjects:@"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", nil];
    int index = 0;
    
    self.vc.solutions = sol;
    NSArray *result = [self.vc getPositionForNode:index];
    
    float spacing = 360.0 / [sol count];
    float position = (-90.0 + (spacing * index)) * M_PI / 180;
    
    float origin_x = CENTER_X + RADIUS * cos(position);
    float origin_y = CENTER_Y + RADIUS * sin(position);
    
    NSArray *expected_result = [NSArray arrayWithObjects:[NSNumber numberWithFloat:origin_x], [NSNumber numberWithFloat:origin_y], nil];
    
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:0] floatValue], [[expected_result objectAtIndex:0] floatValue]);
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:1] floatValue], [[expected_result objectAtIndex:1] floatValue]);                                        
    
    
    GHAssertTrue([[result objectAtIndex:0] floatValue] == [[expected_result objectAtIndex:0] floatValue], nil);
    GHAssertTrue([[result objectAtIndex:1] floatValue] == [[expected_result objectAtIndex:1] floatValue], nil);
}

- (void)testOriginPointsForNode3 {
    //length = 30
    NSArray *sol = [[NSArray alloc] initWithObjects:@"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", nil];
    int index = 0;
    
    self.vc.solutions = sol;
    NSArray *result = [self.vc getPositionForNode:index];
    
    float spacing = 360.0 / [sol count];
    float position = (-90.0 + (spacing * index)) * M_PI / 180;
    
    float origin_x = CENTER_X + RADIUS * cos(position);
    float origin_y = CENTER_Y + RADIUS * sin(position);
    
    NSArray *expected_result = [NSArray arrayWithObjects:[NSNumber numberWithFloat:origin_x], [NSNumber numberWithFloat:origin_y], nil];
    
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:0] floatValue], [[expected_result objectAtIndex:0] floatValue]);
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:1] floatValue], [[expected_result objectAtIndex:1] floatValue]);                                        
    
    
    GHAssertTrue([[result objectAtIndex:0] floatValue] == [[expected_result objectAtIndex:0] floatValue], nil);
    GHAssertTrue([[result objectAtIndex:1] floatValue] == [[expected_result objectAtIndex:1] floatValue], nil);
}

- (void)testOriginPointsForNode4 {
    //length = 60
    NSArray *sol = [[NSArray alloc] initWithObjects:@"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", @"obj", nil];
    int index = 0;
    
    self.vc.solutions = sol;
    NSArray *result = [self.vc getPositionForNode:index];
    
    float spacing = 360.0 / [sol count];
    float position = (-90.0 + (spacing * index)) * M_PI / 180;
    
    float origin_x = CENTER_X + RADIUS * cos(position);
    float origin_y = CENTER_Y + RADIUS * sin(position);
    
    NSArray *expected_result = [NSArray arrayWithObjects:[NSNumber numberWithFloat:origin_x], [NSNumber numberWithFloat:origin_y], nil];
    
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:0] floatValue], [[expected_result objectAtIndex:0] floatValue]);
    GHTestLog(@"result: %f\nexpected_result: %f", [[result objectAtIndex:1] floatValue], [[expected_result objectAtIndex:1] floatValue]);                                        
    
    
    GHAssertTrue([[result objectAtIndex:0] floatValue] == [[expected_result objectAtIndex:0] floatValue], nil);
    GHAssertTrue([[result objectAtIndex:1] floatValue] == [[expected_result objectAtIndex:1] floatValue], nil);
}

@end

