//
//  SongController.m
//  Akorlar
//
//  Created by Can Bülbül on 09/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "SongController.h"
#import "Song.h"
#import "UIImageView+AFNetworking.h"

@interface SongController ()

@end

@implementation SongController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.artistPic.layer.cornerRadius = self.artistPic.frame.size.width/2.0;
    self.artistPic.clipsToBounds = true;
    self.artistPic.layer.borderColor = [rgb(240, 240, 240) CGColor];
    self.artistPic.layer.borderWidth = 1;
}

- (NSMutableAttributedString *)markChords:(NSArray *)chords onString:(NSString *)string {
    NSLog(@"chords: %@",chords);
    NSMutableAttributedString *tabText = [[NSMutableAttributedString alloc] initWithString:string];
    [tabText beginEditing];
    NSMutableArray *variations = [[NSMutableArray alloc] initWithCapacity:[chords count]*4];
    [chords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [variations addObjectsFromArray:@[
        f(@"%@-",(NSString *)obj),
        f(@"-%@",(NSString *)obj),
        f(@"%@  ",(NSString *)obj),
        f(@"  %@",(NSString *)obj),
        f(@"%@\n",(NSString *)obj),
        f(@"\n%@ ",(NSString *)obj),
        f(@" %@\n",(NSString *)obj),
        f(@"\n%@-",(NSString *)obj),
        f(@"\n%@\n",(NSString *)obj),
        f(@"\n %@",(NSString *)obj),
        f(@"%@ \n",(NSString *)obj),
        f(@"%@ ",(NSString *)obj),
        f(@"[%@]",(NSString *)obj),
        ]];
    }];
    for (NSString *chord in variations) {
      NSRange range = NSMakeRange(0, tabText.string.length);
      while(range.location != NSNotFound) {
        range = [tabText.string rangeOfString:chord options:0 range:range];
        if(range.location != NSNotFound) {
          [tabText addAttribute:NSForegroundColorAttributeName value:hex(0xcb4e3f) range:range];
          range = NSMakeRange(range.location + range.length, tabText.string.length - (range.location + range.length));
            }
        }
        
    }
    [tabText endEditing];
    return tabText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ORTools showLoaderOnWindow];
    isSmall = false;
    self.navigationItem.title = @"";
    self.tabView.userInteractionEnabled = false;
    self.tabView.delegate = self;
    self.coverHeightConstraint.constant = screen.width*2;
    if (isIPad)
        self.tabsBottomConstraint.constant = -screen.height+168;
    else
        self.tabsBottomConstraint.constant = -screen.height+468;
    
    if ([self.type isEqualToString:@"fixed"]) {
        
        self.artistTitle.text = self.song.artist;
        self.artistTitleSmall.text = self.song.artist;
        self.songTitle.text = self.song.title;
        self.songTitleSmall.text = self.song.title;
        
        self.navigationItem.title = self.song.title;
        self.versionTitle.text = f(@"Versiyon %ld",(long)[self.song.version integerValue]);
        self.ratingLabel.text = self.song.ratings ? f(@"%@",self.song.ratings[[self.song.version integerValue]-1]):@"0";
        
        self.versionButton.enabled = [self.song.versions count]>1?true:false;
        
        [self.artistPic sd_setImageWithURL:[NSURL URLWithString:self.song.image] placeholderImage: [UIImage imageNamed:@"songdetail_noimage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                self.coverPic.image = [image applyBlurWithRadius:1 tintColor:rgba(0, 0, 0, 120) saturationDeltaFactor:1.5 maskImage:nil];
            } else {
                self.coverPic.image = [UIImage imageNamed:@"home_bg.png"];
                coverCenter = self.coverPic.center.y;
            }
            
            NSMutableAttributedString *tabText = [self markChords:self.song.chords onString:[NSString stringWithContentsOfURL:[NSURL URLWithString:f(@"http://orkestra.co/akorlar/data/%@",self.song.datahash)] encoding:NSUTF8StringEncoding error:nil]];
            
            self.tabView.textColor = hex(0x364047);
            
            self.tabView.attributedText = tabText;
            
            if(isIPad){
                self.tabView.textContainer.lineFragmentPadding = 20;
                self.tabView.font = [UIFont systemFontOfSize:22];
            }else
                self.tabView.font = [UIFont systemFontOfSize:14];
            
            after(0.5, ^{
                [ORTools removeLoaderFromWindow];
            })
        }];
        
        return;
    }
    
    if ([self.type isEqualToString:@"random"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://orkestra.co/akorlar/random" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *d = (NSDictionary *)responseObject;
            self.song = [[Song alloc] initWithJSON:d[@"data"]];
            [self.versionsTable reloadData];
            
            self.artistTitle.text = self.song.artist;
            self.artistTitleSmall.text = self.song.artist;
            self.songTitle.text = self.song.title;
            self.songTitleSmall.text = self.song.title;
            self.versionTitle.text = f(@"Versiyon %ld",(long)[self.song.version integerValue]);
            
            self.navigationItem.title = self.song.title;
            self.ratingLabel.text = self.song.ratings ? f(@"%@",self.song.ratings[[self.song.version integerValue]-1]):@"0";
            self.versionButton.enabled = [self.song.versions count]>1?true:false;
            
            NSMutableAttributedString *tabText = [self markChords:self.song.chords onString:[NSString stringWithContentsOfURL:[NSURL URLWithString:f(@"http://orkestra.co/akorlar/data/%@",self.song.datahash)] encoding:NSUTF8StringEncoding error:nil]];
            
            self.tabView.textColor = hex(0x364047);
            
            self.tabView.attributedText = tabText;
            
            if(isIPad){
                self.tabView.textContainer.lineFragmentPadding = 20;
                self.tabView.font = [UIFont systemFontOfSize:22];
            }else
                self.tabView.font = [UIFont systemFontOfSize:14];
            
            NSString *imgURL = self.song.image;
            if (imgURL) {
                NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imgURL]];
                [self.artistPic setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"songdetail_noimage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    self.artistPic.image = image;
                    self.coverPic.image = [image applyBlurWithRadius:1 tintColor:rgba(0, 0, 0, 120) saturationDeltaFactor:1.5 maskImage:nil];
                    coverCenter = self.coverPic.center.y;
                    [ORTools removeLoaderFromWindow];
                } failure:^(NSURLRequest *req,NSHTTPURLResponse *res, NSError *error) {
                    coverCenter = self.coverPic.center.y;
                    [ORTools removeLoaderFromWindow];
                } ];
            }else {
                self.artistPic.image = [UIImage imageNamed:@"songdetail_noimage.png"];
                [ORTools removeLoaderFromWindow];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(320, 1800);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showVersions:(id)sender {
    [self.tabView setContentOffset:point(0, 0) animated:true];
    [self.scrollView setContentOffset:point(0,0) animated:true];
    self.scrollView.userInteractionEnabled = true;
    self.scrollView.scrollEnabled = false;
    self.versionsTable.alpha = 0;
    self.versionsTable.hidden = false;
    self.otherVersionsButton.enabled = false;
    [UIView animateWithDuration:0.3 animations:^{
        self.versionsTable.alpha = 1;
    }];
}

- (IBAction)hideVersions:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.versionsTable.alpha = 0;
    } completion:^(BOOL finished) {
        self.versionsTable.hidden = 0;
        self.scrollView.scrollEnabled = true;
        self.otherVersionsButton.enabled = true;
    }];
}

