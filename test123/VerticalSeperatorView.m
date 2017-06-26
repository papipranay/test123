//
//  VerticalSeperatorView.m
//  test123
//
//  Created by Pranay on 5/28/17.
//  Copyright © 2017 Pranay. All rights reserved.
//

#import "VerticalSeperatorView.h"

static CGFloat const kTotalWidth = 44;                               // the total height of the separator (including parts that are not visible
static CGFloat const kVisibleWidth = 2;                              // the height of the visible portion of the separator
static CGFloat const kMargin = (kTotalWidth - kVisibleWidth) / 2.0; // the height of the non-visible portions of the separator (i.e. above and below the visible portion)
static CGFloat const kMinWidth = 30;                                 // the minimum height allowed for views above and below the separator

@implementation VerticalSeperatorView


#pragma mark - Configuration

/** Add a separator between views
 
 This creates the separator view; adds it to the view hierarchy; adds the constraint for height;
 adds the constraints for leading/trailing with respect to its superview; and adds the constraints
 the relation to the views above and below
 
 @param firstView  The UIView above the separator
 @param secondView The UIView below the separator
 @returns          The separator UIView
 */
+ (instancetype)addSeparatorBetweenView:(UIViewController *)firstView secondView:(UIViewController *)secondView {
    
    VerticalSeperatorView *separator = [[VerticalSeperatorView alloc] init];
    [firstView.parentViewController.view addSubview:separator];
    separator.firstView = firstView;
    separator.secondView = secondView;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [separator.widthAnchor constraintEqualToConstant:kTotalWidth],
                                              [separator.superview.topAnchor constraintEqualToAnchor:separator.topAnchor],
                                              [separator.superview.bottomAnchor constraintEqualToAnchor:separator.bottomAnchor],
                                              [firstView.view.rightAnchor constraintEqualToAnchor:separator.leftAnchor constant:kMargin],
                                              [secondView.view.leftAnchor constraintEqualToAnchor:separator.rightAnchor constant:-kMargin],
                                              ]];
    
    separator.leftConstraint = [separator.leftAnchor constraintEqualToAnchor:separator.superview.leftAnchor constant:0]; // it doesn't matter what the constant is, because it hasn't been enabled
    
    return separator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.userInteractionEnabled = true;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Handle Touches

// When it first receives touches, save (a) where the view currently is; and (b) where the touch started

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.oldX = self.frame.origin.x;
    self.firstTouch = [[touches anyObject] locationInView:self.superview];
    self.leftConstraint.constant = self.oldX;
    self.leftConstraint.active = true;
}

// When user drags finger, figure out what the new top constraint should be

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    // for more responsive UX, use predicted touches, if possible
    
    if ([UIEvent instancesRespondToSelector:@selector(predictedTouchesForTouch:)]) {
        UITouch *predictedTouch = [[event predictedTouchesForTouch:touch] lastObject];
        if (predictedTouch) {
            [self updateTopConstraintOnBasisOfTouch:predictedTouch];
            return;
        }
    }
    
    // if no predicted touch found, just use the touch provided
    
    [self updateTopConstraintOnBasisOfTouch:touch];
}

// When touches are done, reset constraint on the basis of the final touch,
// (backing out any adjustment previously done with predicted touches, if any).

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateTopConstraintOnBasisOfTouch:[touches anyObject]];
}

/** Update top constraint of the separator view on the basis of a touch.
 
 This updates the top constraint of the horizontal separator (which moves the visible separator).
 Please note that this uses properties populated in touchesBegan, notably the `oldY` (where the
 separator was before the touches began) and `firstTouch` (where these touches began).
 
 @param touch    The touch that dictates to where the separator should be moved.
 */
- (void)updateTopConstraintOnBasisOfTouch:(UITouch *)touch {
    // calculate where separator should be moved to
    
    CGFloat x = self.oldX + [touch locationInView:self.superview].x - self.firstTouch.x;
    
    // make sure the views above and below are not too small
    
    x = MAX(x, self.firstView.view.frame.origin.x + kMinWidth - kMargin);
    x = MIN(x, self.secondView.view.frame.origin.x + self.secondView.view.frame.size.width - (kMargin + kMinWidth));
    
    // set constraint
    
    self.leftConstraint.constant = x;
}
#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGRect separatorRect = CGRectMake(kMargin,0 , kVisibleWidth,self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:separatorRect];
    [[UIColor blackColor] set];
    [path stroke];
    [path fill];
}

@end
