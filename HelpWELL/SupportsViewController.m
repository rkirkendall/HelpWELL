//
//  SupportsViewController.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/30/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "SupportsViewController.h"
#import "SupportsManager.h"
#import "APContact.h"
#import "APAddressBook.h"
#import "AddressBookPickerViewController.h"
#import "WebViewController.h"
#import "TriggerManager.h"
#define Contact_MAX 4

// Return nil when __INDEX__ is beyond the bounds of the array
#define NSArrayObjectMaybeNil(__ARRAY__, __INDEX__) ((__INDEX__ >= [__ARRAY__ count]) ? nil : [__ARRAY__ objectAtIndex:__INDEX__])

// Manually expand an array into an argument list
#define NSArrayToVariableArgumentsList(__ARRAYNAME__)\
NSArrayObjectMaybeNil(__ARRAYNAME__, 0),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 1),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 2),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 3),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 4),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 5),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 6),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 7),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 8),\
NSArrayObjectMaybeNil(__ARRAYNAME__, 9),\
nil

@interface SupportsViewController ()
@property(nonatomic, strong)NSMutableDictionary *contactsNumbers;
@property(nonatomic, strong)NSArray *selectedContactNumbers;
@property(nonatomic, strong)NSString *numberToCall;
@end

@implementation SupportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Supports";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.supports = [SupportsManager AllSupports];
    
    [self.helpButton setType:BButtonTypeDanger];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
}

-(void)dismissSupportsPicker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.pickedSupport) {
        // Determine if the support has multiple numbers
        if (self.selectedContactNumbers) {
            self.selectedContactNumbers = nil;
        }
        
        self.selectedContactNumbers = [self.contactsNumbers objectForKey:self.pickedSupport];
        
        if (self.selectedContactNumbers.count >1) {
            UIActionSheet *numberPicker = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:(NSString *)NSArrayToVariableArgumentsList(self.selectedContactNumbers), nil];
            
            //
            [numberPicker setTag:2];
            [numberPicker showInView:self.view];
        }
        else{
            [SupportsManager SaveCustomSupportWithName:self.pickedSupport andNumber:self.selectedContactNumbers[0]];
            [self checkAlertAddSupport];
            [self refreshContacts];
        }
    }
}

