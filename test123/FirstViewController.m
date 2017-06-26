//
//  FirstViewController.m
//  test123
//
//  Created by Pranay on 5/27/17.
//  Copyright © 2017 Pranay. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"
#import "VerticalSeperatorView.h"

@interface FirstViewController (){
    UIViewController *previousContentView;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.view.translatesAutoresizingMaskIntoConstraints = false;

        
        
        //firstVC.view.frame = CGRectMake(0, 0, 150, 150);
        
        
       SecondViewController* secVC = [[SecondViewController alloc] init];
        //secVC.view.frame = CGRectMake(150, 0, 150, 150);
        
        ThirdViewController* thiVC = [[ThirdViewController alloc] init];
        //thiVC.view.frame = CGRectMake(0, 150, 300, 150);
        
    ThirdViewController* thiVC1 = [[ThirdViewController alloc] init];
    //thiVC.view.frame = CGRectMake(0, 150, 300, 150);
    
    [self displayContentController:thiVC1 andFrame:CGRectMake(0, 0, 175, 150)];
        [self displayContentController:secVC andFrame:CGRectMake(175, 0, 175, 150)];
        [self displayContentController:thiVC andFrame:CGRectMake(350, 0, 150, 150)];
    
        [self.view.trailingAnchor constraintEqualToAnchor:previousContentView.view.trailingAnchor].active = true;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    - (void) displayContentController: (UIViewController*) content andFrame:(CGRect)frame{
        [self addChildViewController:content];
        [content didMoveToParentViewController:self];
        content.view.frame = frame;
        [self.view addSubview:content.view];
        
        UIView *contentView = content.view;
        
        [self.view.topAnchor constraintEqualToAnchor:contentView.topAnchor].active = true;
        [self.view.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor].active = true;
        if (previousContentView) {
            [VerticalSeperatorView addSeparatorBetweenView:previousContentView secondView:content];
            NSLayoutConstraint *width = [contentView.widthAnchor constraintEqualToAnchor:previousContentView.view.widthAnchor];
            width.priority = 250;
            width.active = true;
        } else {
            [self.view.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor].active = true;
        }
        previousContentView = content;
        
        
    }

-(void)loadSubviews{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