#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.song.versions count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if(indexPath.row==0) {
       cell = [tableView dequeueReusableCellWithIdentifier:@"first" forIndexPath:indexPath];
    } else {
        if (indexPath.row%2==0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"even" forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"odd" forIndexPath:indexPath];
        }
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = rgb(255, 255, 255);
        [cell setSelectedBackgroundView:bgColorView];
        ((UILabel *)[cell viewWithTag:1]).text = f(@"Versiyon %@",self.song.versions[indexPath.row-1]);
        ((UILabel *)[cell viewWithTag:2]).text = f(@"%@ ★",self.song.ratings?self.song.ratings[indexPath.row-1]:@"0");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ORTools showLoaderOnWindow];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self hideVersions:nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [ORTools linkify:f(@"http://orkestra.co/akorlar/%@/%@/%d",self.song.artist,self.song.title,indexPath.row)];
    NSLog(@"url: %@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *d = ((NSDictionary *)responseObject)[@"data"][0];
        self.song = [[Song alloc] initWithJSON:d];
        [self.versionsTable reloadData];
        
        self.artistTitle.text = self.song.artist;
        self.artistTitleSmall.text = self.song.artist;
        self.songTitle.text = self.song.title;
        self.songTitleSmall.text = self.song.title;
        self.navigationItem.title = self.song.title;
        self.versionTitle.text = f(@"Versiyon %@",self.song.version);
        self.ratingLabel.text = self.song.ratings?f(@"%@",self.song.ratings[[self.song.version integerValue]-1]):0;
        self.rateButton.enabled = true;
        self.ratingLabel.text = self.song.ratings ? f(@"%@",self.song.ratings[[self.song.version integerValue]-1]):@"0";
        self.ratingLabel.textColor = rgb(255,255,255);
        
        NSMutableAttributedString *tabText = [self markChords:self.song.chords onString:[NSString stringWithContentsOfURL:[NSURL URLWithString:f(@"http://orkestra.co/akorlar/data/%@",self.song.datahash)] encoding:NSUTF8StringEncoding error:nil]];
        
        self.tabView.textColor = hex(0x364047);
        
        self.tabView.attributedText = tabText;
        
        if(isIPad){
            self.tabView.textContainer.lineFragmentPadding = 20;
            self.tabView.font = [UIFont systemFontOfSize:22];
        }else
            self.tabView.font = [UIFont systemFontOfSize:14];
        
        NSString *imgURL = self.song.image;
        if (imgURL) {
            NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imgURL]];
            [self.artistPic setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"songdetail_noimage.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                self.artistPic.image = image;
                self.coverPic.image = [image applyBlurWithRadius:1 tintColor:rgba(0, 0, 0, 120) saturationDeltaFactor:1.5 maskImage:nil];
                coverCenter = self.coverPic.center.y;
                [ORTools removeLoaderFromWindow];
            } failure:^(NSURLRequest *req,NSHTTPURLResponse *res, NSError *error) {
                coverCenter = self.coverPic.center.y;
                [ORTools removeLoaderFromWindow];
            } ];
        }else {
            self.artistPic.image = [UIImage imageNamed:@"songdetail_noimage.png"];
            [ORTools removeLoaderFromWindow];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark Scroll View Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int pos = scrollView.contentOffset.y;
    if (scrollView == self.tabView) {
        if (pos<0) {
            self.tabView.userInteractionEnabled = false;
            if(pos<-10){
               [self.tabView setContentOffset:point(0,0) animated:false];
                [self.scrollView setContentOffset:point(0, 0) animated:true];
            }
            
        }
    }else{
        int pos = scrollView.contentOffset.y;
        if(pos>=100){
            pos = 100;
            [scrollView setContentOffset:point(0, 100) animated:false];
            if (!isSmall) {
                POPSpringAnimation *move = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                CGRect aframe = self.artistContainer.frame;
                move.fromValue = [NSValue valueWithCGRect:aframe];
                
                if(isIPad) {
                    move.toValue = [NSValue valueWithCGRect:rect(0,aframe.origin.y,aframe.size.width,aframe.size.height)];
                }else{
                    move.toValue = [NSValue valueWithCGRect:rect(-18,aframe.origin.y,aframe.size.width,aframe.size.height)];
                }
                move.completionBlock = ^(POPAnimation *pa,BOOL b){
                    [UIView animateWithDuration:0.25 animations:^{
                        self.smallContainer.alpha = 1;
                    }];
                };
                [self.artistContainer pop_removeAllAnimations];
                [self.artistContainer pop_addAnimation:move forKey:@"moveToLeft"];
            }
            isSmall = true;
            self.tabView.userInteractionEnabled = true;
        }
        if (isSmall && pos<100) {
            self.artistPicHeightConstraint.constant = 50;
            self.artistPicWidthConstraint.constant  = 50;
            [UIView animateWithDuration:0.25 animations:^{
                self.smallContainer.alpha = 0;
            } completion:^(BOOL finished) {
                CGRect aframe = self.artistContainer.frame;
                self.smallContainer.alpha = 0;
                POPSpringAnimation *move2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                move2.fromValue = [NSValue valueWithCGRect:aframe];
                move2.toValue = [NSValue valueWithCGRect:rect(screen.width/2-48,aframe.origin.y,aframe.size.width,aframe.size.height)];
                [self.artistContainer pop_addAnimation:move2 forKey:@"moveToRight"];
                isSmall = false;
            }];
        }
        if (!isSmall) {
            self.smallContainer.alpha = 0;
            self.tabView.userInteractionEnabled = false;
        }
        if(isIPad) {
            int newSize = pos>=80?80+22*(100-pos)/20:100;
            int newX = 48 - newSize/2.0;
            int newY = pos>=80?(200-pos-newSize)/2.0:8;
            self.artistPic.frame = rect(newX, newY, newSize, newSize);
            CGPoint oldCenter = self.coverPic.center;
            self.coverPic.center = point(oldCenter.x,coverCenter+(pos)/4.0);
            self.artistPic.layer.cornerRadius = self.artistPic.frame.size.width/2.0;
        }else {
            int newSize = pos>=80?50+22*(100-pos)/20:72;
            int newX = 48 - newSize/2.0;
            int newY = pos>=80?(160-pos-newSize)/2.0:5;
            self.artistPic.frame = rect(newX, newY, newSize, newSize);
            CGPoint oldCenter = self.coverPic.center;
            self.coverPic.center = point(oldCenter.x,coverCenter+(pos)/4.0);
            self.artistPic.layer.cornerRadius = self.artistPic.frame.size.width/2.0;
        }
    }
}


- (IBAction)rate:(id)sender {
    UIButton *ratingButton = (UIButton *)sender;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [ORTools showLoaderOn:ratingButton withMask:ratingButton.imageView.image];
    [manager GET:[ORTools linkify:f(@"http://orkestra.co/akorlar/rate/%@/%@/%@",self.song.artist,self.song.title,self.song.version)] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.ratingLabel.text = f(@"%@",((NSDictionary *)responseObject)[@"rating"]);
        self.ratingLabel.textColor = hex(0xcb4e3f);
        [ORTools removeLoaderFrom:ratingButton];
        ratingButton.enabled = false;
        if (self.song.ratings) {
            self.song.ratings[[self.song.version integerValue]-1] = ((NSDictionary *)responseObject)[@"rating"];
        } else {
            self.song.ratings = [NSMutableArray arrayWithArray:self.song.versions];
            for (int i=0; i<[self.song.versions count]; i++) {
                if(i==[self.song.version integerValue]-1)
                    self.song.ratings[i] = ((NSDictionary *)responseObject)[@"rating"];
                else
                  self.song.ratings[i] = @"0";
            }
        }
        
        [self.versionsTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
