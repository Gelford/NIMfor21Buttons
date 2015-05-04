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
#define TIME_LIMIT 15

@interface NIMGameViewController ()
@property (strong, nonatomic) NSMutableArray *gameButtonArray;
@property (assign, nonatomic) NSInteger currentTerm; // -1:start game or error; 0:Blue; 1:Purple;
@property (assign, nonatomic) NSInteger positionHaveBeenUsed;
@property (assign, nonatomic) NSInteger positionCurrentSelected;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger timeCount;
@property (assign, nonatomic) BOOL inAnimation;
@property (assign, nonatomic) BOOL startAITerm;
@property (assign, nonatomic) BOOL isPaused;
// The following array contains NSNumber(Type), which is the position of gameButtonArray
@property (strong, nonatomic) NSMutableArray *blueGameButtonArray;
@property (strong, nonatomic) NSMutableArray *purpleGameButtonArray;

- (void)initGameButtonArray;
- (void)changePlayer; // including just start-game settings
- (void)gameOver; // This is...hmm...Game Over!
- (void)doAITerm;

// animation methods
- (void)changePlayerAnimation;
- (void)timesUpAnimation;
- (void)gameOverAnimation;

- (IBAction)gameButtonPressed:(id)sender;

@end

@implementation NIMGameViewController
@synthesize AIEngine;

#pragma mark -
#pragma mark Public Methods
- (void)dismissViewControllerToMenu
{
    self.currentTerm = -1;
    self.positionCurrentSelected = -1;
    self.positionHaveBeenUsed = -1;
    [self.gameButtonArray removeAllObjects];
    [self.blueGameButtonArray removeAllObjects];
    [self.purpleGameButtonArray removeAllObjects];
    self.timeCount = TIME_LIMIT;
    [self.timer invalidate];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [super dismissViewControllerAnimated:NO completion:nil];
}

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
        self.inAnimation = NO;
        self.startAITerm = NO;
        self.isPaused = NO;
        self.AITerm = arc4random()%2;
        
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
    
    // Set panel size
    [self.pausePanel setFrame:CGRectMake(0, 0,
                                         [[UIScreen mainScreen] applicationFrame].size.width,
                                         [[UIScreen mainScreen] applicationFrame].size.height+20)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Methods

- (void)initGameButtonArray
{
    for (int tag = 301; tag < 322; tag++)
    {
        UIView *buttonView = [self.view viewWithTag:tag];
        UIButton *gameButton = (UIButton *)buttonView;
        gameButton.enabled = NO;
        [self.gameButtonArray addObject:gameButton];
    }
}

- (NSInteger)reverseTerm:(NSInteger)term
{
    if (term == BLUE_TERM)
    {
        return PURPLE_TERM;
    }
    else
    {
        return BLUE_TERM;
    }
}

- (void)changePlayer
{
    // if just start
    if (self.AIEngine != nil)
    {
        if (self.currentTerm == -1)
        {
            self.currentTerm = BLUE_TERM;
            if (self.currentTerm == self.AITerm)
            {
                [self.termLabel setText:@"AI Term"];
                self.startAITerm = YES;
            }
            else
            {
                [self.termLabel setText:@"Your Term"];
            }
        }
        else
        {
            if (self.currentTerm == self.AITerm)
            {
                self.currentTerm = [self reverseTerm:self.currentTerm];
                [self.termLabel setText:@"Your Term"];
            }
            else
            {
                self.currentTerm = self.AITerm;
                [self.termLabel setText:@"AI Term"];
                self.startAITerm = YES;
            }
        }
    }
    else
    {
        if (self.currentTerm == -1)
        {
            self.currentTerm = BLUE_TERM;
            [self.termLabel setText:@"Blue Term"];
        }
        else
        {
            if (self.currentTerm == BLUE_TERM)
            {
                self.currentTerm = PURPLE_TERM;
                [self.termLabel setText:@"Purple Term"];
            }
            else if (self.currentTerm == PURPLE_TERM)
            {
                self.currentTerm = BLUE_TERM;
                [self.termLabel setText:@"Blue Term"];
            }
        }
    }
    
    self.timeCount = TIME_LIMIT;
    [self.timeLabel setText:[NSString stringWithFormat:@"%lds",(long)self.timeCount]];
    
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
    [self changePlayerAnimation];
}

- (void)doAITerm
{
    self.positionCurrentSelected = [self.AIEngine selectCircleWith:self.positionHaveBeenUsed];
    [self gameButtonPressed:[self.gameButtonArray objectAtIndex:self.positionCurrentSelected]];
    [self confirmAndGo:nil];
}

- (void)gameOver
{
    NIMGameOverViewController *gameOverViewController = [[NIMGameOverViewController alloc] init];
    gameOverViewController.delegate = self;
    gameOverViewController.AITerm = self.AITerm;
    [gameOverViewController createResultMatrixWithBlueArray:self.blueGameButtonArray
                                             andPurpleArray:self.purpleGameButtonArray];
    [gameOverViewController setLoser:self.currentTerm];
    [self presentViewController:gameOverViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark Animations

- (IBAction)animationDidStop:(id)sender
{
    // reset infoLabe position
    [self.infoLabel setFrame:CGRectMake(320, 53, 250, 44)];
    
    self.infoPanel.hidden = YES;
    
    self.inAnimation = NO;
    
    if (self.timeCount == 0)
    {
        if (self.positionCurrentSelected == -1)
        {
            self.positionCurrentSelected = self.positionHaveBeenUsed+1;
        }
        [self gameButtonPressed:[self.gameButtonArray objectAtIndex:self.positionCurrentSelected]];
        [self confirmAndGo:nil];
    }
    else if (self.positionHaveBeenUsed == 20)
    {
        [self gameOver];
    }
    else if (self.startAITerm)
    {
        [self doAITerm];
        self.startAITerm = NO;
    }
}

- (IBAction)animationPart2:(id)sender
{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:)];
    [self.infoLabel setFrame:CGRectMake(-320, 53, 250, 44)];
    [UIView commitAnimations];
}

- (IBAction)animationPart1:(id)sender
{
    self.infoPanel.hidden = NO;
    self.inAnimation = YES;
    
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDidStopSelector:@selector(animationPart2:)];
    [self.infoLabel setFrame:CGRectMake(50, 53, 250, 44)];
    [UIView commitAnimations];
}