-(void)manualAddContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"New Support"
                                          message: nil
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
                                   
                                   NSString *selectedContactNumber = phoneField.text;
                                   NSString *selectedContactName = nameField.text;
                                   
                                   //Save contact
                                   [SupportsManager SaveCustomSupportWithName:selectedContactName andNumber:selectedContactNumber];
                                   [self refreshContacts];
                                   
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
    
    
    // If access is restricted, alert the user they will need to change the privacy settings
    if ([APAddressBook access] == APAddressBookAccessDenied) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Privacy Settings"
                                              message: @"Please enable the HelpWELL Contacts access in iOS Settings."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Do that"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Later"
                                   style:UIAlertActionStyleDefault
                                       handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        APAddressBook *addressBook = [[APAddressBook alloc] init];
        addressBook.fieldsMask = APContactFieldFirstName | APContactFieldLastName | APContactFieldPhones;
        addressBook.sortDescriptors = @[
                                        [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                        [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
                                        ];
        addressBook.filterBlock = ^BOOL(APContact *contact)
        {
            return contact.phones.count > 0;
        };
        // don't forget to show some activity
        [addressBook loadContacts:^(NSArray *contacts, NSError *error)
         {
             // hide activity
             if (!error)
             {
                 self.contactsNumbers = [[NSMutableDictionary alloc]init];
                 for (APContact *contact in contacts) {
                     NSString *name = @"";
                     if (contact.firstName) {
                         name = [name stringByAppendingString:contact.firstName];
                     }
                     if (contact.lastName) {
                         name =[name stringByAppendingString:@" "];
                         name =[name stringByAppendingString:contact.lastName];
                     }
                     NSArray *numbers = contact.phones;
                     if ([[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] >0){
                         [self.contactsNumbers setObject:numbers forKey:name];
                     }
                 }
                 NSArray *singleListNames = [self.contactsNumbers allKeys];
                 NSArray *sortedArray = [singleListNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                 
                 AddressBookPickerViewController *picker = [[AddressBookPickerViewController alloc] init];
                 [picker setTableData:sortedArray];
                 [picker setParentVC:self];
                 self.pickedSupport = nil;
                 UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:picker];
                 [self presentViewController:nav animated:YES completion:nil];
             }
         }];
    }
    
}

-(void)checkAlertCallSupport{
    NSDictionary *alert = [TriggerManager ContactedSupport];
    if (alert) {
        NSString *title = alert[TM_Title];
        NSString *body = alert[TM_Body];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:body delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)checkAlertAddSupport{
    NSDictionary *alert = [TriggerManager AddedSupport];
    if (alert) {
        NSString *title = alert[TM_Title];
        NSString *body = alert[TM_Body];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:body delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)addContact{
    if (self.supports.count == Contact_MAX) {
        // No more supports can be added
        UIAlertView *noMoreSupports = [[UIAlertView alloc]initWithTitle:@"Maximum supports reached" message:@"Please swipe to delete supports you wish to replace" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noMoreSupports show];
    }else{
        //Display action sheet
        NSString *message = [NSString stringWithFormat:@"You can add %lu more supports",Contact_MAX - self.supports.count];
        UIActionSheet *contactAddActions = [[UIActionSheet alloc]initWithTitle:message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Import from Contacts", @"Add...", nil];
        [contactAddActions setTag:1];
        [contactAddActions showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self importFromAddressBook];
        }else if (buttonIndex == 1){
            [self performSelector:@selector(manualAddContact) withObject:nil afterDelay:0.3];
        }
    }
    else if(actionSheet.tag == 2){
        NSString *selectedContactNumber = self.selectedContactNumbers[buttonIndex];
        NSString *selectedContactName = self.pickedSupport;
        
        //Save contact
        [SupportsManager SaveCustomSupportWithName:selectedContactName andNumber:selectedContactNumber];
        [self checkAlertAddSupport];
        [self refreshContacts];
    }else if(actionSheet.tag == 3){
        if (buttonIndex==0) {
            NSString *callFormat = [self.numberToCall stringByReplacingOccurrencesOfString:@"(" withString:@""];
            callFormat = [self.numberToCall stringByReplacingOccurrencesOfString:@")" withString:@""];
            callFormat = [self.numberToCall stringByReplacingOccurrencesOfString:@"-" withString:@""];
            callFormat = [self.numberToCall stringByReplacingOccurrencesOfString:@"+" withString:@""];
            callFormat = [self.numberToCall stringByReplacingOccurrencesOfString:@" " withString:@""];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", callFormat]]];
            [self checkAlertCallSupport];
        }
    }else if(actionSheet.tag == 4){
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
    self.supports = [SupportsManager AllSupports];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    NSString *cellString = [NSString stringWithFormat:@"%@",self.supports[indexPath.row][Support_NameKey]];
    cell.textLabel.text = cellString;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *contactToDelete = self.supports[indexPath.row];
        self.supports = [SupportsManager DeleteCustomSupportWithName:contactToDelete[Support_NameKey] andNumber:contactToDelete[Support_NumberKey]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==self.supports.count-1) {
        return  NO;
    }
    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.supports.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *contactDict = self.supports[indexPath.row];
    if (self.numberToCall) {
        self.numberToCall = nil;
    }
    self.numberToCall = contactDict[Support_NumberKey];
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *prompt = [NSString stringWithFormat:@"Call %@",self.numberToCall];
        UIActionSheet *callPrompt = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:prompt, nil];
        callPrompt.tag = 3;
        [callPrompt showInView:self.view];
        
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

- (IBAction)helpButtonTapped:(id)sender {
    
    UIActionSheet *contactAddActions = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call Suicide Prevention Lifeline", @"SAMHSA Behavioral Health Services Locator", nil];
    [contactAddActions setTag:4];
    [contactAddActions showInView:self.view];
    
}



@end
