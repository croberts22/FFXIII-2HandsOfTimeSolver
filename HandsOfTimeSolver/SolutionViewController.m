//
//  SolutionViewController.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 2/25/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "SolutionViewController.h"
#import "AppDelegate.h"
#import "RRSGlowLabel.h"
#import "GANTracker.h"
#import <math.h>

#import "UIColor+FF.h"

@implementation SolutionViewController

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define CENTER_X (self.nodeView.center.x)
#define CENTER_Y (self.nodeView.center.y)

#define IPAD_PADDING (70)
#define IPHONE_PADDING (40) 

#define RADIUS (self.view.frame.size.width/2 - ( IS_IPAD ? IPAD_PADDING : IPHONE_PADDING ) )

#define FRAME_DIMENSION ( IS_IPAD ? 80.0f : 50.0f )
#define INNER_FRAME_DIMENSION (sqrt(pow((FRAME_DIMENSION/2.0),2)+pow((FRAME_DIMENSION/2.0),2)))
#define FRAME_RADIUS (FRAME_DIMENSION/2.0f)

#define NUMBER_FONT_SIZE ( IS_IPAD ? 56.0f : 32.0f )

@synthesize solutions, nodes, coordinates, directions, writtenSolution, finishedSteps, solveAnotherButton, backButton, nextButton, currentStep, nodeView, handsView, selectedNodeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Solution (SolutionViewController)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nodeView.tag = 100;
    self.nodeView.nodes = self.nodes;
    
    self.handsView.tag = 100;
    self.handsView.nodes = self.nodes;
    self.handsView.move_foward = YES;
    
    self.selectedNodeView.tag = 100;
    self.selectedNodeView.nodes = self.nodes;
    
    self.writtenSolution.text = @"";
    self.currentStep = 0;
    
    if(self.coordinates == nil){
        self.coordinates = [[[NSArray alloc] init] autorelease];
    }
    if(self.finishedSteps == nil){
        self.finishedSteps = [[[NSMutableArray alloc] init] autorelease];
    }
    
    self.backButton.enabled = NO;
    
    [self createBackground];
    [self createDirectionalArray];
    [self.handsView drawHands];
    [self createGraphicSolution];
    [self beginDisplayingSolution];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if(delegate.is_iPad){
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else{
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

/****************
 IBAction Methods
 ****************/

- (IBAction)solveAnotherButtonPressed:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate popModalView];
}

- (IBAction)backButtonPressed:(id)sender {
    self.handsView.move_foward = NO;
    if(currentStep != 0){
        [finishedSteps removeLastObject];
        if(!self.nextButton.enabled){
            self.nextButton.enabled = YES;
            [self precipitateHandsView];
        }
        currentStep--;
        if(currentStep == 0){
            self.backButton.enabled = NO;
        }
        //fix this
        [self displayStep:currentStep];
        [self.handsView startAnimation];
    }
}

- (IBAction)nextButtonPressed:(id)sender {
    self.handsView.move_foward = YES;
    if(currentStep != solutions.count){
        [finishedSteps addObject:[solutions objectAtIndex:currentStep]];
        
        if(!self.backButton.enabled){
            self.backButton.enabled = YES;
        }
        currentStep++;
        if(currentStep == solutions.count){
            self.nextButton.enabled = NO;
            [self dissolveHandsView];
        }
        
        [self.handsView startAnimation];
        [self displayStep:currentStep];
    }
}

- (void)dissolveHandsView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.handsView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)precipitateHandsView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.handsView.alpha = 1.0f;
    [UIView commitAnimations];
}


