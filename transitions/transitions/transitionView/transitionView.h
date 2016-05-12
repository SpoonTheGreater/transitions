//
//  transitionView.h
//  transitions
//
//  Created by James Sadlier on 12/05/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(int8_t, TRANSTION_TYPE)
{
    TRANSTION_TYPE_SIMPLE_FADE = 0,
    TRANSTION_TYPE_STAR_WIPE = 1,
    TRANSTION_TYPE_SIMPLE_MAX = 2
};

@interface transitionView : UIView

- (void)beginTransitionOut:(TRANSTION_TYPE)transtionType withCompletion:(void(^)(void))completion;
- (void)beginTransitionIn:(TRANSTION_TYPE)transtionType withCompletion:(void(^)(void))completion;
+ (NSString*)stringForTranstionType:(TRANSTION_TYPE)transtionType;
@end
