//
//  HorizontalSeparatorView.h
//  test123
//
//  Created by Pranay on 5/28/17.
//  Copyright © 2017 Pranay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalSeparatorView : UIView
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;      // the constraint that dictates the vertical position of the separator
@property (nonatomic, weak) UIViewController *firstView;                        // the view above the separator
@property (nonatomic, weak) UIViewController *secondView;                       // the view below the separator

// some properties used for handling the touches

@property (nonatomic) CGFloat oldY;                                   // the position of the separator before the gesture started
@property (nonatomic) CGPoint firstTouch;                             // the position where the drag gesture started
+ (instancetype)addSeparatorBetweenView:(UIViewController *)firstView secondView:(UIViewController *)secondView;
@end
