//
//  ItemCell.h
//  Akorlar
//
//  Created by Can Bülbül on 26/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Song;

@interface ItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) Song *song;

@end
