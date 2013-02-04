//
//  NIMGameOverViewController.m
//  NIMfor21Buttons
//
//  Created by Xin Gao on 1/30/13.
//  Copyright (c) 2013 Xin Gao. All rights reserved.
//

#import "NIMGameOverViewController.h"
#import "NIMGameViewController.h"

#define BLUE_LOSE 0
#define PURPLE_LOSE 1

@interface NIMGameOverViewController ()

@end

@implementation NIMGameOverViewController
@synthesize delegate, AITerm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Public Method

- (IBAction)backToMenu:(id)sender
{
    NIMGameViewController *vc = (NIMGameViewController *)delegate;
    [vc dismissViewControllerToMenu];
}

- (void)setLoser:(NSInteger)loser
{
    if (self.AITerm != -1)
    {
        if (loser == self.AITerm)
        {
            [self.winnerLabel setText:@"You Win!"];
        }
        else
        {
            [self.winnerLabel setText:@"AI Wins!"];
        }
    }
    else
    {
        if (loser == BLUE_LOSE)
        {
            [self.winnerLabel setText:@"Purple Wins!"];
        }
        else if (loser == PURPLE_LOSE)
        {
            [self.winnerLabel setText:@"Blue Wins!"];
        }
    }
}

- (void)createResultMatrixWithBlueArray:(NSMutableArray *)blueArray
                         andPurpleArray:(NSMutableArray *)purpleArray
{
    for (int tag = 500; tag < 521; tag++)
    {
        UIView *aView = [self.view viewWithTag:tag];
        UIImageView *imageView = (UIImageView *)aView;
        if ([blueArray containsObject:[NSNumber numberWithInt:(tag - 500)]])
        {
            [imageView setImage:[UIImage imageNamed:@"blue_circle.png"]];
        }
        else if ([purpleArray containsObject:[NSNumber numberWithInt:(tag - 500)]])
        {
            [imageView setImage:[UIImage imageNamed:@"purple_circle.png"]];
        }
    }
}

@end