- (void)createDirectionalArray {
    if(self.directions == nil){
        self.directions = [[[NSArray alloc] init] autorelease];
    }
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < solutions.count; i++){
        if(i == solutions.count-1){
            [result addObject:@"final"];
            break;
        }
        else{
            int current_index = [[solutions objectAtIndex:i] intValue];
            int next_index = [[solutions objectAtIndex:i+1] intValue];
            int value = [[nodes objectAtIndex:current_index] intValue];
            
            
            if(next_index == ((current_index - value) + solutions.count)){
                [result addObject:@"left "];
            }
            else if(next_index == (current_index - value)){
                [result addObject:@"left "];
            }  
            else if(next_index == ((current_index + value) - solutions.count)){
                [result addObject:@"right "];
            }
            else if(next_index == (current_index + value)){
                [result addObject:@"right "];
            }
            else [result addObject:@""];
            
        }
    }
    
    self.directions = [NSArray arrayWithArray:result];
}

- (void)createWrittenSolution {
    for (int i = 0; i < solutions.count-1; i++){
        NSString *step = [NSString stringWithFormat:@"Step %d: Choose the node with value %d and move %@ to the node with value %d.", i+1, [nodes objectAtIndex:[[solutions objectAtIndex:i] intValue]], [directions objectAtIndex:i], [nodes objectAtIndex:[[solutions objectAtIndex:i] intValue]]];
        self.writtenSolution.text = [NSString stringWithFormat:@"%@\n%@", self.writtenSolution.text, step];
    }
    
    //last step
    self.writtenSolution.text = @"Last step: Choose the final node.";
}
- (void)createGraphicSolution {
    //draw nodes
    [self drawNodes];
}

/****************
 Drawing Methods
 ****************/

- (void)createBackground {
    //Create the gradient and add it to our view's root layer
    UIColor *colorOne = [UIColor colorWithRed:0.0 green:0.125 blue:0.18 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:0.0 green:0.00 blue:0.05 alpha:1.0];
    CAGradientLayer *gradientLayer = [[[CAGradientLayer alloc] init] autorelease];
    gradientLayer.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil]];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)drawNodes {
    NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 0; i < solutions.count; i++){
        NSArray *current_coordinates = [self getPositionForNode:i];
        [results addObject:current_coordinates];

        if([finishedSteps containsObject:[NSNumber numberWithInt:i]]){
            continue;      
        }
        
        RRSGlowLabel *node = [[[RRSGlowLabel alloc] init] autorelease];
        float x = [[current_coordinates objectAtIndex:2] floatValue];
        float y = [[current_coordinates objectAtIndex:3] floatValue];
        node.tag = i;
        
        NSString *value = [NSString stringWithFormat:@"%d", [[nodes objectAtIndex:i] intValue]];
        
        CGRect frame = CGRectMake(x, y, INNER_FRAME_DIMENSION, INNER_FRAME_DIMENSION);
        
        node.text = value;
        node.textAlignment = UITextAlignmentCenter;
        node.font = [UIFont fontWithName:@"Cochin" size:NUMBER_FONT_SIZE];
        node.frame = frame;
        
        switch([[nodes objectAtIndex:i] intValue]){
            case 1:
                node.textColor = node.glowColor = [UIColor FFColorRed];
                break;
            case 2:
                node.textColor = node.glowColor = [UIColor FFColorOrange];
                break;
            case 3:
                node.textColor = node.glowColor = [UIColor FFColorGreen];
                break;
            case 4:
                node.textColor = node.glowColor = [UIColor FFColorTurquoise];
                break;
            case 5:
                node.textColor = node.glowColor = [UIColor FFColorPurple];
                break;
            case 6:
                node.textColor = node.glowColor = [UIColor FFColorPink];
                break;
            default:
                node.textColor = node.glowColor = [UIColor FFColorTurquoise];
        }

        node.glowOffset = CGSizeMake(0.0, 0.0);
        node.glowAmount = 10.0f;
        node.backgroundColor = [UIColor clearColor];
        [self.view addSubview:node];
        
        
        if(i == self.selectedNodeView.highlightedNodeToChoose) {
            // create button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake([[current_coordinates objectAtIndex:0] floatValue] - FRAME_DIMENSION/2, 
                                      [[current_coordinates objectAtIndex:1] floatValue] - FRAME_DIMENSION/2, 
                                      FRAME_DIMENSION, 
                                      FRAME_DIMENSION);
            button.tag = i;
            [button addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:button];
        }

    }
    self.coordinates = [NSArray arrayWithArray:results];
    self.nodeView.coordinates = self.coordinates;
    self.handsView.coordinates = self.coordinates;
    self.selectedNodeView.coordinates = self.coordinates;
    
}

