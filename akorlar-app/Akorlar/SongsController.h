//
//  SongsController.h
//  Akorlar
//
//  Created by Can Bülbül on 08/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP/POP.h>
#import "ORTools.h"
#import "Song.h"
#import "SongController.h"
#import "AFNetworking.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SongsController : UITableViewController <UISearchBarDelegate>
{
    UISearchBar *bar;
    UIButton *button;
    NSMutableArray *songs;
}

@property (strong, nonatomic) NSString *keyword;

@end
