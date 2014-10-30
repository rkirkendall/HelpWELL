//
//  SupportsViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/30/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "SupportsViewController.h"
#import "SupportsManager.h"
@interface SupportsViewController ()

@end

@implementation SupportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Supports";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.contacts = [SupportsManager AllSupports];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
}

-(void)manualAddContact{
    NSString *mesage = [NSString stringWithFormat:@"You cad add %d more supports.",6-self.contacts.count];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"New Support"
                                          message: mesage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *nameField = alertController.textFields.firstObject;
                                   UITextField *phoneField = alertController.textFields.lastObject;
                                   
                                   
                               }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Name";
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Phone Number";
         [textField setKeyboardType:UIKeyboardTypePhonePad];
         textField.delegate = self;
     }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)importFromAddressBook{
    
}

-(void)addContact{
    if (self.contacts.count == 6) {
        // No more supports can be added
    }else{
        //Display action sheet
        
        [self manualAddContact];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    // if it's the phone number textfield format it.
    if (range.length == 1) {
        // Delete button was hit.. so tell the method to delete the last char.
        textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
    } else {
        textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO ];
    }
    return NO;
}

- (NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}

-(void)refreshContacts{
    self.contacts = [SupportsManager AllSupports];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.contacts[indexPath.row][Support_NameKey];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *contactToDelete = self.contacts[indexPath.row];
        self.contacts = [SupportsManager DeleteCustomSupportWithName:contactToDelete[Support_NameKey] andNumber:contactToDelete[Support_NumberKey]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==self.contacts.count-1) {
        return  NO;
    }
    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}

@end
