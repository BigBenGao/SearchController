//
//  YBSearchController.m
//  YBSearchController
//
//  Created by Gao on 2017/12/27.
//  Copyright © 2017年 Gao. All rights reserved.
//

#import "YBSearchController.h"
#import "YBSearchBar.h"

@interface YBSearchController () <YBSearchBarDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property(nonatomic,weak) UIViewController *searchResultsController;

//@property(nonatomic,assign) CGRect resultViewControllerOriginFrame;

@property(nonatomic,assign) CGRect searchBarOriginFrame;

@property(nonatomic,weak) UIView *searchBarSuperView;

@property(nonatomic,assign) BOOL fromTableHeaderView;

@property(nonatomic,assign) BOOL fromTableFooterView;

@property(nonatomic,assign) BOOL shouldShow;

@end

@implementation YBSearchController

- (instancetype _Nonnull )initWithSearchResultsController:(nullable UIViewController *)searchResultsController {
    if (self = [super init]) {
        self.hidesNavigationBarDuringPresentation = YES;
        self.searchResultsController = searchResultsController;
//        self.resultViewControllerOriginFrame = self.searchResultsController.view.frame;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
        self.transitioningDelegate  = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

-(YBSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[YBSearchBar alloc] init];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

#pragma mark - YBSearchBarDelegate

-(BOOL)searchFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"%s",__func__);
    self.searchBarSuperView = self.searchBar.superview;
    self.searchBarOriginFrame = self.searchBar.frame;
    [self show];
    return YES;
}

-(BOOL)searchFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"%s",__func__);
    [self dismiss];
    return YES;
}

#pragma mark - UIAnimation

-(void)show {
    
    self.shouldShow = YES;
    
    [self.view addSubview:self.searchBar];
    
    if ([self.searchBarSuperView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.searchBarSuperView;
        if (tableView.tableHeaderView == self.searchBar) {
            self.fromTableHeaderView = YES;
        } else if (tableView.tableFooterView == self.searchBar) {
            self.fromTableFooterView = YES;
        }
    }
    
    if (self.hidesNavigationBarDuringPresentation) {
        [self.searchResultsController.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    [self.searchResultsController presentViewController:self animated:YES completion:nil];
}

-(void)dismiss {
    self.shouldShow = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showPresentAnimation {
    
    CGFloat offSetY = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (!self.hidesNavigationBarDuringPresentation) {
        if (self.searchResultsController.navigationController) {
            offSetY = CGRectGetMaxY(self.searchResultsController.navigationController.navigationBar.frame);
        }
    }
    
    CGRect frame = self.searchBar.frame;
    frame.origin.y = offSetY;
    self.searchBar.frame = frame;
}

-(void)showDismissAnimation {
    
    if (self.hidesNavigationBarDuringPresentation) {
        [self.searchResultsController.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if ([self.searchBarSuperView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.searchBarSuperView;
        if (self.fromTableHeaderView) {
            self.searchBar.frame = self.searchBarOriginFrame;
            [tableView addSubview:self.searchBar];
            tableView.tableHeaderView = self.searchBar;
            return;
        } else if (self.fromTableFooterView) {
            self.searchBar.frame = self.searchBarOriginFrame;
            [tableView addSubview:self.searchBar];
            tableView.tableFooterView = self.searchBar;
            return;
        }
    }
    self.searchBar.frame = self.searchBarOriginFrame;
    [self.searchBarSuperView addSubview:self.searchBar];
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.shouldShow) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [transitionContext.containerView addSubview:toView];
        [self showPresentAnimation];
        [transitionContext completeTransition:YES];
    } else {
        [self showDismissAnimation];
        [transitionContext completeTransition:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
