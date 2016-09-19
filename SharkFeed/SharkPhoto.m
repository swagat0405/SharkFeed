//
//  SharkPhoto.m
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/15/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import "SharkPhoto.h"

@interface SharkPhoto ()

    @property (nonatomic, strong) NSString *identifier;
    @property (nonatomic, strong) NSString *owner;
    @property (nonatomic, strong) NSString *secret;
    @property (nonatomic, strong) NSString *server;
    @property (nonatomic, strong) NSString *farm;
    @property (nonatomic, strong) NSString *isPublic;
    @property (nonatomic, strong) NSString *isFriend;
    @property (nonatomic, strong) NSString *isFamily;
    @property (nonatomic, strong) NSString *url_l;
    @property (nonatomic, strong) NSString *url_c;
    @property (nonatomic, strong) NSString *url_t;
    @property (nonatomic, strong) NSString *url_o;
@end

@implementation SharkPhoto

- (instancetype)init {
    
    //Calling designated initializer from init with nil entries and returning nil. Object must always be created with a valid info dictionary object.
    self = [self initFromDictionary:nil];
    return nil;
}

- (instancetype)initFromDictionary:(NSDictionary *)photoInfoDict {
    
    if (self = [super init]) {
        
        self.identifier = photoInfoDict[@"id"];
        self.owner = photoInfoDict[@"owner"];
        self.secret = photoInfoDict[@"secret"];
        self.server = photoInfoDict[@"server"];
        self.farm = photoInfoDict[@"farm"];
        self.title = photoInfoDict[@"title"];
        self.isPublic = photoInfoDict[@"ispublic"];
        self.isFriend = photoInfoDict[@"isfriend"];
        self.isFamily = photoInfoDict[@"isfamily"];
        self.url_c = photoInfoDict[@"url_c"];
        self.url_l = photoInfoDict[@"url_l"];
        self.url_o = photoInfoDict[@"url_o"];
        self.url_t = photoInfoDict[@"url_t"];
    }
    return self;
}

- (NSURL *)fetchPhotoURLWithQuality:(SharkPhotoQuality)photoQuality {

    switch (photoQuality) {
        case SharkPhotoThumbnail:
            return [NSURL URLWithString:self.url_t];
        case SharkPhotoMedium:
            return [NSURL URLWithString:self.url_c];
        case SharPhotoLarge:
            return [NSURL URLWithString:self.url_l];
        case SharkPhotoOriginal:
            return (self.url_o != nil && ![self.url_o isEqualToString:@""])?[NSURL URLWithString:self.url_o]:[NSURL URLWithString:self.url_l];
        default:
            break;
    }
}

@end
