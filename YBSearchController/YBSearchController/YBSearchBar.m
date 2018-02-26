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
    
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, screenWidth,44.0);
    }
    
    if (self = [super initWithFrame:frame]) {
        _showsCancelButton = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelSearch) name:@"YBSearchControllerWillDismiss" object:nil];
        self.backgroundColor = [UIColor grayColor];
        self.placeholder = @"搜索";
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.textField];
        [self addSubview:self.cancelButton];
    }
    return self;
}

-(void)dealloc {
    NSLog(@"searchBar dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YBSearchControllerWillDismiss" object:nil];
}

#pragma mark - UITextFieldDelagate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.cancelButton setHidden:NO];
    
    if (!self.showsCancelButton) {
        CGFloat cancelButtonWidth = CGRectGetWidth(self.cancelButton.frame);
        CGRect frame = self.textField.frame;
        frame.size.width = frame.size.width - cancelButtonWidth - 8.0;
        [self.textField setFrame:frame];
    }
    
    UIViewController *vc = [self viewController];

    if ([self.delegate respondsToSelector:@selector(searchFieldShouldBeginEditing:)]) {
        [self.delegate searchFieldShouldBeginEditing:textField];
    }
    
    CGRect bgViewFrame = self.backgroundImageView.frame;
    
    CGFloat offsetY = CGRectGetMinY(vc.navigationController.navigationBar.frame);
    
    if(offsetY <= 0) {
        bgViewFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
        bgViewFrame.origin.y -= [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    self.backgroundImageView.frame = bgViewFrame;
    
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
    [self reset];
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
    self.text = field.text;
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

-(void)reset {
    CGFloat offsetX = 10;
    CGFloat offsetY = 8;
    CGFloat width  = self.bounds.size.width  - offsetX * 2.0;
    CGFloat height = self.bounds.size.height - offsetY * 2.0;
    CGRect frame = CGRectMake(offsetX, offsetY, width, height);
    
    if (self.showsCancelButton) {
        CGFloat leftMargin = 10.0;
        width = width - leftMargin - CGRectGetWidth(self.cancelButton.frame);
        frame.size.width = width;
        _cancelButton.hidden = NO;
    } else {
        _cancelButton.hidden = YES;
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.textField.frame = frame;
        self.backgroundImageView.frame = self.bounds;
    } completion:nil];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(void)setShowsCancelButton:(BOOL)showsCancelButton {
    _showsCancelButton = showsCancelButton;
    [self reset];
}

-(void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}

#pragma mark - getter

-(YBTextField *)textField {
    if (!_textField) {
        CGFloat offsetX = 10;
        CGFloat offsetY = 8;
        CGFloat width = self.frame.size.width - offsetX * 2.0;
        CGFloat height = self.frame.size.height - offsetY * 2.0;
        CGRect frame = CGRectMake(offsetX, offsetY, width, height);
        _textField = [[YBTextField alloc] initWithFrame:frame];
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
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_cancelButton sizeToFit];
        [_cancelButton setHidden:YES];
        CGRect frame = _cancelButton.frame;
        frame.size.height = self.frame.size.height;
        frame.origin.x = self.frame.size.width - frame.size.width - 8.0;
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2.0;
        _cancelButton.frame = frame;
    }
    return _cancelButton;
}

-(UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor orangeColor];
    }
    return _backgroundImageView;
}
@end
