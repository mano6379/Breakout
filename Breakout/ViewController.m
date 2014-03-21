//
//  ViewController.m
//  Breakout
//
//  Created by Marion Ano on 3/20/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"

@interface ViewController () 
{
    UIDynamicAnimator *dynamicAnimator;
    UIPushBehavior* pushBehavior;
    UICollisionBehavior *collisionBehavior;
    IBOutlet BallView *ballView;
    IBOutlet PaddleView *paddleView;
    UIDynamicItemBehavior* ballDynamicBehavior;
    UIDynamicItemBehavior* paddleDynamicBehavior;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[ballView,paddleView]];
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[ballView]];
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[paddleView]];
                             
    
    pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
    pushBehavior.active = YES;
    pushBehavior.magnitude =  0.2;
    [dynamicAnimator addBehavior:pushBehavior];
    
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES; //turn reference bounds into a boundary (UIView becomes of reference boundary)
    
    //the next line says that I (view controller) want to be your delegate and am indeed setting myself equal to you and your behavior
    //self (I) (view controller) am talking to UICollision behavior, which has a property called CollionDelagate, and I am setting myself as that property.
    
    collisionBehavior.collisionDelegate = self;
    
    [dynamicAnimator addBehavior:collisionBehavior];
    
    
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0; //since the default value is 0, we don't actually have to call this!
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 1000;
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
}

- (IBAction)dragPaddle:(UIPanGestureRecognizer*)panGestureRecognizer
{
    paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x,paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];

}


-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    //origin.y is the y coordinate relative to the main UIView
    if (ballView.frame.origin.y >= (self.view.frame.size.height-(ballView.frame.size.height*2)))
    {
        ballView.center = self.view.center;
        [dynamicAnimator updateItemUsingCurrentState:ballView];
    }
        
}


@end

