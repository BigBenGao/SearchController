//
//  CustomTableViewController.m
//  YBSearchController
//
//  Created by Gao on 2018/2/8.
//  Copyright © 2018年 Gao. All rights reserved.
//

#import "CustomTableViewController.h"

@interface CustomTableViewController () <UISearchResultsUpdating>

@property(nonatomic,copy) NSString *keyWord;

@end

@implementation CustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    if (self.keyWord.integerValue == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyWord = searchController.searchBar.text;
    self.keyWord = keyWord;
    [self.tableView reloadData];
}

@end
