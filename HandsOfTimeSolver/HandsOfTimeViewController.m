//
//  HandsOfTimeViewController.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/21/12.
//  Copyright (c) 2012 Corey Roberts. All rights reserved.
//

#import "HandsOfTimeViewController.h"
#import "SolutionViewController.h"
#import "AboutViewController.h"
#import "RecentPuzzlesViewController.h"
#import "Common.h"
#import "ASIHTTPRequest.h"

#import "AppDelegate.h"

// Google Analytics
#import "GANTracker.h"

// Categories
#import "UIColor+FF.h"

@implementation HandsOfTimeViewController

@synthesize solveButton, resetButton, viewPuzzlesButton, infoButton, backgroundButton,  oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, backButton;
@synthesize numberField, statusLabel, numbers, solution, solved, debug, indicator;
@synthesize GHUNIT_TESTING;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackground];
    
    // UI Setup.
    self.statusLabel.alpha = 0.0f;
    self.indicator.alpha = 1.0f;
    self.statusLabel.text = @"";
    self.numberField.text = @"";
    self.numberField.glowColor = [UIColor blueColor];
    self.numberField.glowOffset = CGSizeMake(0.0, 0.0);
    self.numberField.glowAmount = 20.0f;
    
    // Set button colors.
    [self.oneButton setTitleColor:[UIColor FFColorRed] forState:UIControlStateNormal];
    [self.twoButton setTitleColor:[UIColor FFColorOrange] forState:UIControlStateNormal];
    [self.threeButton setTitleColor:[UIColor FFColorGreen] forState:UIControlStateNormal];
    [self.fourButton setTitleColor:[UIColor FFColorTurquoise] forState:UIControlStateNormal];
    [self.fiveButton setTitleColor:[UIColor FFColorPurple] forState:UIControlStateNormal];
    [self.sixButton setTitleColor:[UIColor FFColorPink] forState:UIControlStateNormal];
    
    // Debug; turn on to see messages in console.
    self.debug = NO;
    
    // If testing with GHUnit, set to yes. Otherwise, this should always be set to no.
    self.GHUNIT_TESTING = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Google Analytics Tracker
    [[GANTracker sharedTracker] trackPageview:@"Input Screen (HandsOfTimeViewController)" withError:nil];
    
    // If we are coming back from RecentPuzzlesVieController, items are saved
    // within the delegate. Call them here.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if([delegate.savedSequence length] > 0){
        self.numbers = nil;   
        self.numberField.text = delegate.savedSequence;
        self.solution = delegate.savedSolution;
        if(debug) {
            NSLog(@"numberField: %@", numberField.text);
            NSLog(@"solution: %@", solution);
        }
        
        // Solve this puzzle as soon as the view appears.
        [self solveImmediately];
    }
    else{
        self.numberField.text = @"";
        self.solution = nil;
        self.numbers = nil;   
    }
    
    self.statusLabel.text = @"";
    self.statusLabel.alpha = 0.0f;
    self.solved = NO;
    
    self.GHUNIT_TESTING = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    else{
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
}

/**
 Creates a gradient background with two colors. 
 */
- (void)createBackground {
    // Create the gradient and add it to our view's root layer.
    UIColor *colorOne = [UIColor colorWithRed:0.0 green:0.125 blue:0.18 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:0.0 green:0.00 blue:0.05 alpha:1.0];
    CAGradientLayer *gradientLayer = [[[CAGradientLayer alloc] init] autorelease];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        gradientLayer.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
        gradientLayer.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 832.0f);
    }
    
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil]];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

/**************************
 UILabel Methods
 **************************/

/**
 Sets the text in the status bar.
 @param text The text to be displayed.
 */
- (void)setStatusLabelText:(NSString *)text {
    [UIView beginAnimations:@"updateStatusLabelAndFadeIn" context:nil];
    [UIView setAnimationDuration:0.50f];
    self.statusLabel.text = text;
    self.statusLabel.alpha = 1.0f;
    [UIView commitAnimations];
}

/**
 Removes the text in the status bar.
 */
- (void)removeStatusLabelText {
    [UIView beginAnimations:@"fadeOut" context:nil];
    [UIView setAnimationDuration:0.50f];
    self.statusLabel.alpha = 0.0f;
    [UIView commitAnimations];  
}

/**
 Subtracts the last number from a container.
 @param group The container that contains numbers. 
 */
