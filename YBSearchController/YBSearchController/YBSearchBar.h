//
//  YBSearchBar.h
//  YBSearchController
//
//  Created by Gao on 2017/12/27.
//  Copyright © 2017年 Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBSearchBarDelegate <NSObject>

@optional

- (BOOL)searchFieldShouldBeginEditing:(UITextField *)textField;

- (void)searchFieldDidBeginEditing:(UITextField *)textField;

- (BOOL)searchFieldShouldEndEditing:(UITextField *)textField;

- (BOOL)searchFieldDidEndEditing:(UITextField *)textField;

- (BOOL)searchFieldShouldReturn:(UITextField *)textField;

- (BOOL)searchFieldTextDidChanged:(UITextField *)textField;

@end

@interface YBSearchBar : UIView

@property(nonatomic,weak) id <YBSearchBarDelegate> delegate;

@end
