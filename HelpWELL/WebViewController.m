//
//  WebViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/30/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "WebViewController.h"
#import "ResourcesTableViewController.h"
@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.displayItem[Name_Key];
    
    NSString* url = self.displayItem[URL_Key];
    NSURL* nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30];
    
    [self.webView loadRequest:request];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openInSafari)];
}

-(void)openInSafari{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.displayItem[URL_Key]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
