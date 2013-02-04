//
//  NIMAIEngine.m
//  NIMfor21Buttons
//
//  Created by Xin Gao on 1/30/13.
//  Copyright (c) 2013 Xin Gao. All rights reserved.
//

#import "NIMAIEngine.h"

#define NORMAL_AI 0
#define CRAZY_AI 1

@interface NIMAIEngine()
@property (assign, nonatomic) NSInteger AIMode;
@end

@implementation NIMAIEngine
@synthesize AIMode;

- (id)initWithAIMode:(NSInteger)mode
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        self.AIMode = mode;
        [self selectCircleWith:2];
    }
    return self;
}

#pragma mark -
#pragma mark Logic Method

- (NSInteger)selectCircleWith:(NSInteger)currentHaveSelected
{
    NSInteger positionWillBeSelected = -1;
    
    if (self.AIMode == NORMAL_AI) // normarl AI
    {
        if (currentHaveSelected == 19)
        {
            return 20;
        }
        else if (currentHaveSelected == 18)
        {
            NSInteger offset = (arc4random()%2) + 1; //random from 0-1, then +1
            positionWillBeSelected = currentHaveSelected + offset;
            return positionWillBeSelected;
        }
        NSInteger offset = (arc4random()%3) + 1; // random from 0-2, then +1
        positionWillBeSelected = currentHaveSelected + offset;
        return positionWillBeSelected;
    }
    else if(self.AIMode == CRAZY_AI) // crazy AI
    {
        if (currentHaveSelected == 19)
        {
            return 20;
        }
        else if (currentHaveSelected == 18)
        {
            return 19;
        }
        NSInteger winningOffset = (currentHaveSelected+1)%4;
        if (winningOffset != 0)
        {
            if (winningOffset == 3)
            {
                positionWillBeSelected = currentHaveSelected +1;
            }
            else if (winningOffset == 1)
            {
                positionWillBeSelected = currentHaveSelected +3;
            }
            else
            {
                positionWillBeSelected = currentHaveSelected +2;
            }
            return positionWillBeSelected;
        }
        else
        {
            NSInteger offset = (arc4random()%3) + 1; // random from 0-2, then +1
            positionWillBeSelected = currentHaveSelected + offset;
            return positionWillBeSelected;
        }
    }
    return 0;
}

@end
