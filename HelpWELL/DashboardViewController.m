//
//  ViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/13/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "DashboardViewController.h"
#import "WebViewController.h"
@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:2.0f]];
    [[BButton appearance] setStyle:BButtonStyleBootstrapV3];
    [[BButton appearance] setTitleColor:[UIColor colorWithRed:0 green:0.267 blue:0.486 alpha:1] forState:UIControlStateNormal];
    
    [self.rateYourDayButton setType:BButtonTypeSuccess];
    
    [self.needHelp setType:BButtonTypeDanger];
}

-(void)viewDidAppear:(BOOL)animated{
    self.title = @"Dashboard";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)needHelpNowTapped:(id)sender {
    UIActionSheet *contactAddActions = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Suicide Prevention Lifeline", @"SAMHSA Behavioral Health Services Locator", nil];
    [contactAddActions setTag:1];
    [contactAddActions showInView:self.view];

}


- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"Call..");
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"18002738255"]]];
        
    }else if(buttonIndex == 1){
        NSLog(@"Finder");
        NSDictionary *samhsa = @{@"name_key":@"SAMHSA Behavioral Health Services Locator",
                                 @"description_key":@"",
                                 @"url_key":@"http://findtreatment.samhsa.gov/locator"};
        
        
        UIStoryboard *storyboard = self.storyboard;
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        WebViewController *webController =  (WebViewController *)vc;
        webController.displayItem = samhsa;
        
        [self.navigationController pushViewController:webController animated:YES];
    }
    
}

@end
