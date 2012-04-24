//
//  HandsOfTimeViewController.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/21/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRSGlowLabel.h"

/**
 Main class controller that represents the number input controller.
 @author Corey Roberts
 @version 1.0
 */
@interface HandsOfTimeViewController : UIViewController<UITextViewDelegate> {
    
    /**
     The solve button; used to push to the SolutionView.
     */
    IBOutlet UIButton *solveButton;
    
    /**
     The reset button; used to wipe user input.
     */
    IBOutlet UIButton *resetButton;
    
    /**
     The back button; used to remove the last character input.
     */
    IBOutlet UIButton *backButton;
    
    /**
     The view puzzles button; used to view puzzles people have input
     */
    IBOutlet UIButton *viewPuzzlesButton;
    
    /**
     The info button; used to display info about this app.
     Pushes into the AboutView.
     */
    IBOutlet UIButton *infoButton;
    
    /**
     @deprecated Originally used in conjunction with a UITextField.
     */
    IBOutlet UIButton *backgroundButton;    
    
    /**
     The one button, which places a one as input.
     */
    IBOutlet UIButton *oneButton;
    
    /**
     The two button, which places a two as input.
     */
    IBOutlet UIButton *twoButton;
    
    /**
     The three button, which places a three as input.
     */
    IBOutlet UIButton *threeButton;
    
    /**
     The four button, which places a four as input.
     */
    IBOutlet UIButton *fourButton;
    
    /**
     The five button, which places a five as input.
     */
    IBOutlet UIButton *fiveButton;
    
    /**
     The six button, which places a six as input.
     */
    IBOutlet UIButton *sixButton;
    
    /**
     The number field; holds the values that the user has input.
     */
    IBOutlet RRSGlowLabel *numberField;
    
    /**
     The status bar that displays whether or not a solution exists
     or if the user has committed an error.
     */
    IBOutlet UILabel *statusLabel;
    
    /**
     The rotating indicator to inform user that work is being done
     in the background.
     */
    IBOutlet UIActivityIndicatorView *indicator;
    
    /**
     The array that contains the list of numbers the user has input.
     */
    NSMutableArray *numbers;
    
    /**
     The array that contains the solution (denoted in node positions) 
     of the user's input.
     */
    NSArray *solution;
    
    /**
     Boolean that determines whether a user's number input has been solved.
     */
    BOOL solved;
    
    /**
     Boolean used that will display much more verbose data in the debugger output if
     its value is turned to YES.
     */
    BOOL debug;
    
    /**
     Boolean explictly only used for GHUnit testing.
     */
    BOOL GHUNIT_TESTING;
}

@property (nonatomic, retain) UIButton *solveButton;
@property (nonatomic, retain) UIButton *resetButton;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *viewPuzzlesButton;
@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) UIButton *backgroundButton;
@property (nonatomic, retain) UIButton *oneButton;
@property (nonatomic, retain) UIButton *twoButton;
@property (nonatomic, retain) UIButton *threeButton;
@property (nonatomic, retain) UIButton *fourButton;
@property (nonatomic, retain) UIButton *fiveButton;
@property (nonatomic, retain) UIButton *sixButton;
@property (nonatomic, retain) RRSGlowLabel *numberField;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@property (nonatomic, retain) NSMutableArray *numbers;
@property (nonatomic, retain) NSArray *solution;

@property (nonatomic) BOOL solved;
@property (nonatomic) BOOL debug;
@property (nonatomic) BOOL GHUNIT_TESTING;

//UI Methods
/**
 Creates a gradient background with two colors. 
 */
- (void)createBackground;

//UILabel Methods
/**
 Sets the text in the status bar.
 @param text The text to be displayed.
 */
- (void)setStatusLabelText:(NSString *)text;

/**
 Removes the text in the status bar.
 */
- (void)removeStatusLabelText;

//TextField Methods

/**
 Subtracts the last number from a container.
 @param group The container that contains numbers. 
 @return NSString of a substring of group.
 */
- (NSString *)subtractNumberFromGroup:(NSString *)group;

/**
 Appends a number to a container.
 @param group The container that contains numbers.
 @return NSString of a concatenation of the number to group.
 */
