//
//  ActivitiesPickerTableViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/26/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivitiesViewController.h"

@interface ActivitiesPickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UISearchResultsUpdating>
@property(nonatomic, weak)ActivitiesViewController *parentVC;
@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchController *searchController;
@end
