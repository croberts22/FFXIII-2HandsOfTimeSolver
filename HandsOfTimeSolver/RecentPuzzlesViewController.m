//
//  RecentPuzzlesViewController.m
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 4/3/12.
//  Copyright (c) 2012 University of Texas at Austin. All rights reserved.
//

#import "RecentPuzzlesViewController.h"
#import "CJSONDeserializer.h"
#import "Puzzle.h"
#import "AppDelegate.h"
#import "GANTracker.h"
#import "SolutionViewController.h"
#import "HandsOfTimeViewController.h"
#import "ASIHTTPRequest.h"
#import "Common.h"

@interface RecentPuzzlesViewController ()

@end

@implementation RecentPuzzlesViewController

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define TEXT_FONT_SIZE ( IS_IPAD ? 20.0f : 16.0f )
#define DETAIL_TEXT_FONT_SIZE ( IS_IPAD ? 14.0f : 12.0f )
#define CELL_SIZE ( IS_IPAD ? 80.0f : 60.0f )

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@synthesize refreshButton, backButton, puzzlesTable, puzzles, since, num_updated_rows, timer, indicator, status, updateLabel, totalPuzzles, userPuzzles, total_count, user_count;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Memory Management

- (void)dealloc {
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [[GANTracker sharedTracker] trackPageview:@"Recent Puzzles (RecentPuzzlesViewController)" withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackground];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.savedSequence = @"";
    
    self.since = 0;
    self.num_updated_rows = 0;
    self.total_count = 0;
    self.user_count = 0;
    self.puzzlesTable.alpha = 0.0f;
    self.updateLabel.alpha = 0.0f;
    self.userPuzzles.alpha = 0.0f;
    self.totalPuzzles.alpha = 0.0f;
    
    [self.indicator startAnimating];
    
    self.puzzlesTable.backgroundColor = [UIColor clearColor];
    
    if(puzzles == nil){
        self.puzzles = [[[NSMutableArray alloc] init] autorelease];
    }

    [self connect];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [timer invalidate];
    timer = nil;
}

- (void)validateTimer {
    NSLog(@"Starting timer.");
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(connect) userInfo:nil repeats:YES];
}

- (void)invalidateTimer {
    NSLog(@"Stopping timer.");
    [timer invalidate];
    timer = nil;
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

- (void)createBackground {
    //Create the gradient and add it to our view's root layer
    UIColor *colorOne = [UIColor colorWithRed:0.0 green:0.125 blue:0.18 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:0.0 green:0.00 blue:0.05 alpha:1.0];
    CAGradientLayer *gradientLayer = [[[CAGradientLayer alloc] init] autorelease];
    gradientLayer.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil]];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}


- (void)connect {
    [self showLoadingStatus];
    [self performSelectorOnMainThread:@selector(displayIndicator) withObject:nil waitUntilDone:YES];
    NSString *API_Call = [NSString stringWithFormat:@"%@timestamp=%d&username=%@", API_UPDATE_LIST, since, [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    NSLog(@"API Request: %@", API_Call);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_Call]];
    
    [request setCompletionBlock:^{
        if([[request responseString] isEqualToString:@"No new puzzles."]){
            NSLog(@"No new data.");
        }
        else{
            NSLog(@"Parsing new puzzles...");
            NSError *error;
            NSDictionary *results = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:&error];
            [self parseResults:results];
        }
        
        if([puzzles count] == 0){
            [self showErrorStatus];
        }
        else {
            [self hideStatus];
        }
        
        [self hideIndicator];
        if(timer == nil){
            [self validateTimer];
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"Request failed! Reason: %@", [[request error] localizedDescription]);
        [self showErrorStatus];
        [self hideIndicator];
        if(timer == nil){
            [self validateTimer];
        }
    }];
    
    [request startAsynchronous];
}

- (NSArray *)convertStringToArray:(NSString *)solution {
    NSArray *values = [solution componentsSeparatedByString:@","];
    NSMutableArray *result = [NSMutableArray array];
    for(int i = 0; i < values.count; i++) {
        int value = [[values objectAtIndex:i] intValue];
        [result addObject:[NSNumber numberWithInt:value]];
    }
    return result;
}

- (NSString *)expandString:(NSString *)sequence {
    NSString *result = @"";
    for(int i = 0; i < sequence.length; i++){
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%c ", [sequence characterAtIndex:i]]];
    }
    //NSLog(@"Result: %@", result);
    return result;
}

- (void)parseResults:(NSDictionary *)results {
    
    num_updated_rows = 0;
    
    BOOL total_count_captured = FALSE;
    
    for(NSDictionary *item in results) {
        if(!total_count_captured) {
            total_count = [[item objectForKey:@"total_count"] intValue];
            user_count = [[item objectForKey:@"user_count"] intValue];
            total_count_captured = TRUE;
            continue;
        }
        
        Puzzle *puzzle = [[[Puzzle alloc] init] autorelease];
        puzzle.sequence = [item objectForKey:@"sequence"];
        puzzle.string_sequence = [self expandString:puzzle.sequence];
        puzzle.solution = [self convertStringToArray:[item objectForKey:@"solution"]];
        puzzle.user = [item objectForKey:@"user"];
        puzzle.timestamp = [[item objectForKey:@"timestamp"] intValue];
        puzzle.string_timestamp = [self convertTimestampToDate:puzzle.timestamp];
        
        if(since != 0){
            num_updated_rows++;
        }
        
        if(since == 0) {
            [puzzles addObject:puzzle];
        }
        else {
            [puzzles insertObject:puzzle atIndex:0];
        }
    }
    
    if(since == 0){
        [self displayTable];
    }
    else {
        [self updateTableRows];
    }
    
    [self updateTimestamp];
    [self setUserPuzzlesText];
    [self setTotalPuzzlesText];
    [self showUpdateLabel];
    
    if(timer == nil){
        [self validateTimer];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [puzzles count] > 50 ? 50 : [puzzles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_SIZE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:TEXT_FONT_SIZE];
    cell.textLabel.textColor = UIColorFromRGB(0xCFCFCF);
    
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:DETAIL_TEXT_FONT_SIZE];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uitableviewselection-blue-44.png"]] autorelease];
    Puzzle *puzzle = [puzzles objectAtIndex:indexPath.row];
    NSString *submission = [NSString stringWithFormat:@"Submitted by %@ on %@", puzzle.user, puzzle.string_timestamp];
    
    cell.textLabel.text = puzzle.string_sequence;
    cell.detailTextLabel.text = submission;
    
    return cell;
}

