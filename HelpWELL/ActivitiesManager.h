//
//  ActivitiesManager.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/26/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitiesManager : NSObject
extern NSString * const ActivityList_StoreKey;
extern NSString * const ActivityLog_StoreKey;
extern NSString * const FavoriteActivityList_StoreKey;

+(NSArray *)AllActivities;
+(NSArray *)CustomActivities;
+(NSArray *)StandardActivities;
+(void)SaveCustomActivity:(NSString *)activityName;

+(NSArray *)ActivityLogForDate:(NSDate *)date;
+(void)LogActivity:(NSString *)activityName onDate:(NSDate *)date;
+(NSArray *)DeleteActivity:(NSString *)activityName fromDate:(NSDate *)date;

+(NSArray *)FavoriteActivities;
+(void)SetFavoriteActivity:(NSString *)activityName atIndex:(NSInteger)index;
+(NSArray *)DeleteFavoriteActivity:(NSString *)activityName;

@end
