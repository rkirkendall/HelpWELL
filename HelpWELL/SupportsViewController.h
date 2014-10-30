//
//  SupportsViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/30/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupportsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;

@end
