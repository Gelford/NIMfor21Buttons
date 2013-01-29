//
//  NIMGameViewController.m
//  NIMfor21Buttons
//
//  Created by Xin Gao on 1/29/13.
//  Copyright (c) 2013 Xin Gao. All rights reserved.
//

#import "NIMGameViewController.h"

@interface NIMGameViewController ()

@end

@implementation NIMGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
#pragma mark Button Actions

- (IBAction)pause:(id)sender
{
    [super dismissViewControllerAnimated:YES completion:nil];
}

@end
