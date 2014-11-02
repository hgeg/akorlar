//
//  HomeController.m
//  Akorlar
//
//  Created by Can Bülbül on 08/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "HomeController.h"
#import "SongController.h"

@interface HomeController ()

@end

@implementation HomeController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated]; 
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Show splash animation then fade it out
    NSString *splash_img;
    if (isIPhone5)
         splash_img = @"splash-568x";
    else splash_img = @"splash";
    UIImageView *splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:splash_img]];
    splash.frame = rect(0,0,screen.width,screen.height);
    [self.view addSubview:splash];
    
    POPBasicAnimation *fade = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fade.fromValue = @1; fade.toValue = @0;
    fade.completionBlock = ^(POPAnimation *pa,BOOL b){
        
        // Move logo to final position
        POPSpringAnimation *move = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        move.fromValue = [NSValue valueWithCGRect:rect((screen.width-237)/2,93,237,173)];
        move.toValue = [NSValue valueWithCGRect:rect((screen.width-237)/2,33,237,173)];
        move.completionBlock = ^(POPAnimation *pa,BOOL b){
            self.logoTopBoundary.constant = 13;
            
            // Show search tab and menu buttons
            POPBasicAnimation *fade2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            fade2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            fade2.fromValue = @0; fade2.toValue = @1;
            [self.menu pop_addAnimation:fade2 forKey:@"fade"];
            
            fade2.completionBlock = ^(POPAnimation *pa,BOOL b){
                
                // Pop the newest button
                after(0.05, ^{
                    self.newestButton.hidden = false;
                });
                POPSpringAnimation *pop1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                pop1.fromValue = [NSValue valueWithCGSize:size(0,0)];
                pop1.toValue = [NSValue valueWithCGSize:size(1,1)];
                pop1.completionBlock = ^(POPAnimation *pa,BOOL b){
                    
                    // Pop the popular button
                    after(0.05, ^{
                        self.popularButton.hidden = false;
                    });
                    
                    POPSpringAnimation *pop2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                    pop2.fromValue = [NSValue valueWithCGSize:size(0,0)];
                    pop2.toValue = [NSValue valueWithCGSize:size(1,1)];
                    pop2.completionBlock = ^(POPAnimation *pa,BOOL b){
                        
                        // Pop the random button
                        after(0.05, ^{
                            self.randomButton.hidden = false;
                        });
                        POPSpringAnimation *pop3 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                        pop3.fromValue = [NSValue valueWithCGSize:size(0,0)];
                        pop3.toValue = [NSValue valueWithCGSize:size(1,1)];
                        [self.randomButton pop_addAnimation:pop3 forKey:@"popRandom"];
                    };
                    [self.popularButton pop_addAnimation:pop2 forKey:@"popPopular"];
                };
                [self.newestButton pop_addAnimation:pop1 forKey:@"popNewest"];
            };
        };
        [self.logo pop_addAnimation:move forKey:@"slide"];
    };
    [splash pop_addAnimation:fade forKey:@"fade"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length>2) [self performSegueWithIdentifier:@"search" sender:nil];
}

- (IBAction)search:(id)sender {
    if (self.searchBar.text.length>2) [self performSegueWithIdentifier:@"search" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *term = self.searchBar.text;
    [self.searchBar resignFirstResponder];
    [ORTools showLoaderOnWindow];
    self.searchBar.text = @"";
    if ([segue.identifier isEqualToString:@"random"]) {
        SongController *dest = (SongController *)segue.destinationViewController;
        dest.type = @"random";
    } else if ([segue.identifier isEqualToString:@"search"]) {
        SongsController *dest = (SongsController *)segue.destinationViewController;
        dest.navigationItem.title = @"Arama Sonuçları";
        dest.keyword = term;
    }
}


@end
