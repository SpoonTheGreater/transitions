//
//  transitionView.m
//  transitions
//
//  Created by James Sadlier on 12/05/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import "transitionView.h"

@implementation transitionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        
    }
    return self;
}

- (void)beginTransitionOut:(TRANSTION_TYPE)transtionType withCompletion:(void(^)(void))completion
{
    switch (transtionType) {
        case TRANSTION_TYPE_SIMPLE_FADE: {
            [self simpleFadeOutWithCompletion:completion];
            break;
        }
        case TRANSTION_TYPE_STAR_WIPE:
        {
            [self starWipeOutWithCompletion:completion];
            break;
        }
        case TRANSTION_TYPE_TOP_DOWN:
        {
            [self topDownWipeOutWithCompletion:completion];
            break;
        }
        default:
            break;
    }
}

- (void)beginTransitionIn:(TRANSTION_TYPE)transtionType withCompletion:(void(^)(void))completion
{
    switch (transtionType) {
        case TRANSTION_TYPE_SIMPLE_FADE: {
            [self simpleFadeInWithCompletion:completion];
            break;
        }
        case TRANSTION_TYPE_STAR_WIPE:
        {
            [self starWipeInWithCompletion:completion];
            break;
        }
        case TRANSTION_TYPE_TOP_DOWN:
        {
            [self topDownWipeInWithCompletion:completion];
            break;
        }
        default:
            break;
    }
}

- (void)simpleFadeOutWithCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alpha = 1;
        completion();
    }];
}

- (void)simpleFadeInWithCompletion:(void(^)(void))completion
{
    self.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
         completion();
    }];
}

- (void)starWipeOutWithCompletion:(void(^)(void))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        self.alpha = 1;
        completion();
    });
}

- (void)starWipeInWithCompletion:(void(^)(void))completion
{
    UIBezierPath* starPath = UIBezierPath.bezierPath;
    double width = self.bounds.size.width;
    double heigth = self.bounds.size.height;
    
    [starPath moveToPoint: CGPointMake(0.5 * width, 0 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.611640625 * width, 0.346328125 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.975546875 * width, 0.3455078125 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.680625 * width, 0.5587109375 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.79390625 * width, 0.9044921875 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.5 * width, 0.689921875 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.20609375 * width, 0.9044921875 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.319375 * width, 0.5587109375 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.024453125 * width, 0.3455078125 * heigth)];
    [starPath addLineToPoint: CGPointMake(0.388359375 * width, 0.346328125 * heigth)];
    [starPath closePath];
    
    CAShapeLayer *starShape = [CAShapeLayer new];
    starShape.frame = self.bounds;
    starShape.path = starPath.CGPath;
    
    starShape.masksToBounds = YES;
    self.layer.mask.masksToBounds = YES;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    self.layer.mask = starShape;
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scale setFromValue:[NSNumber numberWithFloat:0.0f]];
    [scale setToValue:[NSNumber numberWithFloat:4.0f]];
    [scale setDuration:2.0f];
    [scale setRemovedOnCompletion:YES];
    [scale setFillMode:kCAFillModeForwards];
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        self.layer.mask = nil;
        completion();
    }];
    [self.layer.mask addAnimation:scale forKey:@"zoom"];
    
    [CATransaction commit];
}

- (void)topDownWipeOutWithCompletion:(void(^)(void))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        self.alpha = 1;
        completion();
    });
}

- (void)topDownWipeInWithCompletion:(void(^)(void))completion
{
    [[self superview] bringSubviewToFront:self];
    CALayer *mask = [CALayer layer];
    [mask setFrame:(CGRect){0,0,self.frame.size.width,0}];
    [mask setBackgroundColor:[UIColor whiteColor].CGColor];
    self.layer.mask = mask;
    self.layer.mask.masksToBounds = YES;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSTimeInterval duration = 2;
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
        
        [CATransaction setCompletionBlock:^{
            self.layer.mask = nil;
            completion();
        }];
        
        //[self.layer.mask setBounds:self.bounds];
        [self.layer.mask setFrame:self.bounds];
        [CATransaction commit];
    });
}


+ (NSString*)stringForTranstionType:(TRANSTION_TYPE)transtionType
{
    static NSArray *_names;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _names = @[
                   @"Simple Fade",
                   @"Star Wipe",
                   @"Top Down"
                   ];
    });
    return [_names objectAtIndex:transtionType];
}

@end
