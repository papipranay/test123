//
//  ViewController.m
//  test123
//
//  Created by Pranay on 5/27/17.
//  Copyright © 2017 Pranay. All rights reserved.
//

#import "ViewController.h"



@interface ViewController (){
    
    FirstViewController *firstVC;
    SecondViewController *secVC;
    ThirdViewController *thiVC;
    UIViewController *previousContentView;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    firstVC = [[FirstViewController alloc] init];
    secVC = [[SecondViewController alloc] init];
    thiVC = [[ThirdViewController alloc] init];
    
    
    [self displayContentController:firstVC andFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [self displayContentController:secVC andFrame:CGRectMake(0, 150, self.view.frame.size.width, 150)];
    [self displayContentController:thiVC andFrame:CGRectMake(0, 300, self.view.frame.size.width, 150)];
    
    [self.view.bottomAnchor constraintEqualToAnchor:previousContentView.view.bottomAnchor].active = true;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) displayContentController: (UIViewController*) content andFrame:(CGRect)frame{
    
    //Adding view controller as a child view controller
    [self addChildViewController:content];
    
    //move the child view controller to parent
    [content didMoveToParentViewController:self];
    
    //set the view frames of the view controller
    content.view.frame = frame;
    
    //add the view on parent view controller view
    [self.view addSubview:content.view];
    
    UIView *contentView = content.view;
    
    [self.view.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor].active = true;
    [self.view.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor].active = true;
    if (previousContentView) {
        [HorizontalSeparatorView addSeparatorBetweenView:previousContentView secondView:content];
        NSLayoutConstraint *height = [content.view.heightAnchor constraintEqualToAnchor:previousContentView.view.heightAnchor];
        height.priority = 250;
        height.active = true;
    } else {
        [self.view.topAnchor constraintEqualToAnchor:contentView.topAnchor].active = true;
    }
    previousContentView = content;


}

-(void)resizeChildViewController :(id)controller withValue:(float)value{
    
    if([controller isKindOfClass:[FirstViewController class]]){
        firstVC.view.frame = CGRectMake(firstVC.view.frame.origin.x, firstVC.view.frame.origin.y, value+10, firstVC.view.frame.size.height);
        [self.view bringSubviewToFront:firstVC.view];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
