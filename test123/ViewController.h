//
//  ViewController.h
//  test123
//
//  Created by Pranay on 5/27/17.
//  Copyright © 2017 Pranay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "HorizontalSeparatorView.h"

@interface ViewController : UIViewController

-(void)resizeChildViewController :(id)controller withValue:(float)value;
@end

