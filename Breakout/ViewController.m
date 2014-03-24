//
//  ViewController.m
//  Breakout
//
//  Created by Marion Ano on 3/20/14.
//  Copyright (c) 2014 Marion Ano. All rights reserved.
// // blog on UIKit Dynamics (Building UIKit Pong) http://blog.bignerdranch.com/3899-uikit-dynamics-and-ios-7-building-uikit-pong/

//experimented with: CGVector pushDirection and I added an anble and magnitude


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
    
    //create an NSMutalable array of myBlock objects
    NSMutableArray *myBlocks;
    BOOL shouldStartAgain;
    
    IBOutlet UIButton *launchButton;
}

@property BlockView* myTestBlockOne;
@property BlockView* myTestBlockTwo;
@property BlockView* myTestBlockThree;
@property BlockView* myTestBlockFour;
@property BlockView* myTestBlockFive;
@property BlockView* myTestBlockSix;
@property BlockView* myTestBlockSeven;
@property BlockView* myTestBlockEight;
@property(readwrite, nonatomic) CGVector pushDirection;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    shouldStartAgain = NO;
    
    //Creating blockView objects programatically
    self.myTestBlockOne = [[BlockView alloc] initWithFrame:CGRectMake(0, 20, 35, 35)];
    self.myTestBlockOne.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.myTestBlockOne];
    
    self.myTestBlockTwo = [[BlockView alloc] initWithFrame:CGRectMake(40, 20, 35, 35)];
    self.myTestBlockTwo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTestBlockTwo];
    
    self.myTestBlockThree = [[BlockView alloc] initWithFrame:CGRectMake(80, 20, 35, 35)];
    self.myTestBlockThree.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.myTestBlockThree];
    
    self.myTestBlockFour = [[BlockView alloc] initWithFrame:CGRectMake(120, 20, 35, 35)];
    self.myTestBlockFour.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTestBlockFour];
    
    self.myTestBlockFive = [[BlockView alloc] initWithFrame:CGRectMake(160, 20, 35, 35)];
    self.myTestBlockFive.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.myTestBlockFive];
    
    self.myTestBlockSix = [[BlockView alloc] initWithFrame:CGRectMake(200, 20, 35, 35)];
    self.myTestBlockSix.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTestBlockSix];
    
    self.myTestBlockSeven = [[BlockView alloc] initWithFrame:CGRectMake(240, 20, 35, 35)];
    self.myTestBlockSeven.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.myTestBlockSeven];
    
    self.myTestBlockEight= [[BlockView alloc] initWithFrame:CGRectMake(280, 20, 35, 35)];
    self.myTestBlockEight.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTestBlockEight];
    
    //putting all programmatic BlockView objects into an NSMutable Array
    myBlocks = [[NSMutableArray alloc]initWithObjects:self.myTestBlockOne, self.myTestBlockTwo, self.myTestBlockThree, self.myTestBlockFour, self.myTestBlockFive, self.myTestBlockSix, self.myTestBlockSeven, self.myTestBlockEight,nil];
    
    
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //There are only two types of pushBehavior modes: Continuous & Instantaneous
	pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    //working here right now on 3/23 afternoon:
    // Set an angle and magnitude
    //[pushBehavior setAngle:0.2 magnitude:0.5];
    [pushBehavior setAngle:1.0 magnitude:1.0]; //tried 1.0 and 1.0
    [pushBehavior setPushDirection:CGVectorMake(10.0, 10.0)];
    pushBehavior.pushDirection = CGVectorMake(0.5, -1.0);
    pushBehavior.active = YES;
    pushBehavior.magnitude =  0.2;
    [dynamicAnimator addBehavior:pushBehavior];

    //Collision Behavior
    collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[ballView, paddleView, self.myTestBlockOne, self.myTestBlockTwo, self.myTestBlockThree, self.myTestBlockFour, self.myTestBlockFive, self.myTestBlockSix, self.myTestBlockSeven, self.myTestBlockEight]];
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES; //turn reference bounds into a boundary (UIView becomes of reference boundary)
    //the next line says that I (view controller) want to be your delegate and am indeed setting myself equal to you and your behavior
    //self (I) (view controller) am talking to UICollision behavior, which has a property called CollionDelagate, and I am setting myself as that property.
    collisionBehavior.collisionDelegate = self;
    [dynamicAnimator addBehavior:collisionBehavior];
    
    
    //DynamicBehavior for: Ball, Paddle, and BlockViews
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[ballView]];
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[paddleView]];
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.myTestBlockOne, self.myTestBlockTwo, self.myTestBlockThree, self.myTestBlockFour, self.myTestBlockFive, self.myTestBlockSix, self.myTestBlockSeven, self.myTestBlockEight]];
    

    //Ball Dynamic Behavior
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.resistance = 0.0;
    ballDynamicBehavior.elasticity = 1.0; //1.0 seems to be good
    ballDynamicBehavior.friction = 0; //since the default value is 0, we don't actually have to call this!
    //[ballDynamicBehavior addAngularVelocity:4.0 forItem:ballView]; //set 10.0, but the ball kept spinning, the higher the better, but 10 is too high
    [ballDynamicBehavior addLinearVelocity:CGPointMake(100.0, 200.0) forItem:ballView];
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    
    //Paddle Dynamic Behavior
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 15000; //started at 10000
    //[paddleDynamicBehavior addLinearVelocity:CGPointMake(100.0, 0) forItem:paddleView];
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    
    //Block Dynamic Behavior
    blockDynamicBehavior.density = 20000; //started at 10000, tested 10000 seems to be fine
    blockDynamicBehavior.allowsRotation = NO;
    [dynamicAnimator addBehavior:blockDynamicBehavior];
    
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
        //ballView.center = self.view.center;
        ballView.center = CGPointMake(paddleView.center.x, paddleView.center.y -10);
        
        NSLog(@"%f %f", [ballDynamicBehavior linearVelocityForItem:ballView].x,[ballDynamicBehavior linearVelocityForItem:ballView].y);
        
        //now we're going to stop the ball
        CGPoint ballVelocity = CGPointMake([ballDynamicBehavior linearVelocityForItem:ballView].x * -1,[ballDynamicBehavior linearVelocityForItem:ballView].y *-1);
        [ballDynamicBehavior addLinearVelocity:ballVelocity forItem:ballView];
        [dynamicAnimator updateItemUsingCurrentState:ballView];
    }
        
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
 
    //for(myBlocks *myBlockViews in self.view.subviews)
    //if ([item2 isKindOfClass:[BlockView class]])
    BlockView* block =  (BlockView*)item2;
    if ([item2 isKindOfClass:[BlockView class]])
 {
     [UIView animateWithDuration:0.5 animations:^{
        block.backgroundColor = [UIColor orangeColor];
        NSLog(@"animating");
    } completion:^(BOOL finished) {
        //[(BlockView*)item2 setBackgroundColor:[UIColor orangeColor]];
        [collisionBehavior removeItem:item2];
        [myBlocks removeObject:(BlockView*)item2];
        //you can only remove a view from itʻs Superview
        [(BlockView*)item2 removeFromSuperview];
        [dynamicAnimator updateItemUsingCurrentState:item2];}];
     
 }
    if ([myBlocks count] == 0)
    {
      CGPoint ballVelocity = CGPointMake([ballDynamicBehavior linearVelocityForItem:ballView].x * -1,[ballDynamicBehavior linearVelocityForItem:ballView].y *-1);
        [ballDynamicBehavior addLinearVelocity:ballVelocity forItem:ballView];
        [dynamicAnimator updateItemUsingCurrentState:ballView];

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Good Job" message:@"Play Again" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: nil];
        [alertView show];
        
         //shouldStartAgain = YES;
          //[self resetGame];
    }
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // My OK button
    NSLog(@"this got called");
    
    if (buttonIndex == 0)
    {
        // Action to start the game again... (don't work)
        [self resetGame];
    }
}


//-(void)threeHitCount
//{
//    NSInteger *randomIndex = arc4random() % [myBlocks count];
//    //for (randomIndex i=0; i =< count; i++)
//    BlockView *randomBlock = [myBlocks objectsAtIndexes:randomIndex];
//        if(randomBlock.backgroundColor == [UIColor greenColor])
//        {
//            return myBlocks;
//        }
//    
//        else if (randomBlock.backgroundColor == [UIColor yellowColor])
//        {
//            return myBlocks;
//        }
//        randomBlock.backgroundColor = [UIColor redColor];
//        [myBlocks removeObjectAtIndex:*randomIndex];
//}


- (IBAction)onLaunchButtonPressed:(UIButton*)sender

{
    CGPoint ballVelocity = CGPointMake(325, -650);
    [ballDynamicBehavior addLinearVelocity:ballVelocity forItem:ballView];
    [dynamicAnimator updateItemUsingCurrentState:ballView];
    
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

