//
//  UIFont+Override.m
//  Akorlar
//
//  Created by Can Bülbül on 27/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "UIFont+Override.h"

@implementation UIFont (Override)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans" size:fontSize];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Bold" size:fontSize];
}

+ (UIFont *)lightSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"OpenSans-Light" size:fontSize];
}

#pragma clang diagnostic pop

@end
