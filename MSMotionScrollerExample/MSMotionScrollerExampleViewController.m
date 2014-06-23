//
//  MSMotionScrollerViewController.m
//  MSMotionScroller
//
//  Created by Marcel Schmitz on 19/06/14.
//  Copyright (c) 2014 hellodev. All rights reserved.
//

#import "MSMotionScrollerExampleViewController.h"
#import "MSMotionScroller.h"
#import "MSMotionScrollerMenuViewController.h"


@interface MSMotionScrollerExampleViewController () <MSMotionScrollerDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    NSInteger currentIndex;
    MSMotionScroller *motionScroll;
    MSMotionScrollerMenuViewController *menu;
    
    BOOL isShowingMenu;
}

@end

@implementation MSMotionScrollerExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate=self;

    // 1. INSTANCIATE AN INTERNAL VARIABLE
    motionScroll = [[MSMotionScroller alloc]init];

    // 2. CONFIGURE A DELEGATE
    motionScroll.delegate = self;
    
    // 3. CHANGE SENSIBILITY (OPTIONAL)
    motionScroll.sensibility = 0.25f;
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidDisappear:animated];

    // 4. CONFIGURE TO PAUSE MOTIONSCROLL IF THE VIEW IS NOT VISIBLE
    motionScroll.pause=NO;
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    // 5. CONFIGURE TO UNPUSE MOTIONSCROLL IF THE VIEW IS VISIBLE AGAIN
    motionScroll.pause=YES;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 100;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

        currentIndex = [[self.tableView indexPathForCell:(UITableViewCell *)[[self.tableView visibleCells] objectAtIndex:0]] row];

}


// 6. IMPLEMENT THE PROTOCOL
- (void)didMeanToScroll:(MSScrollMotionDirection)direction {

    // DIRECTIONS UP AND DOWN SCROLL THE TABLE VIEW
    // DIRECTIONS LEFT AND WRITE OPEN AND CLOSE THE MENU
    
    CGFloat maxIndex = [self.tableView numberOfRowsInSection:0]-1;
    
    switch (direction) {
        case MSScrollMotionDirectionUp:
            if(!isShowingMenu) {
                currentIndex +=[[self.tableView visibleCells] count];
                if(currentIndex>maxIndex){
                    currentIndex=maxIndex;
                }
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        case MSScrollMotionDirectionDown:
            if(!isShowingMenu) {
                currentIndex -=[[self.tableView visibleCells] count];
                if(currentIndex<0) {
                    currentIndex=0;
                }
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
            
        case MSScrollMotionDirectionRight: {
            if(!isShowingMenu) {
                isShowingMenu=YES;
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                menu = (MSMotionScrollerMenuViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"Menu"];
                menu.view.frame = CGRectMake(-320, 0, menu.view.frame.size.width, menu.view.frame.size.height);
                [self.view addSubview:menu.view];
                
                [UIView animateWithDuration:0.2 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    CGRect frame = menu.view.frame;
                    frame.origin.x=-40;
                    menu.view.frame = frame;
                } completion:^(BOOL finished) {
                }];
                
                break;
            }
        }
            
        case MSScrollMotionDirectionLeft: {
            
            if(isShowingMenu) {
                [UIView animateWithDuration:0.2 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    CGRect frame = menu.view.frame;
                    frame.origin.x=-320;
                    menu.view.frame = frame;
                } completion:^(BOOL finished) {
                    menu = nil;
                    isShowingMenu=NO;
                }];
            }
            
            break;
        }
            
        default:
            break;
    }
}

@end
