//
//  NIMGameViewController.m
//  NIMfor21Buttons
//
//  Created by Xin Gao on 1/29/13.
//  Copyright (c) 2013 Xin Gao. All rights reserved.
//
//  Some Notice:
//  * The game always starts with BLUE player.
//  * This is a 21-NIM game. Find the rules here : http://en.wikipedia.org/wiki/Nim
//  ***

#import "NIMGameViewController.h"
#import "NIMGameOverViewController.h"

#define BLUE_TERM 0
#define PURPLE_TERM 1

@interface NIMGameViewController ()
@property (strong, nonatomic) NSMutableArray *gameButtonArray;
@property (assign, nonatomic) NSInteger currentTerm; // -1:start game or error; 0:Blue; 1:Purple;
@property (assign, nonatomic) NSInteger positionHaveBeenUsed;
@property (assign, nonatomic) NSInteger positionCurrentSelected;
// The following array contains NSNumber(Type), which is the position of gameButtonArray
@property (strong, nonatomic) NSMutableArray *blueGameButtonArray;
@property (strong, nonatomic) NSMutableArray *purpleGameButtonArray;

- (void)initGameButtonArray;
- (void)changePlayer; // including just start-game settings
- (void)gameOver; // This is...hmm...Game Over!

- (IBAction)gameButtonPressed:(id)sender;

@end

@implementation NIMGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.gameButtonArray = [[NSMutableArray alloc] init];
        self.positionHaveBeenUsed = -1;
        self.positionCurrentSelected = -1;
        self.currentTerm = -1;
        
        self.blueGameButtonArray = [[NSMutableArray alloc] init];
        self.purpleGameButtonArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initGameButtonArray];
    
    // start game!
    // init game field
    [self changePlayer];
    // start animation
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Method

- (void)initGameButtonArray
{
    for (int tag = 301; tag < 322; tag++)
    {
        UIView *buttonView = [self.view viewWithTag:tag];
        UIButton *gameButton = (UIButton *)buttonView;
        gameButton.enabled = NO;
        // ______ADD PNG CHANGE HERE_______
        // ...
        [self.gameButtonArray addObject:gameButton];
    }
}

- (void)changePlayer
{
    // if just start
    if (self.currentTerm == -1)
    {
        self.currentTerm = BLUE_TERM;
    }
    else
    {
        self.currentTerm = self.currentTerm ? BLUE_TERM : PURPLE_TERM;
    }
    
    // set buttons
    for (UIButton *aButton in self.gameButtonArray)
    {
        aButton.enabled = NO;
    }
    for (int offset = 1; offset < 4; offset++)
    {
        if ((self.positionHaveBeenUsed + offset) >= 21)
        {
            break;
        }
        UIButton *aButton = [self.gameButtonArray objectAtIndex:(self.positionHaveBeenUsed + offset)];
        aButton.enabled = YES;
        [aButton addTarget:self action:@selector(gameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // do the animation
}

- (void)gameOver
{
    NIMGameOverViewController *gameOverViewController = [[NIMGameOverViewController alloc] init];
    gameOverViewController.delegate = self;
    [self presentViewController:gameOverViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark Animations


#pragma mark -
#pragma mark Button Actions

- (IBAction)pause:(id)sender
{
    [super dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmAndGo:(id)sender
{
    // error judgement
    if (self.currentTerm == -1)
    {
        NSLog(@"Something wrong with the player term. Error Detail: the current term is not Blue either Purple.");
        return;
    }
    if (self.positionCurrentSelected == -1)
    {
        NSLog(@"You must choose 1-3 buttons to continue!");
        return;
    }
    
    
    // save player selection
    for (int i = self.positionCurrentSelected; i > self.positionHaveBeenUsed; i--)
    {
        if (self.currentTerm == BLUE_TERM)
        {
            [self.blueGameButtonArray addObject:[NSNumber numberWithInt:i]];
        }
        else if (self.currentTerm == PURPLE_TERM)
        {
            [self.purpleGameButtonArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    // reset position and num of selection
    self.positionHaveBeenUsed = self.positionCurrentSelected;
    self.positionCurrentSelected = -1;
    
    // Whether game is over
    if (self.positionHaveBeenUsed == 20) // from 0..20, so there are 21 buttons have been pushed
    {
        [self gameOver];
    }
    
    // change player
    [self changePlayer];
    
}

- (IBAction)gameButtonPressed:(id)sender
{
    UIButton *theButton = (UIButton *)sender;
    // set button selected image HERE
    // ...
    
    self.positionCurrentSelected = [self.gameButtonArray indexOfObject:theButton];
    for (int i = self.positionCurrentSelected -1; i > self.positionHaveBeenUsed; i--)
    {
        //UIButton *aButton = [self.gameButtonArray objectAtIndex:i];
        // set button selected image HERE
        // ...
    }
}

#pragma mark -
#pragma mark Public Methods
- (void)dismissViewControllerToMenu
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [super dismissViewControllerAnimated:NO completion:nil];
}

@end
