//
//  NIMGameOverViewController.h
//  NIMfor21Buttons
//
//  Created by Xin Gao on 1/30/13.
//  Copyright (c) 2013 Xin Gao. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NIMGameOverViewController : UIViewController

@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
@property (assign, nonatomic) NSInteger AITerm;

- (void)setLoser:(NSInteger)loser;
- (void)createResultMatrixWithBlueArray:(NSMutableArray *)blueArray
                         andPurpleArray:(NSMutableArray *)purpleArray;
- (IBAction)backToMenu:(id)sender;

@end
