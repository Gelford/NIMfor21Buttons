//
//  NIMGameViewController.h
//  NIMfor21Buttons
//
//  Created by Xin Gao on 1/29/13.
//  Copyright (c) 2013 Xin Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMAIEngine.h"

@interface NIMGameViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *pausePanel;
@property (strong, nonatomic) IBOutlet UIView *infoPanel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *termLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *gameStartButton;
@property (strong, nonatomic) NIMAIEngine *AIEngine;
@property (assign, nonatomic) NSInteger AITerm; // random


- (IBAction)pause:(id)sender;
- (IBAction)backToGame:(id)sender;
- (IBAction)backToMenu:(id)sender;
- (IBAction)confirmAndGo:(id)sender;
- (IBAction)gameStart:(id)sender;

- (void)dismissViewControllerToMenu;

@end
