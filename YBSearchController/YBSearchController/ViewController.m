//
//  ViewController.m
//  YBSearchController
//
//  Created by Gao on 2017/12/27.
//  Copyright © 2017年 Gao. All rights reserved.
//

#import "ViewController.h"
#import "YBSearchController.h"
#import "YBSearchBar.h"
#import "CustomTableViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

@property(nonatomic,strong) YBSearchBar *bar;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) YBSearchController *searchController;

@property(nonatomic,strong) UISearchController *searchVc;

@end

static NSString *cellIdentifity = @"reuseCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifity];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    YBSearchController *searchController = [[YBSearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.hidesNavigationBarDuringPresentation = YES;
    searchController.searchBar.delegate = self;
    searchController.dimsBackgroundDuringPresentation = YES;
    searchController.searchBar.showsCancelButton = YES;
    self.searchController = searchController;
    self.tableView.tableHeaderView = searchController.searchBar;
    
//    CustomTableViewController *vc = [[CustomTableViewController alloc] init];
//    self.searchVc = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchVc.searchBar.delegate = self;
//    self.searchVc.hidesNavigationBarDuringPresentation = YES;
//    self.searchVc.dimsBackgroundDuringPresentation = NO;
//    self.searchVc.searchResultsUpdater = self;
//    self.searchVc.delegate = self;
//    self.tableView.tableHeaderView = self.searchVc.searchBar;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
    if (!self.searchVc.isActive) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"activite = %@",self.searchVc.searchBar.text];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange = %@",searchText);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"updateSearchResultsForSearchController = %@",searchController.searchBar.text);
    [self.tableView reloadData];
}

- (void)updateSearchResultsForController:(UISearchController *)searchController {
    NSLog(@"updateSearchResultsForController text = %@",searchController.searchBar.text);
    [self.tableView reloadData];
}

-(void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"ASD");
}

@end
