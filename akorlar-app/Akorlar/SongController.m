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
    [ORTools showLoaderOnWindow];

    self.artistPic.layer.cornerRadius = self.artistPic.frame.size.width/2.0;
    self.artistPic.clipsToBounds = true;
    self.artistPic.layer.borderColor = [rgb(240, 240, 240) CGColor];
    self.artistPic.layer.borderWidth = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSmall = false;
    self.navigationItem.title = @"";
    self.tabView.userInteractionEnabled = false;
    self.tabView.delegate = self;
    self.coverHeightConstraint.constant = screen.width+200;
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
        
        [self.artistPic sd_setImageWithURL:[NSURL URLWithString:self.song.image] placeholderImage: [UIImage imageNamed:@"songdetail_noimage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                self.coverPic.image = [image applyBlurWithRadius:1 tintColor:rgba(0, 0, 0, 120) saturationDeltaFactor:1.5 maskImage:nil];
            } else {
                self.coverPic.image = [UIImage imageNamed:@"home_bg.png"];
                coverCenter = self.coverPic.center.y;
            }
            
            self.tabView.text = [NSString stringWithContentsOfURL:[NSURL URLWithString:f(@"http://orkestra.co/akorlar/data/%@",self.song.datahash)] encoding:NSUTF8StringEncoding error:nil];
            self.tabView.font = [UIFont systemFontOfSize:12];
            self.tabView.textColor = hex(0x364047);
            
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
            //NSLog(@"\nSong:\n  title: %@\n  artist: %@\n  version: %@\n  timestamp: %d\n  hash: %@",self.song.title,self.song.artist,self.song.version, [self.song.timestamp integerValue], self.song.datahash);
            
            self.artistTitle.text = self.song.artist;
            self.artistTitleSmall.text = self.song.artist;
            self.songTitle.text = self.song.title;
            self.songTitleSmall.text = self.song.title;
            self.navigationItem.title = self.song.title;
            self.versionTitle.text = f(@"Versiyon %@",self.song.version);
            
            NSLog(@"chords: %@",self.song.chords);
            
            self.tabView.text = [NSString stringWithContentsOfURL:[NSURL URLWithString:f(@"http://orkestra.co/akorlar/data/%@",self.song.datahash)] encoding:NSUTF8StringEncoding error:nil];
            self.tabView.font = [UIFont systemFontOfSize:14];
            self.tabView.textColor = hex(0x364047);
            
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
        ((UILabel *)[cell viewWithTag:2]).text = f(@"25 ★");
    }
    return cell;
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
                move.toValue = [NSValue valueWithCGRect:rect(-18,aframe.origin.y,aframe.size.width,aframe.size.height)];
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
        int newSize = pos>=80?50+22*(100-pos)/20:72;
        int newX = 48 - newSize/2.0;
        int newY = pos>=80?(160-pos-newSize)/2.0:5;
        self.artistPic.frame = rect(newX, newY, newSize, newSize);
        CGPoint oldCenter = self.coverPic.center;
        self.coverPic.center = point(oldCenter.x,coverCenter+(pos)/4.0);
        self.artistPic.layer.cornerRadius = self.artistPic.frame.size.width/2.0;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    UIView *endView = [self.view hitTest:location withEvent:nil];
    
    NSLog(@"point: (%.2f,%.2f), receiver: %@",location.x,location.y,endView);
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
