//
//  Song.m
//  Akorlar
//
//  Created by Can Bülbül on 27/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "Song.h"

@implementation Song

- (id) initWithJSON:(NSDictionary *)data {
    self = [super init];
    if (self) {
        NSLog(@"data: %@",data[@"versions"]);
        self.artist    = data[@"artist"];
        self.title     = data[@"title"];
        self.chords    = data[@"chords"];
        self.version   = data[@"version"];
        self.timestamp = data[@"timestamp"];
        self.datahash  = data[@"hash"];
        self.image     = data[@"img"];
        self.versions  = data[@"versions"];
        if (data[@"ratings"])
          self.ratings = [NSMutableArray arrayWithArray:data[@"ratings"]];
        else
          self.ratings = nil;
        
    }
    return self;
}

@end
