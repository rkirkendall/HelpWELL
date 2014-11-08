//
//  ActivitiesManager.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/26/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "ActivitiesManager.h"

@implementation ActivitiesManager
NSString * const ActivityList_StoreKey = @"ActivityList_StoreKey";
NSString * const ActivityLog_StoreKey = @"ActivityLog_StoreKey";
NSString * const FavoriteActivityList_StoreKey = @"FavoriteActivityList_StoreKey";


+(NSArray *)AllActivities{
    NSMutableArray *all = [[NSMutableArray alloc]init];
    [all addObjectsFromArray:[ActivitiesManager StandardActivities]];
    [all addObjectsFromArray:[ActivitiesManager CustomActivities]];
    return all;
}
+(NSArray *)StandardActivities{
    return @[@"Attend a sporting event/concert",
             @"Biking",
             @"Call a friend",
             @"Clean/Organize a room",
             @"Cook/bake",
             @"Create arts or crafts (e.g., draw, knit)",
             @"Dance",
             @"Express gratitude to someone",
             @"Go out to dinner",
             @"Join a club/group",
             @"List 3 things you are thankful for",
             @"Listen to relaxing music",
             @"Go for a run",
             @"Go Climbing",
             @"Meditate",
             @"Perform a random act of kindness",
             @"Play a game/videogame",
             @"Practice deep breathing",
             @"Pray",
             @"Problem solve one dilemma",
             @"Read a book",
             @"Set goals",
             @"Sing",
             @"Spend time outdoors",
             @"Spend time with your pet",
             @"Star gaze",
             @"Surf the web",
             @"Take a drive",
             @"Take a shower/bath",
             @"Take a walk",
             @"Try taking a new route to class",
             @"Volunteer",
             @"Visit a park",
             @"Watch a movie or video",
             @"Work a puzzle",
             @"Write in a journal",
             @"WVU - Watch a free movie at the Gluck Theater",
             @"WVU - See a show at the CAC",
             @"WVU - Work with clay at the WVU Craft Center",
             @"WVU - Run on the Rail Trail",
             @"WVU - Vist the Recreation Center",
             @"WVU - Take a free yoga class",
             @"WVU - Spend time on the Mountainlair Green",
             @"WVU - People watch on High Street or in the Lair",
             @"WVU - Use boating equipment at the Outdoor Rec Center",
             ];
}
+(NSArray *)CustomActivities{
    NSArray *activities = [[NSUserDefaults standardUserDefaults] objectForKey:ActivityList_StoreKey];
    return activities;
}
+(void)SaveCustomActivity:(NSString *)activityName{
    NSArray *customActivities = [[NSUserDefaults standardUserDefaults] objectForKey:ActivityList_StoreKey];
    if(!customActivities){
        customActivities = @[];
    }
    
    NSMutableArray *toPersist = [[NSMutableArray alloc]initWithArray:customActivities];
    
    [toPersist addObject:activityName];
    [[NSUserDefaults standardUserDefaults] setObject:toPersist forKey:ActivityList_StoreKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSArray *)ActivityLogForDate:(NSDate *)date{
    
    NSDictionary *activityLog = [[NSUserDefaults standardUserDefaults]objectForKey:ActivityLog_StoreKey];
    
    if(!activityLog){
        return @[];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateKey = [formatter stringFromDate:date];
    
    NSArray *logForDate = [activityLog objectForKey:dateKey];
    if(!logForDate){
        logForDate =@[];
    }
    
    return logForDate;
    
}
+(void)LogActivity:(NSString *)activityName onDate:(NSDate *)date{
    NSDictionary *activityLog = [[NSUserDefaults standardUserDefaults]objectForKey:ActivityLog_StoreKey];
    if(!activityLog){
        activityLog = @{};
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateKey = [formatter stringFromDate:date];
    
    NSMutableDictionary *toPersist = [[NSMutableDictionary alloc]initWithDictionary:activityLog];
    
    NSArray *logForDate = [toPersist objectForKey:dateKey];
    if(!logForDate){
        logForDate = @[];
    }
    NSMutableArray *savedLog = [[NSMutableArray alloc]initWithArray:logForDate];
    [savedLog addObject:activityName];
    [toPersist setObject:savedLog forKey:dateKey];
    [[NSUserDefaults standardUserDefaults] setObject:toPersist forKey:ActivityLog_StoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSArray *)DeleteActivity:(NSString *)activityName fromDate:(NSDate *)date{
    NSDictionary *activityLog = [[NSUserDefaults standardUserDefaults]objectForKey:ActivityLog_StoreKey];
    if(!activityLog){
        return @[];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateKey = [formatter stringFromDate:date];
    
    NSMutableDictionary *toPersist = [[NSMutableDictionary alloc]initWithDictionary:activityLog];
    
    NSArray *logForDate = [toPersist objectForKey:dateKey];
    if(!logForDate){
        logForDate = @[];
    }
    
    NSMutableArray *savedLog = [[NSMutableArray alloc]initWithArray:logForDate];
    NSLog(@"Before delete: %@",savedLog);
    if ([savedLog containsObject:activityName]) {
        [savedLog removeObject:activityName];
    }
    
    NSLog(@"After delete: %@",savedLog);
    [toPersist setObject:savedLog forKey:dateKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:toPersist forKey:ActivityLog_StoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return savedLog;
}


// Only 5 Favorite activities
+(void)SetFavoriteActivity:(NSString *)activityName atIndex:(NSInteger)index{
    
    if (!activityName) {
        return;
    }
    
    NSMutableArray *favoritesList= [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:FavoriteActivityList_StoreKey]];
    
    if ([favoritesList containsObject:activityName]) {
        return;
    }
    
    if (index >= favoritesList.count) {
        [favoritesList addObject:activityName];
        [[NSUserDefaults standardUserDefaults] setObject:favoritesList forKey:FavoriteActivityList_StoreKey];
        return;
    }
    
    [favoritesList replaceObjectAtIndex:index withObject:activityName];
    [[NSUserDefaults standardUserDefaults] setObject:favoritesList forKey:FavoriteActivityList_StoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray *)FavoriteActivities{
    
    NSArray *toReturn = [[NSUserDefaults standardUserDefaults] objectForKey:FavoriteActivityList_StoreKey];
    if (!toReturn) {
        return @[];
    }
    
    return toReturn;
}
+(NSArray *)DeleteFavoriteActivity:(NSString *)activityName{
    
    NSMutableArray *toReturnAndPersist = [[NSMutableArray alloc]initWithArray: [[NSUserDefaults standardUserDefaults]objectForKey:FavoriteActivityList_StoreKey]];
    NSLog(@"before delete: #%lu",toReturnAndPersist.count);
    if ([toReturnAndPersist containsObject:activityName]) {
        [toReturnAndPersist removeObject:activityName];
    }
    NSLog(@"after delete: #%lu",toReturnAndPersist.count);
    [[NSUserDefaults standardUserDefaults] setObject:toReturnAndPersist forKey:FavoriteActivityList_StoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return toReturnAndPersist;
}


@end
