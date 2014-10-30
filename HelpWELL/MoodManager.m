//
//  MoodManager.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/22/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "MoodManager.h"

@implementation MoodManager
NSString * const MM_MoodKey = @"MM_MoodKey";
NSString * const MM_AnxietyKey = @"MM_AnxietyKey";
NSString * const MM_SleepKey = @"MM_SleepKey";
NSString * const MM_DateKey = @"MM_DateKey";

NSString * const MM_StoreKey = @"MM_StoreKey";


-(void)SaveMood:(NSNumber *)mood anxiety:(NSNumber *)anxiety sleep:(NSNumber *)sleep forDate:(NSDate *)date{
    NSMutableDictionary *saveObj = [[NSMutableDictionary alloc]init];
    [saveObj setObject:mood forKey:MM_MoodKey];
    [saveObj setObject:anxiety forKey:MM_AnxietyKey];
    [saveObj setObject:sleep forKey:MM_SleepKey];
    [saveObj setObject:date forKey:MM_DateKey];
    
    //Get current moods array
    NSArray *moodArray = [[NSUserDefaults standardUserDefaults]objectForKey:MM_StoreKey];
    if(!moodArray){
        moodArray =@[];
    }
    NSMutableArray *toPersist = [[NSMutableArray alloc]initWithArray:moodArray];
    [toPersist addObject:saveObj];
    
    [[NSUserDefaults standardUserDefaults] setObject:toPersist forKey:MM_StoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray *)GetRecentMoods{
    NSArray *moods = [[NSUserDefaults standardUserDefaults]objectForKey:MM_StoreKey];
    return moods;
}

@end
