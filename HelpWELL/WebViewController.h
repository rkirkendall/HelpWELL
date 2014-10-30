//
//  WebViewController.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/30/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic, strong)NSDictionary *displayItem;
@end