- (NSString *)convertTimestampToDate:(int)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [format stringFromDate:date];
    return dateString;
}
                           
- (void)updateTimestamp{
    NSString *timestampString = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    self.since = [timestampString intValue];
}


- (void)displayTable {
    float delay = 0.5f;
    [puzzlesTable reloadData];
    [UIView beginAnimations:@"displayNewsTable" context:NULL];
    [UIView setAnimationDuration:delay];
    self.puzzlesTable.alpha = 1.0f;
    self.indicator.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)hideStatus {
    float delay = 0.5f;
    [UIView beginAnimations:@"hideStatus" context:NULL];
    [UIView setAnimationDuration:delay];
    self.status.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)showErrorStatus {
    self.status.text = @"No puzzles found. :(";
}

- (void)showLoadingStatus {
    self.status.text = @"Loading puzzles...";
}

- (void)showUpdateLabel {
    float duration = 1.0f;
    [UIView beginAnimations:@"displayUpdateLabel" context:NULL];
    [UIView setAnimationDelay:duration];
    [UIView setAnimationDuration:duration];
    self.updateLabel.alpha = 1.0f;
    self.userPuzzles.alpha = 1.0f;
    self.totalPuzzles.alpha = 1.0f;
    [UIView commitAnimations];
}

- (int)findUserPuzzles {
    int i = 0;
    for(Puzzle *puzzle in puzzles){
        if([puzzle.user isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]){
            i++;
        }
    }
    
    return i;
}

- (void)setUserPuzzlesText {
    self.userPuzzles.text = [NSString stringWithFormat:@"Your Puzzles Solved: %d", user_count];
}

- (void)setTotalPuzzlesText {
    self.totalPuzzles.text = [NSString stringWithFormat:@"Total Puzzles Solved: %d", total_count];
}

- (void)hideIndicator {
    float delay = 0.5f;
    [UIView beginAnimations:@"hideIndicator" context:NULL];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationDuration:delay];
    self.indicator.alpha = 0.0f;
    self.refreshButton.alpha = 1.0f;
    self.refreshButton.enabled = YES;
    [UIView commitAnimations];
}

- (void)displayIndicator {
    float delay = 0.5f;
    [UIView beginAnimations:@"displayIndicator" context:NULL];
    [UIView setAnimationDuration:delay];
    self.indicator.alpha = 1.0f;
    self.refreshButton.alpha = 0.6f;
    self.refreshButton.enabled = NO;
    [UIView commitAnimations];
}

- (void)addNewPuzzle {
    Puzzle *puzzle = [[[Puzzle alloc] init] autorelease];
    puzzle.sequence = @"1,2,3,4,5";
    puzzle.string_sequence = [self expandString:puzzle.sequence];
    puzzle.solution = [self convertStringToArray:@"1,2,3,4,5"];
    puzzle.user = @"test_post";
    puzzle.timestamp = 1386828000;
    puzzle.string_timestamp = [self convertTimestampToDate:puzzle.timestamp];
    
    if(since != 0){
        num_updated_rows++;
    }
    
    [puzzles insertObject:puzzle atIndex:0];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self invalidateTimer];
    [self connect];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTableRows {
    NSMutableArray *pathsToAdd = [NSMutableArray array];
    NSMutableArray *pathsToRemove = [NSMutableArray array];
    
    for(int i = 0; i < num_updated_rows; i++) {
        NSIndexPath *addPath = [NSIndexPath indexPathForRow:i inSection:0];
        NSIndexPath *removePath = [NSIndexPath indexPathForRow:49-i inSection:0];
        
        [pathsToAdd addObject:addPath];
        [pathsToRemove addObject:removePath];
    }
    if(pathsToAdd.count > 0){
        [self.puzzlesTable beginUpdates];
        [self.puzzlesTable insertRowsAtIndexPaths:pathsToAdd withRowAnimation:UITableViewRowAnimationTop];
        [self.puzzlesTable deleteRowsAtIndexPaths:pathsToRemove withRowAnimation:UITableViewRowAnimationFade];
        [self.puzzlesTable endUpdates];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSArray *saved_solution = [[puzzles objectAtIndex:indexPath.row] solution];
    NSString *saved_sequence = [[puzzles objectAtIndex:indexPath.row] sequence];
    
    if(delegate.is_iPad){
        SolutionViewController *SVC = [[[SolutionViewController alloc] initWithNibName:@"iPadSolutionViewController" bundle:[NSBundle mainBundle]] autorelease];
        
        SVC.solutions = saved_solution;
        SVC.nodes = [HandsOfTimeViewController createNumbersArray:saved_sequence];
        
        [delegate presentDetailModalView:SVC withPresentation:UIModalPresentationFormSheet];
    }
    else{
        delegate.savedSequence = saved_sequence;
        delegate.savedSolution = saved_solution;
        
        [self.puzzlesTable deselectRowAtIndexPath:indexPath animated:YES];       
        [self.navigationController popViewControllerAnimated:YES];
    } 
}

@end
