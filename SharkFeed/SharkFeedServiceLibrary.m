//
//  SharkFeedServiceLibrary.m
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/15/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import "SharkFeedServiceLibrary.h"
#import "SharkPhoto.h"
#import "PhotoInfo.h"

@interface SharkFeedServiceLibrary () <NSURLSessionDelegate>

@end

@implementation SharkFeedServiceLibrary

static NSString * const flickrEndPointURI = @"https://api.flickr.com/services/rest/";
static NSString * const API_KEY = @"949e98778755d1982f537d56236bbb42";

+ (SharkFeedServiceLibrary *)sharedInstance {
    
    static SharkFeedServiceLibrary *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SharkFeedServiceLibrary alloc]init];
    });
    return sharedInstance;
}

- (void)fetchPhotosFromFlickrForPage:(NSString *)page completionHandler:(fetchPhotosCompletionBlock)completionBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlString = [NSString stringWithFormat:@"%@?method=flickr.photos.search&api_key=%@&text=shark&format=json&nojsoncallback=1&page=%@&extras=url_t,url_c,url_l,url_o", flickrEndPointURI, API_KEY, page];
        
        [self makeServiceRequestToFlickWithUrl:urlString andCompletionHandler:^(NSData *flickrData) {
            
            if (flickrData != nil) {
                
                NSError *jsonSerializationError;
                NSDictionary *photosDictionary = [NSJSONSerialization JSONObjectWithData:flickrData options:0 error:&jsonSerializationError];
                NSArray *photoArray = photosDictionary[@"photos"][@"photo"];
                NSMutableArray *photosArray = [NSMutableArray arrayWithCapacity:1];
                
                for (NSDictionary *photoDictionary in photoArray) {
                    SharkPhoto *photo = [[SharkPhoto alloc]initFromDictionary:photoDictionary];
                    [photosArray addObject:photo];
                };
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(photosArray);
                });
            }
        }];
    });
}

- (void)fetchPhotoInfoForPhotoId:(NSString *)photoId completionHandler:(fetchPhotoInfoCompletionBlock)completionBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
        NSString *urlString = [NSString stringWithFormat:@"%@?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", flickrEndPointURI, API_KEY, photoId];
        
        [self makeServiceRequestToFlickWithUrl:urlString andCompletionHandler:^(NSData *flickrData) {
            
            if (flickrData != nil) {
                
                NSError *jsonSerializationError;
                NSDictionary *photosDictionary = [NSJSONSerialization JSONObjectWithData:flickrData options:0 error:&jsonSerializationError];
                NSDictionary *photo = photosDictionary[@"photo"];
                
                PhotoInfo *photoInfo = [[PhotoInfo alloc]initWithDictionary:photo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(photoInfo);
                });
            }
        }];
    });
}


- (void)makeServiceRequestToFlickWithUrl:(NSString *)urlString andCompletionHandler:(flickrServiceResponseHandler)completionHandler {
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *endpointUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:endpointUrl];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(data);
    }];
    [task resume];
}

@end
