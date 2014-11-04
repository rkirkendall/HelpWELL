//
//  SupportsManager.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/30/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "SupportsManager.h"

@implementation SupportsManager

NSString * const Support_StoreKey  = @"Support_StoreKey";
NSString * const Support_NameKey  = @"Support_NameKey";
NSString * const Support_NumberKey  = @"Support_NumberKey";

+(NSArray *)AllSupports{
    NSMutableArray *all = [[NSMutableArray alloc]init];
    [all addObjectsFromArray:[SupportsManager CustomSupports]];
    [all addObjectsFromArray:[SupportsManager StandardSupports]];
    return all;
}
+(NSArray *)CustomSupports{
    NSArray *supports = [[NSUserDefaults standardUserDefaults] objectForKey:Support_StoreKey];
    return supports;
}
+(NSArray *)StandardSupports{
    return @[@{Support_NameKey:@"Suicide Prevention Lifeline",
               Support_NumberKey:@"18002738255"}];
}

+(NSArray *)DeleteCustomSupportWithName:(NSString *)name andNumber:(NSString *)number{
    NSArray *savedSupports = [[NSUserDefaults standardUserDefaults]objectForKey:Support_StoreKey];
    if (!savedSupports) {
        return @[];
    }
    
    NSMutableArray *toPersist = [[NSMutableArray alloc]initWithArray:savedSupports];
    
    [toPersist removeObjectAtIndex:[toPersist indexOfObject:@{Support_NameKey:name,Support_NumberKey:number}]];
    
    [[NSUserDefaults standardUserDefaults] setObject:toPersist forKey:Support_StoreKey];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return [SupportsManager AllSupports];
}

+(void)SaveCustomSupportWithName:(NSString *)name andNumber:(NSString *)number{
    
    NSArray *savedSupports = [[NSUserDefaults standardUserDefaults] objectForKey:Support_StoreKey];
    if (!savedSupports) {
        savedSupports = @[];
    }
    
    NSMutableArray *toPersist = [[NSMutableArray alloc]initWithArray:savedSupports];
    
    NSDictionary *saveContact = @{Support_NameKey:name,
                                  Support_NumberKey:number};
    [toPersist addObject:saveContact];
    
    [[NSUserDefaults standardUserDefaults]setObject:toPersist forKey:Support_StoreKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

@end
