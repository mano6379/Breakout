//
//  ViewController.m
//  Breakout
//
//  Created by Marion Ano on 3/20/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"

@interface ViewController ()
{
    UIDynamicAnimator *dynamicAnimator;
    PaddleView* paddleView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)dragPaddle:(UIPanGestureRecognizer*)panGestureRecognizer
{
    paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x,paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];
}

@end
