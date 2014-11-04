//
//  AddressBookPickerViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/2/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "AddressBookPickerViewController.h"

@interface AddressBookPickerViewController ()

@end

@implementation AddressBookPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Support";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parentVC action:@selector(dismissSupportsPicker)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view = self.tableView;
    
    
    // Searh Bar stuff
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        return [self.searchResults count];
    } else {
        return [self.tableData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *cellData;
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        cellData = [self.searchResults objectAtIndex:indexPath.row];
        
    } else {
        cellData = [self.tableData objectAtIndex:indexPath.row];
    }
    
    // Configure the cell
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = cellData;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        self.parentVC.pickedSupport = self.searchResults[indexPath.row];
    }
    else{
        self.parentVC.pickedSupport = self.tableData[indexPath.row];
    }
    [self.parentVC dismissSupportsPicker];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
    
    [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
}


#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)supportName {
    
    // Update the filtered array based on the search text.
    if ((supportName == nil) || [supportName length] == 0) {
        // If there is no search string and the scope is "All".
        self.searchResults = [self.tableData mutableCopy];
        return;
    }
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    for (NSString *support in self.tableData) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange supportNameRange = NSMakeRange(0, support.length);
        NSRange foundRange = [support rangeOfString:supportName options:searchOptions range:supportNameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:support];
        }
    }
}



@end
