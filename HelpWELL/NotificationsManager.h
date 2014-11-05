//
//  NotificationsManager.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/4/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationsManager : NSObject
+(void)ScheduleMoodNotificationForDate:(NSDate *)date;

+(void)ScheduleActivityNotifcationForDate:(NSDate *)date;

+(void)DisableMoodNotifications;
+(void)DisableActivityNotifications;

@end
