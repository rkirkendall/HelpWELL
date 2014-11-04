//
//  SettingsManager.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/4/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject
extern NSString * const SM_MoodRemindersEnabled_Key;
extern NSString * const SM_ActivityRemindersEnabled_Key;

extern NSString * const SM_MoodRemindersTime_Key;
extern NSString * const SM_ActivityRemindersTime_Key;

+(void)EnableDailyMoodReminders:(BOOL)enable;
+(void)EnableDailyActivityReminders:(BOOL)enable;

+(BOOL)DailyMoodRemindersEnabled;
+(BOOL)DailyActivityRemindersEnabled;

// Pass in a date object. We'll only use the time component.
+(void)SetMoodReminderTime:(NSDate *)time;
+(void)SetActivityReminderTime:(NSDate *)time;

+(NSDate *)MoodReminderTime;
+(NSDate *)ActivityReminderTime;

+(NSDateFormatter *)TimeFormatter;

@end
