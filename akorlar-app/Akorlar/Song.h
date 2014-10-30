//
//  Song.h
//  Akorlar
//
//  Created by Can Bülbül on 27/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *chords;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSNumber *timestamp;
@property (strong, nonatomic) NSString *datahash;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSArray *versions;

- (id) initWithJSON:(NSDictionary *)json;

@end
