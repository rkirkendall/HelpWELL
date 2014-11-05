//
//  ViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/13/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:2.0f]];
    [[BButton appearance] setStyle:BButtonStyleBootstrapV3];
    [[BButton appearance] setTitleColor:[UIColor colorWithRed:0 green:0.267 blue:0.486 alpha:1] forState:UIControlStateNormal];
    
    [self.needHelp setType:BButtonTypeDanger];
}

-(void)viewDidAppear:(BOOL)animated{
    self.title = @"Dashboard";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