- (NSString *)subtractNumberFromGroup:(NSString *)group {
    //this condition should never hit, but it has been added for unit testing.
    if(group.length == 0) 
        return group;
    assert(group.length > 0);
    return [NSString stringWithFormat:@"%@", [group substringToIndex:[group length] - 2]];    
}

/**
 Appends a number to a container.
 @param group The container that contains numbers.
 */
- (NSString *)addNumber:(NSString *)number toGroup:(NSString *)group {
    //this condition should never hit, but it has been added for unit testing.
    if([number isEqualToString:@"0"])
        return group;
    return [NSString stringWithFormat:@"%@%@ ", group, number];   
}

/****************
 UI Methods
 ****************/

/* NOTE: These functions must be performed on the main thread. */

/**
 Disables all UI interaction while the puzzle is being solved.
 */
- (void)commitUIForSolving {
    [self removeStatusLabelText];
    [self.indicator startAnimating];
    [UIView beginAnimations:@"startIndicator" context:nil];
    [UIView setAnimationDuration:0.50f];
    self.indicator.alpha = 1.0f;
    [UIView commitAnimations];  
    [self setStatusLabelText:@"Attempting to solve..."];
    self.oneButton.enabled = NO;
    self.twoButton.enabled = NO;
    self.threeButton.enabled = NO;
    self.fourButton.enabled = NO;
    self.fiveButton.enabled = NO;
    self.sixButton.enabled = NO;
    self.resetButton.enabled = NO;
    self.solveButton.enabled = NO;
    self.backButton.enabled = NO;
    self.infoButton.enabled = NO;
}

/**
 Enables all UI interaction after the puzzle is solved.
 */
- (void)revokeUIForSolving {
    [UIView beginAnimations:@"endIndicator" context:nil];
    [UIView setAnimationDuration:0.50f];
    self.indicator.alpha = 0.0f;
    [UIView commitAnimations];  
    self.oneButton.enabled = YES;
    self.twoButton.enabled = YES;
    self.threeButton.enabled = YES;
    self.fourButton.enabled = YES;
    self.fiveButton.enabled = YES;
    self.sixButton.enabled = YES;
    self.resetButton.enabled = YES;
    self.solveButton.enabled = YES;
    self.backButton.enabled = YES;
    self.infoButton.enabled = YES;
}

/****************
 IBAction Methods
 ****************/

/**
 Action that commences after solveButton is pressed.
 This action causes the solving of the puzzle to begin.
 @see solvePuzzle
 @param sender The object that called this method.
 */
- (IBAction)solveButtonPressed:(id)sender {
    self.numbers = [HandsOfTimeViewController createNumbersArray:numberField.text];
    if(self.numbers.count == 0){
        [self performSelectorOnMainThread:@selector(setStatusLabelText:) withObject:@"Please input some numbers." waitUntilDone:NO];
        return;
    }
    
    [self performSelectorOnMainThread:@selector(commitUIForSolving) withObject:nil waitUntilDone:YES];
    [self performSelectorInBackground:@selector(solvePuzzle) withObject:nil];
}

/**
 Action that commences after resetButton is pressed.
 This action removes all numbers from the container.
 @param sender The object that called this method.
 */
- (IBAction)resetButtonPressed:(id)sender {
    if(self.statusLabel.alpha == 1.0f) {
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
    }
    self.numberField.text = @"";
}

/**
 Action that commences after backButton is pressed.
 This action removes the last number from the container.
 @see subtractNumberFromGroup:
 @param sender The object that called this method.
 */
- (IBAction)backButtonPressed:(id)sender {
    if([self.numberField.text length] == 0){
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
        return;
    }
    if(self.statusLabel.alpha == 1.0f) {
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
    }
    self.numberField.text = [numberField.text substringToIndex:[numberField.text length]-1];
}

/**
 Action that commences after viewPuzzlesButton is pressed.
 This action pushes a new view that displays puzzles that
 this user, along with other users who are solving puzzles,
 in a table view.
 @param sender The object that called this method.
 */
- (IBAction)viewPuzzlesButtonPressed:(id)sender {
    RecentPuzzlesViewController *RPVC = [[RecentPuzzlesViewController alloc] init];
    [self.navigationController pushViewController:RPVC animated:YES];
    [RPVC release];
}

