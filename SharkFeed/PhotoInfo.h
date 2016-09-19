//
//  PhotoInfo.h
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/16/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInfo : NSObject

@property (nonatomic, strong) NSString      *identifier;
@property (nonatomic, strong) NSString      *secret;
@property (nonatomic, strong) NSString      *server;
@property (nonatomic, strong) NSString      *farm;
@property (nonatomic, strong) NSString      *dateuploaded;
@property (nonatomic, strong) NSString      *isfavorite;
@property (nonatomic, strong) NSString      *license;
@property (nonatomic, strong) NSString      *safety_level;
@property (nonatomic, strong) NSString      *rotation;
@property (nonatomic, strong) NSString      *originalsecret;
@property (nonatomic, strong) NSString      *originalformat;
@property (nonatomic, strong) NSString      *media;
@property (nonatomic, strong) NSString      *views;

@property (nonatomic, strong) NSDictionary  *owner;
@property (nonatomic, strong) NSDictionary  *title;
@property (nonatomic, strong) NSDictionary  *photoDescription;
@property (nonatomic, strong) NSDictionary  *visibility;
@property (nonatomic, strong) NSDictionary  *dates;
@property (nonatomic, strong) NSDictionary  *editability;
@property (nonatomic, strong) NSDictionary  *publicEditability;
@property (nonatomic, strong) NSDictionary  *usage;
@property (nonatomic, strong) NSDictionary  *comments;
@property (nonatomic, strong) NSDictionary  *notes;
@property (nonatomic, strong) NSDictionary  *people;
@property (nonatomic, strong) NSDictionary  *tags;
@property (nonatomic, strong) NSDictionary  *urls;

- (instancetype)initWithDictionary:(NSDictionary *)photoInfoDict NS_DESIGNATED_INITIALIZER;
- (NSString *)getPhotoDescription;
- (NSString *)getTitle;
@end