- (void)displayStep:(int)step {
    NSString *text;
    
    //show success message
    if(step == solutions.count){
        text = @"Solved! :) Click 'Solve Another' to do another one!";
        self.selectedNodeView.highlightedNodeToChoose = -1;
        self.selectedNodeView.highlightedNodeNotToChoose = -1;
    }
    //this is the last step
    else{ 
        if(step == solutions.count-1){
            text = @"Last step: Choose the final node.";
        }
        else{
            text = [NSString stringWithFormat:@"Step %d: Choose the node with value %d and move %@to the node with the value %d.", step+1, [[nodes objectAtIndex:[[solutions objectAtIndex:step] intValue]] intValue], [directions objectAtIndex:step], [[nodes objectAtIndex:[[solutions objectAtIndex:step+1] intValue]] intValue]];   
        }
        
        self.selectedNodeView.highlightedNodeToChoose = [[solutions objectAtIndex:step] intValue];
        if(step == 0 || step == solutions.count){
            self.selectedNodeView.highlightedNodeNotToChoose = -1;
        }
        else {
            self.selectedNodeView.highlightedNodeNotToChoose = [self determineNextNode:step-1];
        }
        
        self.handsView.chosenNode = [[solutions objectAtIndex:step] intValue];
        
        if(step == 0){
            [self.handsView setInitialPosition];
        }
    }
        
    self.writtenSolution.text = text;
    
    [self.selectedNodeView setNeedsDisplay];
    [self redrawNodes];
}

- (int)determineNextNode:(int)step {
    
    int solution_index = [[solutions objectAtIndex:step] intValue];
    int node_value = [[nodes objectAtIndex:solution_index] intValue];
    
    int increased_value = solution_index + node_value;
    if(increased_value >= solutions.count){
        increased_value -= solutions.count;
    }
    
    int decreased_value = solution_index - node_value;
    if(decreased_value < 0){
        decreased_value += solutions.count;
    }
    
    if(increased_value == [[solutions objectAtIndex:step+1] intValue]){
        return decreased_value;
    }
    else return increased_value;
}

- (void)redrawNodes {
    
    for (UIView *subview in [self.view subviews]) {
        if(subview.tag < solutions.count){
            [subview removeFromSuperview];
        }
    }
    
    [self drawNodes];
}

- (void)beginDisplayingSolution {
    [self displayStep:currentStep];
}

/*************************
 Point Calculation Methods
 *************************/

- (NSArray *)getPositionForNode:(int)index {
    //calculate spacing between nodes.
    float spacing = 360.0 / [solutions count];
    self.handsView.spacing = spacing * M_PI / 180;
    float position = (-90 + (spacing * index)) * M_PI / 180;
    
    //these values correspond to the point in which the center of the node circle lies, on our imaginary outer circle.
    float origin_x = CENTER_X + RADIUS * cos(position);
    float origin_y = CENTER_Y + RADIUS * sin(position);
    //NSLog(@"x: %f y: %f", x, y);
    //NSLog(@"spacing: %f", spacing);
    
    //origin_x and origin_y are the values for the new origin of the soon-to-be-drawn node circle.
    //calculate the upper left point of this new circle (135 degrees)
    float x = origin_x + FRAME_DIMENSION/2.0 * cos(-135 * (M_PI/180));
    float y = origin_y + FRAME_DIMENSION/2.0 * sin(-135 * (M_PI/180));
    
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:origin_x], [NSNumber numberWithFloat:origin_y], [NSNumber numberWithFloat:x], [NSNumber numberWithFloat:y], [NSNumber numberWithFloat:position], nil];
}



@end
