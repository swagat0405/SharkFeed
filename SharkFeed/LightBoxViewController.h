//
//  LightBoxViewController.h
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/16/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightBoxViewController : UIViewController

@property (nonatomic, strong)   NSArray     *photosArray;
@property                       NSIndexPath *currentPhotoIndex;
@property CGRect selectedCellFrame;
- (void)fetchImageForLightBox;
@end
