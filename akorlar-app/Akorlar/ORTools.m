//
//  ORTools.m
//  Akorlar
//
//  Created by Can Bülbül on 26/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "ORTools.h"
#import "AppDelegate.h"

@implementation ORTools

+ (void) showLoaderOn:(UIView *)view {
    UIActivityIndicatorView *previous = (UIActivityIndicatorView *)[view viewWithTag:loaderTag];
    if(previous) [previous removeFromSuperview];
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithFrame:rect(0, 0, screen.width, screen.height)];
    loader.backgroundColor = rgba(0, 0, 0, 255*loaderDensity);
    loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    loader.alpha = 0;
    loader.tag = loaderTag;
    [view addSubview:loader];
    [loader startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        loader.alpha = 1;
    }];
}

+ (void) showLoaderOnWindow {
    UIWindow *appWindow = [[[UIApplication sharedApplication] delegate] window];
    UIActivityIndicatorView *previous = (UIActivityIndicatorView *)[appWindow viewWithTag:loaderTag];
    if(previous) [previous removeFromSuperview];
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithFrame:rect(0, 0, screen.width, screen.height)];
    loader.backgroundColor = rgba(0, 0, 0, 255*loaderDensity);
    loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    loader.alpha = 0;
    loader.tag = loaderTag;
    [appWindow addSubview:loader];
    [loader startAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        loader.alpha = 1;
    }];
}

+ (BOOL) removeLoaderFrom:(UIView*) view {
    UIActivityIndicatorView *loader = (UIActivityIndicatorView *)[view viewWithTag:loaderTag];
    if(loader){
        [UIView animateWithDuration:0.4 animations:^{
            loader.alpha = 0;
        } completion:^(BOOL finished) {
            [loader removeFromSuperview];
        }];
        return true;
    }else return false;
}

+ (BOOL) removeLoaderFromWindow {
    UIWindow *appWindow = [[[UIApplication sharedApplication] delegate] window];
    UIActivityIndicatorView *loader = (UIActivityIndicatorView *)[appWindow viewWithTag:loaderTag];
    if(loader){
        [UIView animateWithDuration:0.3 animations:^{
            loader.alpha = 0;
        } completion:^(BOOL finished) {
            [loader removeFromSuperview];
        }];
        return true;
    }else return false;
}


+ (void) addViewToWindow:(UIView *) view {
    UIWindow *appWindow = [[[UIApplication sharedApplication] delegate] window];
    UIView *previous = [appWindow viewWithTag:view.tag];
    if(previous) [previous removeFromSuperview];
    view.alpha = 0;
    [appWindow addSubview:view];
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    }];
}

+ (BOOL) removeViewFromWindowWithTag:(int) tag {
    UIWindow *appWindow = [[[UIApplication sharedApplication] delegate] window];
    UIView *view = (UIActivityIndicatorView *)[appWindow viewWithTag:tag];
    if(view){
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        return true;
    }else return false;
}

@end