/**
 Action that commences after infoButton is pressed.
 This action pushes AboutView onto the screen.
 @param sender The object that called this method.
 */
- (IBAction)infoButtonPressed:(id)sender {
    AboutViewController *AVC;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        AVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
        [delegate presentModalView:AVC withTransition:UIModalTransitionStyleCrossDissolve];
    }
    else{
        AVC = [[AboutViewController alloc] initWithNibName:@"iPadAboutViewController" bundle:[NSBundle mainBundle]];
        [delegate presentModalView:AVC withTransition:UIModalTransitionStylePartialCurl];
    }
    
    [AVC release];
}

/*
 * Potential refactoring fix can be made here.
 * Make all buttons respond to one IBAction, 
 * and based on its textLabel, assign the proper
 * number.
 */

/**
 Action that commences after oneButton is pressed.
 This action adds a one to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)oneButtonPressed:(id)sender {
    if([self.numberField.text length] == 15) {
        [self performSelectorOnMainThread:@selector(setStatusLabelText:) withObject:@"Maximum limit is 15 numbers." waitUntilDone:NO];
        return;
    }
    else if([self.numberField.text length] == 0 && self.statusLabel.alpha == 1.0f) {
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
    }
    self.numberField.text = [NSString stringWithFormat:@"%@%d", self.numberField.text, 1];    
}

/**
 Action that commences after twoButton is pressed.
 This action adds a two to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)twoButtonPressed:(id)sender {
    if([self.numberField.text length] == 15) {
        [self performSelectorOnMainThread:@selector(setStatusLabelText:) withObject:@"Maximum limit is 15 numbers." waitUntilDone:NO];
        return;
    }
    else if([self.numberField.text length] == 0 && self.statusLabel.alpha == 1.0f) {
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
    }
    self.numberField.text = [NSString stringWithFormat:@"%@%d", self.numberField.text, 2];
}

/**
 Action that commences after threeButton is pressed.
 This action adds a three to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)threeButtonPressed:(id)sender {
    if([self.numberField.text length] == 15) {
        [self performSelectorOnMainThread:@selector(setStatusLabelText:) withObject:@"Maximum limit is 15 numbers." waitUntilDone:NO];
        return;
    }
    else if([self.numberField.text length] == 0 && self.statusLabel.alpha == 1.0f) {
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
    }
    self.numberField.text = [NSString stringWithFormat:@"%@%d", self.numberField.text, 3];
}

/**
 Action that commences after fourButton is pressed.
 This action adds a four to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)fourButtonPressed:(id)sender {
    if([self.numberField.text length] == 15) {
        [self performSelectorOnMainThread:@selector(setStatusLabelText:) withObject:@"Maximum limit is 15 numbers." waitUntilDone:NO];
        return;
    }
    else if([self.numberField.text length] == 0 && self.statusLabel.alpha == 1.0f) {
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
    }
    self.numberField.text = [NSString stringWithFormat:@"%@%d", self.numberField.text, 4];
}

/**
 Action that commences after fiveButton is pressed.
 This action adds a five to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)fiveButtonPressed:(id)sender {
    if([self.numberField.text length] == 15) {
        [self performSelectorOnMainThread:@selector(setStatusLabelText:) withObject:@"Maximum limit is 15 numbers." waitUntilDone:NO];
        return;
    }
    else if([self.numberField.text length] == 0 && self.statusLabel.alpha == 1.0f) {
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
    }
    self.numberField.text = [NSString stringWithFormat:@"%@%d", self.numberField.text, 5];
}

/**
 Action that commences after sixButton is pressed.
 This action adds a six to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)sixButtonPressed:(id)sender {
    if([self.numberField.text length] == 15) {
        [self performSelectorOnMainThread:@selector(setStatusLabelText:) withObject:@"Maximum limit is 15 numbers." waitUntilDone:NO];
        return;
    }
    else if([self.numberField.text length] == 0 && self.statusLabel.alpha == 1.0f) {
        [self performSelectorOnMainThread:@selector(removeStatusLabelText) withObject:nil waitUntilDone:NO];
    }
    self.numberField.text = [NSString stringWithFormat:@"%@%d", self.numberField.text, 6];
}


/****************
 Data Methods
 ****************/

/**
 Creates an array of user-input numbers from a string.
 @param string A string to be parsed into an array-based container.
 */
