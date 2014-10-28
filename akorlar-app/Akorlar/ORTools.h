//
//  ORTools.h
//  Akorlar
//
//  Created by Can Bülbül on 26/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define loaderTag 689912
#define loaderDensity 0.8

@interface ORTools : NSObject {
}

+ (void) showLoaderOn:(UIView *)view;

+ (void) showLoaderOnWindow;

+ (BOOL) removeLoaderFrom:(UIView*) view;

+ (BOOL) removeLoaderFromWindow;

+ (void) addViewToWindow:(UIView *) view;

+ (BOOL) removeViewFromWindowWithTag:(int) tag;

@end
