//
//  YBSearchController.h
//  YBSearchController
//
//  Created by Gao on 2017/12/27.
//  Copyright © 2017年 Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBSearchBar;

@protocol SearchResultsUpdating <NSObject>
@required
- (void)updateSearchResultsForController:(UISearchController * _Nonnull)searchController;
@end

@interface YBSearchController : UIViewController

- (instancetype _Nonnull )initWithSearchResultsController:(nullable UIViewController *)searchResultsController;

@property(nonatomic,strong) YBSearchBar * _Nonnull searchBar;

@property (nullable, nonatomic, weak) id <UISearchResultsUpdating> searchResultsUpdater;

@property (nonatomic, assign) BOOL hidesNavigationBarDuringPresentation;

@end
