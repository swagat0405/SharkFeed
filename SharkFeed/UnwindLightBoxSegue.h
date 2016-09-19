//
//  UnwindLightBoxSegue.h
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/17/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnwindLightBoxSegue : UIStoryboardSegue

@property CGRect destinationViewFrame;
@property (nonatomic, strong) UIView *imageView;

@end
