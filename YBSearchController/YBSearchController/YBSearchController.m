//
//  YBSearchController.m
//  YBSearchController
//
//  Created by Gao on 2017/12/27.
//  Copyright © 2017年 Gao. All rights reserved.
//

#import "YBSearchController.h"
#import "YBSearchBar.h"
#import "searchControllerView.h"

@interface YBSearchController () <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) CGRect searchBarOriginFrame;

@property(nonatomic,weak)   UIView *searchBarSuperView;

@property(nonatomic,assign) BOOL fromTableHeaderView;

@property(nonatomic,assign) BOOL fromTableFooterView;

@property(nonatomic,assign) BOOL shouldShow;

@property(nonatomic,weak) UIViewController *topViewController;

@end

@implementation YBSearchController

-(void)loadView {
    self.view = [[searchControllerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype _Nonnull )initWithSearchResultsController:(nullable UIViewController *)searchResultsController {
    if (self = [super init]) {
        self.searchResultsController = searchResultsController;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
        self.transitioningDelegate  = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ((searchControllerView *)(self.view)).resultView = [self topViewController].view;
    ((searchControllerView *)(self.view)).dimsBackgroundDuringPresentation = self.dimsBackgroundDuringPresentation;
}

-(void)dealloc {
    [self removeObserver];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSValue *value = change[NSKeyValueChangeNewKey];
    CGRect frame = value.CGRectValue;
    CGFloat offsetY = frame.origin.y;
    CGFloat targetY = 0.0;
    // 不隐藏导航栏的情况下
    if (!self.hidesNavigationBarDuringPresentation) {
        if(self.topViewController.navigationController) {
            if(self.fromTableHeaderView) {
                targetY = CGRectGetMaxY(self.topViewController.navigationController.navigationBar.frame);
            } else {
                targetY = self.searchBarOriginFrame.origin.y;
            }
        } else {
            if(self.fromTableHeaderView) {
                targetY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
            } else {
                targetY = self.searchBarOriginFrame.origin.y;
            }
        }
    } else {
        if(self.fromTableHeaderView) {
            targetY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
        } else {
            targetY = self.searchBarOriginFrame.origin.y;
        }
    }
    
    if (self.isActive) {
        if (offsetY != targetY) {
            frame.origin.y = targetY;
            [self.searchBar setFrame:frame];
        }
    }
}

-(YBSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[YBSearchBar alloc] init];
        [self addObserver];
    }
    return _searchBar;
}

#pragma mark - YBSearchBarDelegate

-(void)searchFieldBeginEditing {
    NSLog(@"%s",__func__);
    self.searchBarSuperView = self.searchBar.superview;
    self.searchBarOriginFrame = self.searchBar.frame;
    _active = YES;
    [self show];
}

-(void)searchFieldEndEditing {
    NSLog(@"%s",__func__);
    if ([self.searchBarSuperView respondsToSelector:@selector(reloadData)]) {
        [self.searchBarSuperView performSelector:@selector(reloadData)];
    }
    _active = NO;
    [self dismiss];
}

- (void)searchFieldTextDidChange {
    NSLog(@"%s",__func__);
    if ([self.searchResultsUpdater respondsToSelector:@selector(updateSearchResultsForController:)]) {
        [self.searchResultsUpdater updateSearchResultsForSearchController:(UISearchController *)self];
    }
}

#pragma mark - UIAnimation

-(void)show {
    
    self.shouldShow = YES;
    
    if ([self.searchBarSuperView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.searchBarSuperView;
        if (tableView.tableHeaderView == self.searchBar) {
            self.fromTableHeaderView = YES;
        } else if (tableView.tableFooterView == self.searchBar) {
            self.fromTableFooterView = YES;
        }
    }
    
    if (self.hidesNavigationBarDuringPresentation) {
        [self setNavigationBarHidden:YES];
    }
    
    [self.topViewController presentViewController:self animated:YES completion:nil];
    
    if ([self.searchBarSuperView respondsToSelector:@selector(reloadData)]) {
        [self.searchBarSuperView performSelector:@selector(reloadData)];
    }
    
}

-(void)dismiss {
    self.shouldShow = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showPresentAnimation {
    
    CGFloat offSetY = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (!self.hidesNavigationBarDuringPresentation) {
        if ([self.topViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.topViewController;
            offSetY = CGRectGetMaxY(nav.navigationBar.frame);
        } else {
            offSetY = CGRectGetMaxY(self.topViewController.navigationController.navigationBar.frame);
        }
    }
    
    CGRect frame = self.searchBar.frame;
    frame.origin.y = offSetY;
    self.searchBar.frame = frame;
}

-(void)showDismissAnimation {
    
    if (self.hidesNavigationBarDuringPresentation) {
        [self setNavigationBarHidden:NO];
    }
    
    if ([self.searchBarSuperView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.searchBarSuperView;
        self.searchBar.frame = self.searchBarOriginFrame;
        [tableView addSubview:self.searchBar];
        if (self.fromTableHeaderView) {
            tableView.tableHeaderView = self.searchBar;
            return;
        } else if (self.fromTableFooterView) {
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
        [self.view addSubview:self.searchBar];
    } else {
        [self showDismissAnimation];
        [transitionContext completeTransition:YES];
    }
    
}

#pragma mark - ComponentMethod
- (UIViewController *)topViewController {
    if (!_topViewController) {
        if (self.searchResultsController != nil) {
            _topViewController = self.searchResultsController;
            return _topViewController;
        }
        UIResponder *responder = [self.searchBar nextResponder];
        while (responder != nil) {
            if ([responder isKindOfClass:[UIViewController class]]) {
                _topViewController = (UIViewController *)responder;
                return _topViewController;
            }
            responder = [responder nextResponder];
        }
        return nil;
    }
    return _topViewController;
}

-(void)addObserver {
    UITextField *field = [self.searchBar valueForKeyPath:@"textField"];
    [self.searchBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:field];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldEndEditing) name:UITextFieldTextDidEndEditingNotification object:field];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:field];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldEndEditing) name:@"YBSearchControllerWillDismiss" object:nil];
}

-(void)removeObserver {
    [self.searchBar removeObserver:self forKeyPath:@"frame"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YBSearchControllerWillDismiss" object:nil];
}

-(void)setNavigationBarHidden:(BOOL)hidden {
    if ([self.topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.topViewController;
        [nav setNavigationBarHidden:hidden animated:YES];
    } else {
        [self.topViewController.navigationController setNavigationBarHidden:hidden animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

