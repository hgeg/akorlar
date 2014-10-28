//
//  HomeController.h
//  Akorlar
//
//  Created by Can Bülbül on 08/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <pop/POP.h>
#import "SongsController.h"
#import "AFNetworking.h"

@interface HomeController : UIViewController 
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopBoundary;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIView *menu;
@property (weak, nonatomic) IBOutlet UIButton *newestButton;
@property (weak, nonatomic) IBOutlet UIButton *popularButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