- (NSString *)addNumber:(NSString *)number toGroup:(NSString *)group;

//IBAction Methods

/**
 Disables all UI interaction while the puzzle is being solved.
 */
- (void)commitUIForSolving;

/**
 Enables all UI interaction after the puzzle is solved.
 */
- (void)revokeUIForSolving;

/**
 Action that commences after solveButton is pressed.
 This action causes the solving of the puzzle to begin.
 @see solvePuzzle
 @param sender The object that called this method.
 */
- (IBAction)solveButtonPressed:(id)sender;

/**
 Action that commences after resetButton is pressed.
 This action removes all numbers from the container.
 @param sender The object that called this method.
 */
- (IBAction)resetButtonPressed:(id)sender;

/**
 Action that commences after backButton is pressed.
 This action removes the last number from the container.
 @see subtractNumberFromGroup:
 @param sender The object that called this method.
 */
- (IBAction)backButtonPressed:(id)sender;

/**
 Action that commences after viewPuzzlesButton is pressed.
 This action pushes a new view that displays puzzles that
 this user, along with other users who are solving puzzles,
 in a table view.
 @param sender The object that called this method.
 */
- (IBAction)viewPuzzlesButtonPressed:(id)sender;

/**
 Action that commences after infoButton is pressed.
 This action pushes AboutView onto the screen.
 @param sender The object that called this method.
 */
- (IBAction)infoButtonPressed:(id)sender;

/**
 Action that commences after oneButton is pressed.
 This action adds a one to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)oneButtonPressed:(id)sender;

/**
 Action that commences after twoButton is pressed.
 This action adds a two to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)twoButtonPressed:(id)sender;

/**
 Action that commences after threeButton is pressed.
 This action adds a three to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)threeButtonPressed:(id)sender;

/**
 Action that commences after fourButton is pressed.
 This action adds a four to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)fourButtonPressed:(id)sender;

/**
 Action that commences after fiveButton is pressed.
 This action adds a five to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)fiveButtonPressed:(id)sender;

/**
 Action that commences after sixButton is pressed.
 This action adds a six to the container.
 @see addNumber:ToGroup:
 @param sender The object that called this method.
 */
- (IBAction)sixButtonPressed:(id)sender;

//Set Numbers Methods

/**
 Creates an array of user-input numbers from a string.
 @param string A string to be parsed into an array-based container.
 @return NSMutableArray of user-input numbers.
 */
- (NSMutableArray *)createNumbersArray:(NSString *)string;

/**
 Takes a character from a string at a given index and returns the the value in a primitive int form.
 @param values The string that contains the user-input numbers.
 @param i An index for the character to be parsed.
 @return NSNumber of the integer parsed from the string.
 */
- (NSNumber *)parseStringToInt:(NSString *)values atIndex:(int)i;

/**
 Takes the solution array and converts the result as a string by separating
 each integer solution with a comma.
 @return NSString with the solution separated by commas.
 */
- (NSString *)convertSolutionArrayToString;

/**
 Takes the puzzle and solution sequence and sends data to the server.
 @return NSString that contains the response from the server.
 */
- (NSString *)sendPuzzleToDatabase;

//Solve Puzzle Methods

/**
 Determines the results of the puzzle solving, once the puzzle has been attempted
 to solve.
 */
- (void)determineResults;

/**
 Takes data from the delegate (previously received data from RecentPuzzlesViewController)
 and displays the SolutionViewController with the selected data.
 */
- (void)solveImmediately;


/**
 Solves the puzzle that the user has input.
 */
- (void)solvePuzzle;

/**
 Recursively goes through the puzzle and determines the first possible solution.  The solver goes in a clock-wise position. The resulting array is saved in 'solutions' if a solution exists.
 @param index The position in the puzzle that the solver is currently looking at within the recursion.
 @param array An array that contains the numbers in the puzzle. Solved numbers are replaced with a -1 value.
 @param current_solution An array that contains the current solution (positional values) through the recursion.
 @param remaining An int that describes how many numbers are left to solve in the puzzle.
 */
- (void)atIndex:(int)index withArray:(NSMutableArray *)array andSolution:(NSArray *)current_solution solveWithRemaining:(int)remaining;



@end
