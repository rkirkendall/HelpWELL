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
NSString * const MM_DescriptionKey = @"MM_DescriptionKey";


+(void)SaveMood:(NSNumber *)mood anxiety:(NSNumber *)anxiety sleep:(NSNumber *)sleep withDescription:(NSString *)desc forDate:(NSDate *)date{
    
    NSDictionary *moodLog = [[NSUserDefaults standardUserDefaults]objectForKey:MM_StoreKey];
    if(!moodLog){
        moodLog = @{};
    }
    
    NSDateFormatter *formatter = [MoodManager formatter];
    NSString *dateKey = [formatter stringFromDate:date];
    
    NSMutableDictionary *toPersist = [[NSMutableDictionary alloc]initWithDictionary:moodLog];
    
    NSMutableDictionary *saveObj = [[NSMutableDictionary alloc]init];
    [saveObj setObject:mood forKey:MM_MoodKey];
    [saveObj setObject:anxiety forKey:MM_AnxietyKey];
    [saveObj setObject:sleep forKey:MM_SleepKey];
    [saveObj setObject:date forKey:MM_DateKey];
    [saveObj setObject:desc forKey:MM_DescriptionKey];
    
    [toPersist setObject:saveObj forKey:dateKey];
    [[NSUserDefaults standardUserDefaults] setObject:toPersist forKey:MM_StoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSDictionary *)GetRecentMoods{
    NSDictionary *moodLog = [[NSUserDefaults standardUserDefaults]objectForKey:MM_StoreKey];
    return moodLog;
}

+(NSDateFormatter *)formatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    return formatter;
}

+(NSDictionary *)MoodDataForDate:(NSDate *)date{
    NSDictionary *moodLog = [[NSUserDefaults standardUserDefaults]objectForKey:MM_StoreKey];
    
    NSDateFormatter *formatter = [MoodManager formatter];
    NSString *dateKey = [formatter stringFromDate:date];
    if (moodLog[dateKey]) {
        return moodLog[dateKey];
    }else{
        return nil;
    }    
}

@end
