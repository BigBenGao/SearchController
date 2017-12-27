//
//  YBSearchBar.m
//  YBSearchController
//
//  Created by Gao on 2017/12/27.
//  Copyright © 2017年 Gao. All rights reserved.
//

#import "YBSearchBar.h"
#import "YBTextField.h"

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface YBSearchBar() <UITextFieldDelegate>

@property(nonatomic,strong) UIImageView *backgroundImageView;

@property(nonatomic,strong) YBTextField *textField;

@property(nonatomic,strong) UIButton *cancelButton;

@end

@implementation YBSearchBar

-(instancetype)initWithFrame:(CGRect)frame {
       frame = CGRectMake(0, 100, screenWidth,44.0);
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.textField];
        [self addSubview:self.cancelButton];
    }
    return self;
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"editing"];
}

#pragma mark - getter

-(UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        CGFloat offsetX = 10;
        CGFloat offsetY = 8;
        CGFloat width = self.frame.size.width - offsetX * 2.0;
        CGFloat height = self.frame.size.height - offsetY * 2.0;
        CGRect frame = CGRectMake(offsetX, offsetY, width, height);
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
//        _backgroundImageView.image = [UIImage imageNamed:@"searchbar_textfield_widget"];
    }
    return _backgroundImageView;
}

-(YBTextField *)textField {
    if (!_textField) {
        _textField = [[YBTextField alloc] initWithFrame:self.backgroundImageView.frame];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:14.0];
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:[UIColor colorWithRed: 6 / 255.0 green: 191 / 255.0 blue: 4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setHidden:YES];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_cancelButton sizeToFit];
        CGRect frame = _cancelButton.frame;
        frame.size.height = self.frame.size.height;
        frame.origin.x = self.frame.size.width - frame.size.width - 8.0;
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2.0;
        _cancelButton.frame = frame;
    }
    return _cancelButton;
}
#pragma mark - UITextFieldDelagate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.cancelButton.hidden = NO;
    CGRect frame = self.backgroundImageView.frame;
    frame.size.width = frame.size.width - self.cancelButton.frame.size.width - 8.0;
    [self.textField setFrame:frame];
    
    if ([self.delegate respondsToSelector:@selector(searchFieldShouldBeginEditing:)]) {
        return [self.delegate searchFieldShouldBeginEditing:textField];
    }
    NSLog(@"%s",__func__);
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchFieldDidBeginEditing:)]) {
        [self.delegate searchFieldDidBeginEditing:textField];
    }
    NSLog(@"%s",__func__);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    self.cancelButton.hidden = YES;
    [self resetSize];
    [self.textField setFrame:self.backgroundImageView.frame];
    
    if ([self.delegate respondsToSelector:@selector(searchFieldShouldEndEditing:)]) {
        return [self.delegate searchFieldShouldEndEditing:textField];
    }
    NSLog(@"%s",__func__);
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchFieldDidEndEditing:)]) {
        [self.delegate searchFieldDidEndEditing:textField];
    }
    NSLog(@"%s",__func__);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchFieldShouldReturn:)]) {
        return [self.delegate searchFieldShouldReturn:textField];
    }
    NSLog(@"%s",__func__);
    return YES;
}

-(void)textDidChange:(UITextField *)field {
    if ([self.delegate respondsToSelector:@selector(searchFieldTextDidChanged:)]) {
        [self.delegate searchFieldTextDidChanged:field];
    }
    NSLog(@"%s",__func__);
}

#pragma mark - UIAction

-(void)cancelSearch {
    [self.textField setText:@""];
    [self.textField resignFirstResponder];
}

#pragma mark - Other

-(void)resetSize {
    CGFloat offsetX = 10;
    CGFloat offsetY = 8;
    CGFloat width = self.frame.size.width - offsetX * 2.0;
    CGFloat height = self.frame.size.height - offsetY * 2.0;
    CGRect frame = CGRectMake(offsetX, offsetY, width, height);
    self.backgroundImageView.frame = frame;
}

@end
