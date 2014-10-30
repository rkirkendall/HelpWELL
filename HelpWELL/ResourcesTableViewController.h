//
//  ResourcesTableViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/29/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourcesTableViewController : UITableViewController
extern NSString * const URL_Key;
extern NSString * const Description_Key;
extern NSString * const Name_Key;
@property(nonatomic, strong)NSArray *resources;
@property(nonatomic, strong)NSDictionary *selectedResource;
@end
