//
//  NotificationsManager.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/4/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "NotificationsManager.h"
#import "SettingsManager.h"
#import <UIKit/UIKit.h> 

@implementation NotificationsManager

//after @implementation
NSString * const NM_MoodKey = @"NM_MoodKey";
NSString * const NM_ActivityKey = @"NM_ActivityKey";

//after @implementation
NSString * const NM_Alert_Mood  = @"How's your mood? Rate your day with HelpWELL";
NSString * const NM_Alert_Activity  = @"Check out activites around you with HelpWELL";

+(void)ScheduleMoodNotificationForDate:(NSDate *)date{
    
    // Clear existing notifications
    [NotificationsManager DisableMoodNotifications];
    
    // Create new notification
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;//[NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.repeatInterval = kCFCalendarUnitDay;
    localNotification.alertBody = NM_Alert_Mood;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.category = NM_MoodKey;
    localNotification.applicationIconBadgeNumber = 1;
    
    // Schedule it
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+(void)ScheduleActivityNotifcationForDate:(NSDate *)date{
    // Clear existing activity notifications
    [NotificationsManager DisableActivityNotifications];
    
    // Create new notification
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.repeatInterval = kCFCalendarUnitDay;
    localNotification.alertBody = NM_Alert_Activity;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.category = NM_ActivityKey;
    localNotification.applicationIconBadgeNumber = 1;
    
    // Schedule it
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+(void)DisableMoodNotifications{
    // Find existing notification
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notif in notifs) {
        if ([notif.alertBody isEqualToString:NM_Alert_Mood]) {
            NSLog(@"cancelling mood notif");
            [[UIApplication sharedApplication]cancelLocalNotification:notif];
        }
    }
}
+(void)DisableActivityNotifications{
    // Find existing notification
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notif in notifs) {
        if ([notif.alertBody isEqualToString:NM_Alert_Activity]) {
            NSLog(@"cancelling activity notif");
            [[UIApplication sharedApplication]cancelLocalNotification:notif];
        }
    }
}

@end
