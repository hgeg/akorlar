//
//  EagerScrollView.m
//  Akorlar
//
//  Created by Can Bülbül on 29/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "EagerScrollView.h"

@implementation EagerScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    // Always return us.
    return view ;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // We want EVERYTHING!
    return YES;
}

@end
