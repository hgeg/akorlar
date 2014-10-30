//
//  SongsController.m
//  Akorlar
//
//  Created by Can Bülbül on 08/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "SongsController.h"
#import "ItemCell.h"

@interface SongsController ()

@end

@implementation SongsController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self search:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar Related Methods

- (IBAction) showSearchBar:(id)sender {
    //container
    UIView *searchContainer = [[UIView alloc] initWithFrame:rect(0,20,320,44)];
    searchContainer.backgroundColor = hex(0xcb4e3f);
    searchContainer.tag = 4512;
    
    //search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:rect(-260,0,260,44)];
    searchBar.placeholder = @"Akor Arama";
    searchBar.backgroundImage = [UIImage imageNamed:@"home_nullcontainer.png"];
    searchBar.delegate = self;
    
    //cancel button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:rect(320,0,60,44)];
    [cancelButton setTitle:@"İptal" forState:UIControlStateNormal];
    [cancelButton setTitleColor:rgb(255,255,255) forState:UIControlStateNormal];
    cancelButton.tintColor = rgb(255, 255, 255);
    cancelButton.backgroundColor = rgba(0,0,0,0);
    [cancelButton addTarget:self action:@selector(hideSearchBar:) forControlEvents:UIControlEventTouchUpInside];
    
    bar = searchBar;
    button = cancelButton;
    [searchContainer addSubview:searchBar];
    [searchContainer addSubview:cancelButton];
    
    [ORTools addViewToWindow:searchContainer];
    after(0.1, ^{
        POPSpringAnimation *moveBar = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        moveBar.fromValue = [NSValue valueWithCGRect:rect(-260,0,260,44)];
        moveBar.toValue = [NSValue valueWithCGRect:rect(0,0,260,44)];
        [searchBar pop_addAnimation:moveBar forKey:@"moveBar"];
        
        POPSpringAnimation *moveButton = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        moveButton.fromValue = [NSValue valueWithCGRect:rect(320,0,60,44)];
        moveButton.toValue = [NSValue valueWithCGRect:rect(260,0,60,44)];
        [cancelButton pop_addAnimation:moveButton forKey:@"moveButton"];
        [searchBar becomeFirstResponder];
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.keyword = searchBar.text;
    [self search:nil];
}

- (IBAction) hideSearchBar:(id)sender {
    [bar resignFirstResponder];
    POPSpringAnimation *moveBar = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    moveBar.fromValue = [NSValue valueWithCGRect:rect(0,0,260,44)];
    moveBar.toValue = [NSValue valueWithCGRect:rect(-260,0,260,44)];
    [bar pop_addAnimation:moveBar forKey:@"moveBar"];
    
    POPSpringAnimation *moveButton = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    moveButton.fromValue = [NSValue valueWithCGRect:rect(260,0,60,44)];
    moveButton.toValue = [NSValue valueWithCGRect:rect(320,0,60,44)];
    [button pop_addAnimation:moveButton forKey:@"moveButton"];
    after(0.1, ^{
        [ORTools removeViewFromWindowWithTag:4512];
    });
}

- (IBAction) search:(id)sender {
    [bar resignFirstResponder];
    [ORTools showLoaderOnWindow];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[ORTools linkify:f(@"http://orkestra.co/akorlar/search/%@/",self.keyword)] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        songs = [[NSMutableArray alloc] initWithCapacity:10];
        NSArray *data = (NSArray *)responseObject[@"data"];
        for (NSDictionary* d in data) {
            Song *s = [[Song alloc] initWithJSON:d];
            [songs addObject:s];
        }
        [self.tableView reloadData];
        [self.tableView setContentOffset:point(0, 0) animated:true];
        [ORTools removeLoaderFromWindow];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.navigationController popViewControllerAnimated:true];
        [ORTools removeLoaderFromWindow];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [bar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return songs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Song *s = songs[indexPath.row];
    cell.titleLabel.text = s.title;
    cell.artistLabel.text = s.artist;
    cell.song = s;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = hex(0xCB4E3F);
    [cell setSelectedBackgroundView:bgColorView];
    @try {
        cell.itemImage.image = [UIImage imageNamed:@"songdetail_noimage.png"];
        cell.itemImage.layer.cornerRadius = cell.itemImage.frame.size.width/2.0;
        cell.itemImage.clipsToBounds = true;
        cell.itemImage.layer.borderColor = [rgb(240, 240, 240) CGColor];
        cell.itemImage.layer.borderWidth = 1;
        [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:s.image] placeholderImage:[UIImage imageNamed:@"songdetail_noimage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *url) {
            if (image) {
                cell.itemImage.image = image;
            } else {
                cell.itemImage.image = [UIImage imageNamed:@"songdetail_noimage.png"];
            }
        }];
    }
    @catch (NSException *exception) {
        cell.itemImage.image = [UIImage imageNamed:@"artist_default.png"];
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self hideSearchBar:nil];
    [ORTools showLoaderOnWindow];
    SongController *dest = (SongController *)segue.destinationViewController;
    dest.type = @"fixed";
    dest.song = ((ItemCell *)sender).song;
}


@end
