//
//  SharkPhoto.h
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/15/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SharkPhotoQuality)  {
    SharkPhotoThumbnail = 0,
    SharkPhotoMedium,
    SharPhotoLarge,
    SharkPhotoOriginal
};

@interface SharkPhoto : NSObject

@property (nonatomic, strong) NSString *title;

- (instancetype)initFromDictionary:(NSDictionary *)photoInfoDict NS_DESIGNATED_INITIALIZER;
- (NSURL *)fetchPhotoURLWithQuality:(SharkPhotoQuality)photoQuality;

@end
