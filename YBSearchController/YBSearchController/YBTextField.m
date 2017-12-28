//
//  YBTextField.m
//  YBSearchController
//
//  Created by Gao on 2017/12/27.
//  Copyright © 2017年 Gao. All rights reserved.
//

#import "YBTextField.h"

@implementation YBTextField

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.backgroundImageView];
        
        UIImage *imageIcon = [UIImage imageNamed:@"SearchContactsBarIcon"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:imageIcon];
        self.leftView = imageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"搜索"];
        NSRange range = NSMakeRange(0, attr.string.length);
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:142 / 255.0 green:142 / 255.0 blue:142 / 255.0 alpha:1.0] range:range];
        self.attributedPlaceholder = attr;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        
        NSString *className = NSStringFromClass([view class]);
        
        if ([className isEqualToString:@"_UITextFieldRoundedRectBackgroundViewNeue"] ||
            [className isEqualToString:@"UIButton"]) {
            continue;
        }
        
        if ([view isMemberOfClass:[UIImageView class]]) {
            
            if (self.backgroundImageView == view) {
                CGRect frame = self.frame;
                frame.origin.x = 0;
                frame.origin.y = 0;
                self.backgroundImageView.frame = frame;
                continue;
            }
            
            CGFloat offSetX = 8.0;
            CGFloat offSetY = (self.frame.size.height - 13.0) / 2.0;
            if (!self.isEditing) {
                offSetX = self.frame.size.width / 2.0 - 8.0 - 13.0;
            }
            CGRect frame = CGRectMake(offSetX,offSetY, 13, 13);
            view.frame = frame;
            continue;
        }
        
        CGFloat offSetX = 27.0;
        if (!self.isEditing) {
            offSetX = self.frame.size.width / 2.0;
        }
        CGRect frame = view.frame;
        frame.origin.x = offSetX;
        view.frame = frame;
    }
}

#pragma mark - components

-(UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView.userInteractionEnabled = NO;
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _backgroundImageView.image = [UIImage imageNamed:@"searchbar_textfield_widget"];
    }
    return _backgroundImageView;
}

@end
