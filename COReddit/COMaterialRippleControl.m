//
//  COMaterialRippleControl.m
//  COReddit
//
//  Created by Matthew Sun on 10/14/15.
//  Copyright © 2015 Matthew Sun. All rights reserved.
//

#import "COMaterialRippleControl.h"

@interface COMaterialRippleControl()




@property (nonatomic, strong) UIView *circle;

@end

@implementation COMaterialRippleControl

- (BOOL)beginTrackingWithTouch:(UITouch * _Nonnull)touch
                     withEvent:(UIEvent * _Nullable)event {
    CGRect frame = CGRectMake(0.0, 0.0, 10.0, 10.0);
    self.circle = [[UIView alloc] initWithFrame:frame];
    self.circle.backgroundColor = [UIColor blueColor];
    [self addSubview:self.circle];
    
    return NO;
}

- (void)endTrackingWithTouch:(UITouch * _Nullable)touches
                   withEvent:(UIEvent * _Nullable)event {
    [self.circle removeFromSuperview];
}

@end
