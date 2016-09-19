//
//  LightBoxSegue.m
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/17/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import "LightBoxSegue.h"
#import "LightBoxViewController.h"

@implementation LightBoxSegue

- (void)perform {

    UIView *destinationView = self.destinationViewController.view;
    destinationView.frame = self.sourceView.frame;
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    [window insertSubview:self.destinationViewController.view aboveSubview:self.sourceView];
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:nil];
    }];
}
@end
