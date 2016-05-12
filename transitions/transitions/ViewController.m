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
    
    double viewSize = self.view.frame.size.width * 0.8;
    
    transitionViewRect = (CGRect){self.view.frame.size.width * 0.1,self.view.frame.size.height * 0.5 - (viewSize * 0.5), viewSize, viewSize};
    currentTransition = TRANSTION_TYPE_STAR_WIPE;
    [self initRed];
    [self initBlue];
    [self.view addSubview:red];
    isTransitioning = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transition)];
    [self.view addGestureRecognizer:tap];
    
    addImageButton = [[UIButton alloc] initWithFrame:(CGRect){0,0,red.frame.size.width,red.frame.origin.y * 0.25}];
    [addImageButton setCenter:(CGPoint){red.center.x, red.frame.origin.y * 0.5}];
    [addImageButton setTitle:@"Set image" forState:UIControlStateNormal];
    [addImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addImageButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addImageButton];
    
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

- (void)addPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if( !chosenImage )
        chosenImage = info[UIImagePickerControllerOriginalImage];
    UIImageView *backgroundImage;
    if( [red superview] )
    {
        backgroundImage = [red viewWithTag:777];
        if( !backgroundImage )
        {
            backgroundImage = [[UIImageView alloc] initWithImage:chosenImage];
            [red addSubview:backgroundImage];
        }
        [backgroundImage setImage:chosenImage];
        [backgroundImage setFrame:(CGRect){0,0,red.bounds.size}];
        [backgroundImage setContentMode:UIViewContentModeScaleToFill];
        [backgroundImage setClipsToBounds:YES];
    }
    else
    {
        backgroundImage = [blue viewWithTag:777];
        if( !backgroundImage )
        {
            backgroundImage = [[UIImageView alloc] initWithImage:chosenImage];
            [blue addSubview:backgroundImage];
        }
        [backgroundImage setImage:chosenImage];
        [backgroundImage setFrame:(CGRect){0,0,blue.bounds.size}];
        [backgroundImage setContentMode:UIViewContentModeScaleToFill];
        [backgroundImage setClipsToBounds:YES];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
