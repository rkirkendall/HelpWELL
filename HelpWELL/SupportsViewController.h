//
//  SupportsViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/30/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
@interface SupportsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *supports;
@property(nonatomic, strong)NSString *pickedSupport;
-(void)dismissSupportsPicker;
@property (weak, nonatomic) IBOutlet BButton *helpButton;
- (IBAction)helpButtonTapped:(id)sender;

@end
