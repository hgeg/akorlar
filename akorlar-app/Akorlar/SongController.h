//
//  SongController.h
//  Akorlar
//
//  Created by Can Bülbül on 09/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <pop/POP.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@class Song;


@interface SongController : UIViewController <UIScrollViewDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL isSmall;
    float coverCenter;
}

@property (strong, nonatomic) NSString *type; //random or fixed
@property (strong, nonatomic) Song *song; //not null if type is fixed

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *artistTitle;
@property (weak, nonatomic) IBOutlet UILabel *artistTitleSmall;
@property (weak, nonatomic) IBOutlet UILabel *songTitleSmall;
@property (weak, nonatomic) IBOutlet UIView *smallContainer;
@property (weak, nonatomic) IBOutlet UIImageView *artistPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artistPicHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artistPicWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *artistContainer;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *versionTitle;
@property (weak, nonatomic) IBOutlet UIImageView *coverPic;
@property (weak, nonatomic) IBOutlet UITextView *tabView;
@property (weak, nonatomic) IBOutlet UITableView *versionsTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabsBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *otherVersionsButton;
@property (weak, nonatomic) IBOutlet UIButton *versionButton;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;

@end
