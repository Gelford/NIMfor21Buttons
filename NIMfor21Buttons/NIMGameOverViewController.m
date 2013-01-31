//
//  NIMGameOverViewController.m
//  NIMfor21Buttons
//
//  Created by Xin Gao on 1/30/13.
//  Copyright (c) 2013 Xin Gao. All rights reserved.
//

#import "NIMGameOverViewController.h"
#import "NIMGameViewController.h"

@interface NIMGameOverViewController ()

@end

@implementation NIMGameOverViewController
@synthesize delegate;

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

- (IBAction)backToMenu:(id)sender
{
    NIMGameViewController *vc = (NIMGameViewController *)delegate;
    [vc dismissViewControllerToMenu];
}

@end
