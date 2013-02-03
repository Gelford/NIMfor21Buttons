//
//  NIMViewController.m
//  NIMfor21Buttons
//
//  Created by Xin Gao on 1/29/13.
//  Copyright (c) 2013 Xin Gao. All rights reserved.
//

#import "NIMViewController.h"
#import "NIMGameViewController.h"

// private definitions
@interface NIMViewController ()
@property (strong, nonatomic) UIViewController *AISelectionViewController;
@property (strong, nonatomic) UIViewController *ruleViewController;

- (IBAction)backToMenu:(id)sender;
- (IBAction)playWithNormalAI:(id)sender;
- (IBAction)playWithCrazyAI:(id)sender;
@end

@implementation NIMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark Private Methods

- (IBAction)backToMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playWithNormalAI:(id)sender
{
    NIMGameViewController *gameViewController = [[NIMGameViewController alloc] init];
    [self.AISelectionViewController presentViewController:gameViewController animated:YES completion:nil];
}

- (IBAction)playWithCrazyAI:(id)sender
{
    NIMGameViewController *gameViewController = [[NIMGameViewController alloc] init];
    [self.AISelectionViewController presentViewController:gameViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark Menu Button Actions

- (IBAction)singlePlayerGo:(id)sender
{
    self.AISelectionViewController = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"AISelectionViewController"];
    // set button actions
    // back button
    UIView *backButtonView = [self.AISelectionViewController.view viewWithTag:101];
    UIButton *backButton = (UIButton *)backButtonView;
    [backButton addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    // normal AI button
    UIView *normalAIButtonView = [self.AISelectionViewController.view viewWithTag:201];
    UIButton *normalAIButton = (UIButton *)normalAIButtonView;
    [normalAIButton addTarget:self action:@selector(playWithNormalAI:) forControlEvents:UIControlEventTouchUpInside];
    // crazy AI button
    UIView *crazyAIButtonView = [self.AISelectionViewController.view viewWithTag:202];
    UIButton *crazyAIButton = (UIButton *)crazyAIButtonView;
    [crazyAIButton addTarget:self action:@selector(playWithCrazyAI:) forControlEvents:UIControlEventTouchUpInside];
    
    [self presentViewController:self.AISelectionViewController animated:YES completion:nil];
}

- (IBAction)multiplayerGo:(id)sender
{
    NIMGameViewController *gameViewController = [[NIMGameViewController alloc] init];
    [self presentViewController:gameViewController animated:YES completion:nil];
    
}

- (IBAction)showRulesView:(id)sender
{
    self.ruleViewController = [self.storyboard
                                        instantiateViewControllerWithIdentifier:@"RuleViewController"];
    // set button action
    // back button 
    UIView *backButtonView = [self.ruleViewController.view viewWithTag:102];
    UIButton *backButton = (UIButton *)backButtonView;
    [backButton addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self presentViewController:self.ruleViewController animated:YES completion:nil];
}


@end
