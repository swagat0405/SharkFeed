//
//  PhotoInfo.m
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/16/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import "PhotoInfo.h"

@implementation PhotoInfo

- (instancetype)init
{
    //Calling designated initializer from init with nil entries and returning nil. Object must always be created with a valid info dictionary object.
    self = [self initWithDictionary:nil];
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)photoInfoDict {
    
    if (self = [super init]) {
        
        self.identifier = photoInfoDict[@"id"];
        self.secret = photoInfoDict[@"secret"];
        self.server = photoInfoDict[@"server"];
        self.farm = photoInfoDict[@"farm"];
        self.dateuploaded = photoInfoDict[@"dateuploaded"];
        self.isfavorite = photoInfoDict[@"isfavorite"];
        self.license = photoInfoDict[@"license"];
        self.safety_level = photoInfoDict[@"safety_level"];
        self.rotation = photoInfoDict[@"rotation"];
        self.originalsecret = photoInfoDict[@"originalsecret"];
        self.originalformat = photoInfoDict[@"originalformat"];
        self.owner = photoInfoDict[@"owner"];
        self.title = photoInfoDict[@"title"];
        self.photoDescription = photoInfoDict[@"description"];
        self.visibility = photoInfoDict[@"visibility"];
        self.dates = photoInfoDict[@"dates"];
        self.views = photoInfoDict[@"views"];
        self.editability = photoInfoDict[@"editability"];
        self.publicEditability = photoInfoDict[@"publiceditability"];
        self.usage = photoInfoDict[@"usage"];
        self.comments = photoInfoDict[@"comments"];
        self.notes = photoInfoDict[@"notes"];
        self.people = photoInfoDict[@"people"];
        self.tags = photoInfoDict[@"tags"];
        self.urls = photoInfoDict[@"urls"];
        self.media = photoInfoDict[@"media"];
    }
    return self;
}

- (NSString *)getPhotoDescription {
    
    return self.photoDescription[@"_content"];
}

- (NSString *)getTitle {
    return self.photoDescription[@"_content"];
}

@end
