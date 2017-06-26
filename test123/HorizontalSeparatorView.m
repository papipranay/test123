#import "HorizontalSeparatorView.h"

static CGFloat const kTotalHeight = 44;                               // the total height of the separator (including parts that are not visible
static CGFloat const kVisibleHeight = 2;                              // the height of the visible portion of the separator
static CGFloat const kMargin = (kTotalHeight - kVisibleHeight) / 2.0; // the height of the non-visible portions of the separator (i.e. above and below the visible portion)
static CGFloat const kMinHeight = 30;                                 // the minimum height allowed for views above and below the separator

/** Horizontal separator view
 
 @note This renders a separator view, but the view is larger than the visible separator
 line that you see on the device so that it can receive touches when the user starts
 touching very near the visible separator. You always want to allow some margin when
 trying to touch something very narrow, such as a separator line.
 */


@implementation HorizontalSeparatorView

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
    HorizontalSeparatorView *separator = [[self alloc] init];
    [firstView.parentViewController.view addSubview:separator];
    separator.firstView = firstView;
    separator.secondView = secondView;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [separator.heightAnchor constraintEqualToConstant:kTotalHeight],
                                              [separator.superview.leadingAnchor constraintEqualToAnchor:separator.leadingAnchor],
                                              [separator.superview.trailingAnchor constraintEqualToAnchor:separator.trailingAnchor],
                                              [firstView.view.bottomAnchor constraintEqualToAnchor:separator.topAnchor constant:kMargin],
                                              [secondView.view.topAnchor constraintEqualToAnchor:separator.bottomAnchor constant:-kMargin],
                                              ]];
    
    separator.topConstraint = [separator.topAnchor constraintEqualToAnchor:separator.superview.topAnchor constant:0]; // it doesn't matter what the constant is, because it hasn't been enabled
    
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
    self.oldY = self.frame.origin.y;
    self.firstTouch = [[touches anyObject] locationInView:self.superview];
    self.topConstraint.constant = self.oldY;
    self.topConstraint.active = true;
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
    
    CGFloat y = self.oldY + [touch locationInView:self.superview].y - self.firstTouch.y;
    
    // make sure the views above and below are not too small
    
    y = MAX(y, self.firstView.view.frame.origin.y + kMinHeight - kMargin);
    y = MIN(y, self.secondView.view.frame.origin.y + self.secondView.view.frame.size.height - (kMargin + kMinHeight));
    
    // set constraint
    
    self.topConstraint.constant = y;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGRect separatorRect = CGRectMake(0, kMargin, self.bounds.size.width, kVisibleHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:separatorRect];
    [[UIColor blackColor] set];
    [path stroke];
    [path fill];
}

@end
