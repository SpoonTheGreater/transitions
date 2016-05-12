//
//  ViewController.h
//  transitions
//
//  Created by James Sadlier on 12/05/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "transitionView.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate>
{
    CGRect transitionViewRect;
    transitionView *blue;
    transitionView *red;
    TRANSTION_TYPE currentTransition;
    bool isTransitioning;
    UILabel *currentTransitionName;
    UIButton *addImageButton;
}

@end