+ (NSMutableArray *)createNumbersArray:(NSString *)string {
    NSString *values = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i = 0; i < [values length]; i++){
        NSNumber *value = [HandsOfTimeViewController parseStringToInt:values atIndex:i];
        [result addObject:value];
    }
    return [result autorelease];
}

/**
 Takes a character from a string at a given index and returns the the value in a primitive int form.
 @param values The string that contains the user-input numbers.
 @param i An index for the character to be parsed.
 */
+ (NSNumber *)parseStringToInt:(NSString *)values atIndex:(int)i { 
    int result = [[NSString stringWithFormat:@"%@", [values substringWithRange:NSMakeRange(i, 1)]] intValue];
    return [NSNumber numberWithInt:result];
}

/**
 Takes the solution array and converts the result as a string by separating
 each integer solution with a comma.
 */
- (NSString *)convertSolutionArrayToString {    
    NSString *result = @"";
    for(int i = 0; i < solution.count; i++){
        if(i == 0) {
            result = [NSString stringWithFormat:@"%d", [[solution objectAtIndex:i] intValue]];
        }
        else {
            result = [NSString stringWithFormat:@"%@,%d", result, [[solution objectAtIndex:i] intValue]];
        }
    }

    return result;
}

/****************
 Network Methods
 ****************/

/**
 Takes the puzzle and solution sequence and sends data to the server.
 */
- (void)sendPuzzleToDatabase {
    if(!GHUNIT_TESTING){
        NSString *API_Call = [NSString stringWithFormat:@"%@pattern=%@&solution=%@&user=%@", API_SUBMIT_PUZZLE, numberField.text, [self convertSolutionArrayToString], [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
        NSLog(@"API Request: %@", API_Call);
        
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_Call]];
        
        [request setCompletionBlock:^{
            NSLog(@"Puzzle request completed. Status: %@", [request responseString]);
        }];
        [request setFailedBlock:^{
            NSLog(@"Puzzle request failed. Status: %@", [[request error] localizedDescription]);
        }];
        
        [request startAsynchronous];
    }
}


/**
 Determines the results of the puzzle solving, once the puzzle has been attempted
 to solve.
 */
- (void)determineResults {
    [self performSelectorOnMainThread:@selector(revokeUIForSolving) withObject:nil waitUntilDone:YES];
    if(self.solution == nil){
        [self performSelectorOnMainThread:@selector(setStatusLabelText:) withObject:@"No solution exists!" waitUntilDone:NO];
    }
    else{
        if(debug) NSLog(@"Solution: %@", self.solution);
        
        [self sendPuzzleToDatabase];
        
        // Do not push the view if we are testing in GHUnit.
        if(!GHUNIT_TESTING){
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            SolutionViewController *SVC;
            if(delegate.is_iPad){
                SVC = [[SolutionViewController alloc] initWithNibName:@"iPadSolutionViewController" bundle:[NSBundle mainBundle]];
            }
            else{
                SVC = [[SolutionViewController alloc] initWithNibName:@"SolutionViewController" bundle:[NSBundle mainBundle]];                
            }
            
            SVC.solutions = self.solution;
            SVC.nodes = self.numbers;

            if(delegate.is_iPad){
                [delegate presentDetailModalView:SVC withPresentation:UIModalPresentationFormSheet];
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeStatusLabelText) userInfo:nil repeats:NO];
                [self resetButtonPressed:nil];
            }
            else{
                [delegate presentModalView:SVC withTransition:UIModalTransitionStyleCrossDissolve];    
            }
            
            delegate.savedSequence = @"";
            [SVC release];
            
        }
    }
}

/**
 Takes data from the delegate (previously received data from RecentPuzzlesViewController)
 and displays the SolutionViewController with the selected data.
 */
- (void)solveImmediately {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    SolutionViewController *SVC = [[SolutionViewController alloc] init];
    self.solution = delegate.savedSolution;
    self.numberField.text = delegate.savedSequence;
    self.numbers = [HandsOfTimeViewController createNumbersArray:numberField.text];

    SVC.solutions = delegate.savedSolution;
    SVC.nodes = self.numbers;
    
    [delegate presentModalView:SVC withTransition:UIModalTransitionStyleCrossDissolve];
    [SVC release];
    
    delegate.savedSolution = nil;
    delegate.savedSequence = @"";
}

/**
 Solves the puzzle that the user has input.
 */
