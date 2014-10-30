//
//  ActivitiesViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/26/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)NSString *pickedActivity;
@property(nonatomic, strong)NSDate *currentDate;
@property(nonatomic, strong)NSArray *activities;
@property (weak, nonatomic) IBOutlet UILabel *activityDateLabel;
- (IBAction)back:(id)sender;
- (IBAction)forward:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)dismissActivityPicker;
@end
