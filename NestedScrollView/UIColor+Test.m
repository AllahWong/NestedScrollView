//
//  UIColor+Test.m
//  NestedScrollView
//
//  Created by Allah on 2019/3/9.
//  Copyright © 2019年 wyl. All rights reserved.
//

#import "UIColor+Test.h"

@implementation UIColor (Test)

- (CGFloat)test_red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)test_green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)test_blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)test_alpha {
    return CGColorGetAlpha(self.CGColor);
}

@end
