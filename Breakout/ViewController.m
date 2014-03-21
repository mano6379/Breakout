//
//  ViewController.m
//  Breakout
//
//  Created by Marion Ano on 3/20/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
// // blog on UIKit Dynamics (Building UIKit Pong) http://blog.bignerdranch.com/3899-uikit-dynamics-and-ios-7-building-uikit-pong/

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () 
{
    UIDynamicAnimator *dynamicAnimator;
    UIPushBehavior* pushBehavior;
    UICollisionBehavior *collisionBehavior;
    IBOutlet BallView *ballView;
    IBOutlet PaddleView *paddleView;
    UIDynamicItemBehavior* ballDynamicBehavior;
    UIDynamicItemBehavior* paddleDynamicBehavior;
    UIDynamicItemBehavior* blockDynamicBehavior;
    IBOutlet BlockView *blockView;
    //create an NSMutalable array of myBlock objects
    NSMutableArray *myBlocks;
    BOOL shouldStartAgain;
}

@property BlockView* myTestBlockOne;
@property BlockView* myTestBlockTwo;
@property BlockView* myTestBlockThree;
@property BlockView* myTestBlockFour;
@property BlockView* myTestBlockFive;
@property BlockView* myTestBlockSix;
@property BlockView* myTestBlockSeven;
@property BlockView* myTestBlockEight;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    shouldStartAgain = NO;
    
    //Creating blockView objects programatically
    self.myTestBlockOne = [[BlockView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.myTestBlockOne.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.myTestBlockOne];
    
    self.myTestBlockTwo = [[BlockView alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
    self.myTestBlockTwo.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.myTestBlockTwo];
    
    self.myTestBlockThree = [[BlockView alloc] initWithFrame:CGRectMake(80, 0, 40, 40)];
    self.myTestBlockThree.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myTestBlockThree];
    
    self.myTestBlockFour = [[BlockView alloc] initWithFrame:CGRectMake(120, 0, 40, 40)];
    self.myTestBlockFour.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.myTestBlockFour];
    
    self.myTestBlockFive = [[BlockView alloc] initWithFrame:CGRectMake(160, 0, 40, 40)];
    self.myTestBlockFive.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.myTestBlockFive];
    
    self.myTestBlockSix = [[BlockView alloc] initWithFrame:CGRectMake(200, 0, 40, 40)];
    self.myTestBlockSix.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myTestBlockSix];
    
    self.myTestBlockSeven = [[BlockView alloc] initWithFrame:CGRectMake(240, 0, 40, 40)];
    self.myTestBlockSeven.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.myTestBlockSeven];
    
    self.myTestBlockEight= [[BlockView alloc] initWithFrame:CGRectMake(280, 0, 40, 40)];
    self.myTestBlockEight.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myTestBlockEight];
    
    //putting all programmatic BlockView objects into an NSMutable Array
    myBlocks = [[NSMutableArray alloc]initWithObjects:self.myTestBlockOne, self.myTestBlockTwo, self.myTestBlockThree, self.myTestBlockFour, self.myTestBlockFive, self.myTestBlockSix, self.myTestBlockSeven, self.myTestBlockEight,nil];
    
    
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ballView] mode:UIPushBehaviorModeContinuous]; //change to continuous from instantaneous
    collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[ballView, paddleView, self.myTestBlockOne, self.myTestBlockTwo, self.myTestBlockThree, self.myTestBlockFour, self.myTestBlockFive, self.myTestBlockSix, self.myTestBlockSeven, self.myTestBlockEight]];
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[ballView]];
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[paddleView]];
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[blockView, self.myTestBlockOne, self.myTestBlockTwo, self.myTestBlockThree, self.myTestBlockFour, self.myTestBlockFive, self.myTestBlockSix, self.myTestBlockSeven, self.myTestBlockEight ]];
    
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
    
    
    blockDynamicBehavior.density = -10000;
    
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0; //since the default value is 0, we don't actually have to call this!
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 1000;
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    //ballView.gravity = CGVectorMake(0.0f, 0.0f);
    
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
        [UIView animateWithDuration:10.0 animations:^{ballView.backgroundColor = [UIColor greenColor];}];
        ballView.center = self.view.center;
        [dynamicAnimator updateItemUsingCurrentState:ballView];
    }
        
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
 
    //for(myBlocks *myBlockViews in self.view.subviews)
    //if ([item2 isKindOfClass:[BlockView class]])
    
    if ([item2 isKindOfClass:[BlockView class]])
 {
//     [UIView animateWithDuration:10.0 animations:^{[(BallView*)item2] setBackgroundColor = [UIColor greenColor]
//         ;}];
     
     [(BlockView*)item2 setBackgroundColor:[UIColor orangeColor]];
     [collisionBehavior removeItem:item2];
     [myBlocks removeObject:item2];
     //you can only remove a view from itʻs Superview
     [(BlockView*)item2 removeFromSuperview];
     //[dynamicAnimator ]
     [dynamicAnimator updateItemUsingCurrentState:item2];
 }
    if ([myBlocks count] == 0)
    {
        shouldStartAgain = YES;
        [self resetGame];
    }
    
}


-(void) resetGame
{
    [self viewDidLoad];
}
        //id item that is blockview
//    if ([item1 isKindOfClass:[BlockView class]])
//    {
//        BlockView *block = (BlockView*)item1;
//        [block removeFromSuperview ];
    
//     }
    
//    for (collisionBehavior.items *x in self.view.subviews)
//    
//    if ([x isKindOfClass:[BlockView class]])
//    {
//        NSLog(@"item is a block");
//        //BlockView *block = (BlockView*)item2;
//        [blockView  removeFromSuperview];
//        
//        
//    }
//
//        //remove that item from the array
//
//}
///idea #1 set block value (once hit) = nil
////idea #2 disappear it out of the frame by setting the xy values to huge numbers


@end

