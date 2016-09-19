//
//  SharkFeedServiceLibrary.h
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/15/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PhotoInfo;

@interface SharkFeedServiceLibrary : NSObject

typedef void(^fetchPhotosCompletionBlock)(NSArray *sharkPhotoUrlsArray);
typedef void(^fetchPhotoInfoCompletionBlock)(PhotoInfo *photoInfo);
typedef void(^flickrServiceResponseHandler)(NSData *flickrData);

+ (SharkFeedServiceLibrary *)sharedInstance;
- (void)fetchPhotosFromFlickrForPage:(NSString *)page completionHandler:(fetchPhotosCompletionBlock)completionBlock;
- (void)fetchPhotoInfoForPhotoId:(NSString *)photoId completionHandler:(fetchPhotoInfoCompletionBlock)completionBlock;
@end
