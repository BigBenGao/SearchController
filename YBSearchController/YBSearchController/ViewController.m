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
    
    YBSearchController *searchController = [[YBSearchController alloc] initWithSearchResultsController:self];
    self.searchController = searchController;
    self.tableView.tableHeaderView = searchController.searchBar;
        
//    self.searchVc = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchVc.searchBar.delegate = self;
//    self.searchVc.hidesNavigationBarDuringPresentation = NO;
//    self.searchVc.searchResultsUpdater = self;
//    self.searchVc.delegate = self;
//    self.tableView.tableHeaderView = self.searchVc.searchBar;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"text = %@",searchText);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"text = %@",searchController.searchBar.text);
}

-(void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"ASD");
}
@end
