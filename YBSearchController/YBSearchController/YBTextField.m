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
        if ([view isMemberOfClass:[UIImageView class]]) {
            CGFloat offSetX = 8.0;
            CGFloat offSetY = (self.frame.size.height - 13.0) / 2.0;
            if (!self.isEditing) {
                offSetX = self.frame.size.width / 2.0 - 8.0 - 13.0;
            }
            CGRect frame = CGRectMake(offSetX,offSetY, 13, 13);
            view.frame = frame;
            continue;
        }
        
        NSString *className = NSStringFromClass([view class]);
        if ([className isEqualToString:@"_UITextFieldRoundedRectBackgroundViewNeue"] || [className isEqualToString:@"UIButton"]) {
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

@end
