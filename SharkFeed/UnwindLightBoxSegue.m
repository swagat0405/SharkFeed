//
//  UnwindLightBoxSegue.m
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/17/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import "UnwindLightBoxSegue.h"

@implementation UnwindLightBoxSegue

- (void)perform {
    
    UIView *sourceView = self.sourceViewController.view;
    UIView *destinationView = self.destinationViewController.view;
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window insertSubview:destinationView belowSubview:sourceView];
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.frame = self.destinationViewFrame;
    } completion:^(BOOL finished) {
        [self.destinationViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}
@end
