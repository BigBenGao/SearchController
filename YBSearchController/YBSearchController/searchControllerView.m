//
//  searchControllerView.m
//  YBSearchController
//
//  Created by Gao on 2018/2/8.
//  Copyright © 2018年 Gao. All rights reserved.
//

#import "searchControllerView.h"

@implementation searchControllerView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        if (!self.dimsBackgroundDuringPresentation) {
            return view;
        }
        return [self.resultView hitTest:point withEvent:event];
    }
    return view;
}

-(void)setDimsBackgroundDuringPresentation:(BOOL)dimsBackgroundDuringPresentation {
    _dimsBackgroundDuringPresentation = dimsBackgroundDuringPresentation;
    if (_dimsBackgroundDuringPresentation) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YBSearchControllerWillDismiss" object:nil];
}

@end