- (void)changePlayerAnimation
{
    if (self.AIEngine != nil)
    {
        if (self.currentTerm == self.AITerm)
        {
            [self.infoLabel setText:@"AI Term"];
        }
        else
        {
            [self.infoLabel setText:@"Your Term"];
        }
    }
    else
    {
        if (self.currentTerm == BLUE_TERM)
        {
            [self.infoLabel setText:@"Blue Term"];
        }
        else if (self.currentTerm == PURPLE_TERM)
        {
            [self.infoLabel setText:@"Purple Term"];
        }
    }
    
    [self animationPart1:nil];
}

- (void)timesUpAnimation
{
    [self.infoLabel setText:@"Time's Up"];
    [self animationPart1:nil];
}

- (void)gameOverAnimation
{
    [self.infoLabel setText:@"Game Over"];
    [self animationPart1:nil];
}

#pragma mark -
#pragma mark Handle Timer

- (void) handleTimer: (NSTimer *) timer
{
    if (self.inAnimation || self.isPaused)
    {
        return;
    }
    self.timeCount--;
    if (self.timeCount <= 0)
    {
        [self timesUpAnimation];
    }
    [self.timeLabel setText:[NSString stringWithFormat:@"%lds",(long)self.timeCount]];
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)pause:(id)sender
{
    self.isPaused = YES;
    [self.view addSubview:self.pausePanel];
}

- (IBAction)backToGame:(id)sender
{
    self.isPaused = NO;
    [self.pausePanel removeFromSuperview];
}

- (IBAction)backToMenu:(id)sender
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
    for (NSInteger i = self.positionCurrentSelected; i > self.positionHaveBeenUsed; i--)
    {
        if (self.currentTerm == BLUE_TERM)
        {
            [self.blueGameButtonArray addObject:[NSNumber numberWithLong:i]];
        }
        else if (self.currentTerm == PURPLE_TERM)
        {
            [self.purpleGameButtonArray addObject:[NSNumber numberWithLong:i]];
        }
    }
    
    // reset position and num of selection
    self.positionHaveBeenUsed = self.positionCurrentSelected;
    self.positionCurrentSelected = -1;
    
    [self.countLabel setText:[NSString stringWithFormat:@"%ld/21",(self.positionHaveBeenUsed+1)]];
    
    // Whether game is over
    if (self.positionHaveBeenUsed == 20) // from 0..20, so there are 21 buttons have been pushed
    {
        [self gameOverAnimation];
        return;
    }
        
    // change player
    [self changePlayer];
}

- (IBAction)gameStart:(id)sender
{
    // init timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    self.timeCount = TIME_LIMIT;
    
    // hide the info panel
    self.infoPanel.hidden = YES;
    self.gameStartButton.hidden = YES;
    self.gameStartButton.enabled = NO;
    
    // init game field
    [self changePlayer];
}

- (IBAction)gameButtonPressed:(id)sender
{
    UIButton *theButton = (UIButton *)sender;
    // set button selected image HERE
    // ...
    NSString *imageNameString = [NSString stringWithFormat:@""];
    if (self.currentTerm == BLUE_TERM)
    {
        imageNameString = @"blue_select.png";
    }
    else if (self.currentTerm == PURPLE_TERM)
    {
        imageNameString = @"purple_select.png";
    }
    if ([imageNameString isEqualToString:@""])
    {
        NSLog(@"Error: Image Name Initialization Failed! Please check currentTerm value.");
        return;
    }
    
    [theButton setImage:[UIImage imageNamed:imageNameString] forState:UIControlStateNormal];
    
    self.positionCurrentSelected = [self.gameButtonArray indexOfObject:theButton];
    for (int offset = 1; offset < 4; offset++)
    {
        long index = self.positionHaveBeenUsed + offset;
        if (index >= 21)
        {
            break;
        }
        UIButton *aButton = [self.gameButtonArray objectAtIndex:index];
        // set button selected image HERE
        // ...
        if (index > self.positionCurrentSelected)
        {
            NSString *resetImageNameString = [NSString string];
            resetImageNameString = index==20 ? @"red_circle.png" : @"org_circle.png";
            [aButton setImage:[UIImage imageNamed:resetImageNameString] forState:UIControlStateNormal];
        }
        else
        {
            if (index == 20)
            {
                if (self.currentTerm == BLUE_TERM)
                {
                    imageNameString = @"red_blue_select.png";
                }
                else if (self.currentTerm == PURPLE_TERM)
                {
                    imageNameString = @"red_purple_select.png";
                }
            }
            [aButton setImage:[UIImage imageNamed:imageNameString] forState:UIControlStateNormal];
        }
    }
}

@end