- (void)solvePuzzle {
    solved = FALSE;
    NSMutableArray *empty = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.numbers.count && !solved; i++){
        NSMutableArray *numbersCopy = [NSMutableArray arrayWithArray:numbers];
        [self atIndex:i withArray:numbersCopy andSolution:empty solveWithRemaining:self.numbers.count];
        if(self.solution == nil){
            NSLog(@"No solution exists for starting at position %d with value %d", i, [[numbers objectAtIndex:i] intValue]);
            [empty removeAllObjects];
        }
    }
    [empty release];
    
    if(self.solution == nil){
        NSLog(@"********************************************");
        NSLog(@"No solution found.");
        NSLog(@"********************************************");
    }
    
    [self performSelectorOnMainThread:@selector(determineResults) withObject:nil waitUntilDone:NO];
}

/**
 Recursively goes through the puzzle and determines the first possible solution.  The solver goes in a clock-wise position. The resulting array is saved in 'solutions' if a solution exists.
 @param index The position in the puzzle that the solver is currently looking at within the recursion.
 @param array An array that contains the numbers in the puzzle. Solved numbers are replaced with a -1 value.
 @param current_solution An array that contains the current solution (positional values) through the recursion.
 @param remaining An int that describes how many numbers are left to solve in the puzzle.
 */
- (void)atIndex:(int)index withArray:(NSMutableArray *)array andSolution:(NSArray *)current_solution solveWithRemaining:(int)remaining {
    
    // If position is -1, we've hit a dead end.
    if([array objectAtIndex:index] == [NSNumber numberWithInt:-1]){
        if(debug) NSLog(@"Dead end! Backing up.");
        return;
    }
    
    // Instantiate variables.
    NSNumber *move_value = [array objectAtIndex:index];
    NSNumber *new_position;
    
    // Replace value with -1 to make it as used.
    [array replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:-1]]; 
    /* 
     * Create a copy of the array to pass to the left arrow case.
     * arrays in this case are mutable, so once they are modified within 
     * the recursive stack, they will be modified when returning upward.
     */
    NSMutableArray *copyOfArray = [[[NSMutableArray alloc] initWithArray:array copyItems:YES] autorelease];
   
    // Add index to solution.
    current_solution = [current_solution arrayByAddingObject:[NSNumber numberWithInt:index]];
    if(debug) NSLog(@"Current Index Solution: %@", current_solution);
    
    remaining--;
    
    if(remaining == 0 && (current_solution.count == numbers.count)){
        NSLog(@"********************************************");
        NSLog(@"Solution found!");
        NSLog(@"********************************************");
        self.solved = TRUE;
        self.solution = current_solution;
        return;
    }
    else{
        // Recursive. Check the right arrow first (moving index to the left).
        if(index - [move_value intValue] < 0){
            new_position = [NSNumber numberWithInt:(index - [move_value intValue]) + array.count];
        }
        else{
            new_position = [NSNumber numberWithInt:(index - [move_value intValue])];
        }
        
        while([new_position intValue] < 0){
            new_position = [NSNumber numberWithInt:[new_position intValue] + array.count];   
        }

        if(debug){
            NSLog(@"new_position: %@", new_position);
            NSLog(@"Current Position: %d, Value: %d", index, [move_value intValue]);
            NSLog(@"(Left) Moving to position %d from position %d.", [new_position intValue], index);
        }
        
        [self atIndex:[new_position intValue] withArray:array andSolution:current_solution solveWithRemaining:remaining];
        if(solved) return;
        
        // Left arrow (moving index to the right)
        if(index + [move_value intValue] > (array.count - 1)){
            new_position = [NSNumber numberWithInt:(index + [move_value intValue]) - array.count];
        }
        else{
            new_position = [NSNumber numberWithInt:(index + [move_value intValue])];
        }
        
        while([new_position intValue] > array.count - 1){
            new_position = [NSNumber numberWithInt:[new_position intValue] - array.count];
        }
        
        if(debug) {
            NSLog(@"new_position: %@", new_position);
            NSLog(@"Current Position: %d, Value: %d", index, [move_value intValue]);
            NSLog(@"(Right) Moving to position %d from position %d.", [new_position intValue], index);   
        }
        
        [self atIndex:[new_position intValue] withArray:copyOfArray andSolution:current_solution solveWithRemaining:remaining];
        if(solved) return;
    }
    
    return;
}

@end
