//
//  RelaxedContainerView.m
//  Akorlar
//
//  Created by Can Bülbül on 29/10/14.
//  Copyright (c) 2014 orkestra. All rights reserved.
//

#import "RelaxedContainerView.h"

@implementation RelaxedContainerView

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
    
    if (view == self)
        return [self scrollView];
    
    return view;
}

@end
