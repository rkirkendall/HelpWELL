//
//  JournalViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/9/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardViewController.h"
@interface JournalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) DashboardViewController *parentVC;
@property (nonatomic, strong) NSString *initialText;
@end
