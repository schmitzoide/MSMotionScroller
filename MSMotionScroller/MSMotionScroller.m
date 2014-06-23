//
//  MSMotionScroller
//
//  Version 1.0
//
//  Created by Marcel Schmitz on 19/06/14.
//  Copyright (c) 2014 hellodev.
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/schmitzoide/MSMotionScroller
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.


#import <CoreMotion/CoreMotion.h>
#import "MSMotionScroller.h"


@interface MSMotionScroller() {

    CGFloat motionLastPitch, motionLastRoll;
    CMMotionManager *motionManager;
    CADisplayLink *motionDisplayLink;

    NSInteger currentIndex, maxIndex;
    
    BOOL isScrolling;
    
}

@end

@implementation MSMotionScroller

- (instancetype)init {

    if(self = [super init]) {
    
        motionManager = [[CMMotionManager alloc] init];
        motionManager.deviceMotionUpdateInterval = 0.02;
        
        motionDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(motionRefresh:)];
        [motionDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        if ([motionManager isDeviceMotionAvailable]) {
            [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
        }
        
        currentIndex=0;
        isScrolling=NO;
        self.sensibility=0.25f;
        self.pause=YES;
        
    }
    
    return self;

}

- (void)motionRefresh:(id)sender {
    
    CGFloat pitchDifference =  motionManager.deviceMotion.attitude.pitch - motionLastPitch;
    CGFloat rollDifference =  motionManager.deviceMotion.attitude.roll - motionLastRoll;
    
    motionLastPitch = motionManager.deviceMotion.attitude.pitch;
    motionLastRoll = motionManager.deviceMotion.attitude.roll;
    
    if(!isScrolling && !self.pause) {
        if(pitchDifference>self.sensibility*0.5f) {
            // DOWN
            [self doScroll:MSScrollMotionDirectionDown];
        } else if (pitchDifference<self.sensibility*-1*0.5f) {
            // UP
            [self doScroll:MSScrollMotionDirectionUp];
        } else if(rollDifference>self.sensibility) {
            // RIGHT
            [self doScroll:MSScrollMotionDirectionRight];
        } else if (rollDifference<self.sensibility*-1) {
            // LEFT
            [self doScroll:MSScrollMotionDirectionLeft];
        }
    
    }
    
}

- (void)doScroll:(MSScrollMotionDirection)direction {

        [self.delegate didMeanToScroll:direction];

        isScrolling=YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            isScrolling=NO;
        });

}


@end
