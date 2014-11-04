//
//  SettingsManager.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/4/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

NSString * const SM_MoodRemindersEnabled_Key  = @"SM_MoodRemindersEnabled_Key";
NSString * const SM_ActivityRemindersEnabled_Key  = @"SM_ActivityRemindersEnabled_Key";
NSString * const SM_MoodRemindersTime_Key  = @"SM_MoodRemindersTime_Key";
NSString * const SM_ActivityRemindersTime_Key  = @"SM_ActivityRemindersTime_Key";


+(void)EnableDailyMoodReminders:(BOOL)enable{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:enable] forKey:SM_MoodRemindersEnabled_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)EnableDailyActivityReminders:(BOOL)enable{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:enable] forKey:SM_ActivityRemindersEnabled_Key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)DailyMoodRemindersEnabled{
    NSNumber *n = [[NSUserDefaults standardUserDefaults]objectForKey:SM_MoodRemindersEnabled_Key];
    NSLog(@"mood reminders value: %@",n);
    if ([n isEqualToValue:@0]) {
        NSLog(@"returning no");
        return NO;
    }else{
        NSLog(@"returning yes");
        return YES;
    }
}
+(BOOL)DailyActivityRemindersEnabled{
    NSNumber *n = [[NSUserDefaults standardUserDefaults]objectForKey:SM_ActivityRemindersEnabled_Key];
    NSLog(@"activities reminders value: %@",n);
    if ([n isEqualToValue:@0]) {
        NSLog(@"returning no");
        return NO;
    }else{
        NSLog(@"returning yes");
        return YES;
    }
}

// Pass in a date object. We'll only use the time component.
+(void)SetMoodReminderTime:(NSDate *)time{
    
    NSDateFormatter *timeFormat = [SettingsManager TimeFormatter];
    NSString *toSave = [timeFormat stringFromDate:time];
    [[NSUserDefaults standardUserDefaults] setObject:toSave forKey:SM_MoodRemindersTime_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)SetActivityReminderTime:(NSDate *)time{
    
    NSDateFormatter *timeFormat = [SettingsManager TimeFormatter];
    NSString *toSave = [timeFormat stringFromDate:time];
    [[NSUserDefaults standardUserDefaults] setObject:toSave forKey:SM_ActivityRemindersTime_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate *)MoodReminderTime{
    
    NSDateFormatter *timeFormat = [SettingsManager TimeFormatter];
    NSString *saved = [[NSUserDefaults standardUserDefaults]objectForKey:SM_MoodRemindersTime_Key];
    return [timeFormat dateFromString:saved];
}
+(NSDate *)ActivityReminderTime{
    
    NSDateFormatter *timeFormat = [SettingsManager TimeFormatter];
    NSString *saved = [[NSUserDefaults standardUserDefaults]objectForKey:SM_ActivityRemindersTime_Key];
    return [timeFormat dateFromString:saved];
}

+(NSDateFormatter *)TimeFormatter{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    return timeFormat;
}

@end
