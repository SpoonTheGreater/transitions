//
//  ViewController.m
//  transitions
//
//  Created by James Sadlier on 12/05/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    transitionViewRect = (CGRect){self.view.frame.size.width * 0.2,self.view.frame.size.height * 0.2, self.view.frame.size.width * 0.6,self.view.frame.size.height * 0.6};
    currentTransition = TRANSTION_TYPE_SIMPLE_FADE;
    [self initRed];
    [self initBlue];
    [self.view addSubview:red];
    isTransitioning = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transition)];
    [self.view addGestureRecognizer:tap];
    
    currentTransitionName = [[UILabel alloc] initWithFrame:(CGRect){0,0,0,0}];
    [currentTransitionName setTextAlignment:NSTextAlignmentCenter];
    [currentTransitionName setText:[transitionView stringForTranstionType:currentTransition]];
    [currentTransitionName sizeToFit];
    [currentTransitionName setCenter:(CGPoint){red.center.x, red.frame.size.height + (red.frame.origin.y * 1.5)}];
    [self.view addSubview:currentTransitionName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initRed
{
    red = [[transitionView alloc] initWithFrame:transitionViewRect];
    [red setBackgroundColor:[UIColor redColor]];
}

- (void)initBlue
{
    blue = [[transitionView alloc] initWithFrame:transitionViewRect];
    [blue setBackgroundColor:[UIColor blueColor]];
}

- (void)transition
{
    if( isTransitioning )
        return;
    isTransitioning = YES;
    if( [red superview] )
    {
        [self.view addSubview:blue];
        [red beginTransitionOut:currentTransition withCompletion:^{
            
        }];
        [blue beginTransitionIn:currentTransition withCompletion:^{
            [self nextTransition];
        }];
    }
    else
    {
        [self.view addSubview:red];
        [blue beginTransitionOut:currentTransition withCompletion:^{
            
        }];
        [red beginTransitionIn:currentTransition withCompletion:^{
            [self nextTransition];
        }];
    }
}

- (void)nextTransition
{
    if ( ++currentTransition >= TRANSTION_TYPE_SIMPLE_MAX )
    {
        currentTransition = 0;
    }
    isTransitioning = NO;
    [currentTransitionName setText:[transitionView stringForTranstionType:currentTransition]];
    [currentTransitionName sizeToFit];
    [currentTransitionName setCenter:(CGPoint){red.center.x, red.frame.size.height + (red.frame.origin.y * 1.5)}];
}



@end
