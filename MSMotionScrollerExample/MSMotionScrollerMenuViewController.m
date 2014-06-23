//
//  MSMotionScroller2ViewController.m
//  MSMotionScroller
//
//  Created by Marcel Schmitz on 19/06/14.
//  Copyright (c) 2014 hellodev. All rights reserved.
//

#import "MSMotionScrollerMenuViewController.h"
#import "MSMotionScroller.h"

@interface MSMotionScrollerMenuViewController () <MSMotionScrollerDelegate> {

    MSMotionScroller *motionScroll;

}

@end

@implementation MSMotionScrollerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    motionScroll = [[MSMotionScroller alloc]init];
    motionScroll.delegate = self;

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    motionScroll.pause=NO;
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    motionScroll.pause=YES;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)didMeanToScroll:(MSScrollMotionDirection)direction {

    if(direction==MSScrollMotionDirectionRight) {
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    
}

@end
