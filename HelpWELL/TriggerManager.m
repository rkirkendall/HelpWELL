//
//  TriggerManager.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/9/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "TriggerManager.h"

@implementation TriggerManager
//after @implementation
NSString * const TM_Title  = @"TM_Title";
NSString * const TM_Body  = @"TM_Body";

NSString * const TM_DashboardKey  = @"TM_DashboardKey";
NSString * const TM_ResourcesKey  = @"TM_ResourcesKey";
NSString * const TM_LoggedActivityKey  = @"TM_LoggedActivityKey";
NSString * const TM_AddedActivityKey  = @"TM_AddedActivityKey";
NSString * const TM_LoggedMoodKey  = @"TM_LoggedMoodKey";
NSString * const TM_ContactedSupportKey  = @"TM_ContactedSupportKey";
NSString * const TM_AddedSupportKey  = @"TM_AddedSupportKey";

NSString * const TM_AchievementKey  = @"TM_AchievementKey";

+(NSDictionary *)OpenedResources{
    NSNumber *count= [[NSUserDefaults standardUserDefaults] objectForKey:TM_ResourcesKey];
    
    if (!count) {
        count = @1;
    }else{
        count =[NSNumber numberWithInteger: (count.integerValue +1)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:count forKey:TM_ResourcesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (count.integerValue == 1) {
        NSDictionary *toReturn = @{TM_Title:@"Resources",TM_Body:@"The HelpWELL app provides resources to help develop helpful self-care habits and get in touch with supports when in need."};
        return toReturn;
    }
    
    return nil;
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

+(NSDictionary *)OpenedDashboard{
    NSNumber *count= [[NSUserDefaults standardUserDefaults] objectForKey:TM_DashboardKey];
    
    if (!count) {
        count = @1;
    }else{
        count =[NSNumber numberWithInteger: (count.integerValue +1)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:count forKey:TM_DashboardKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (count.integerValue == 1) {
        NSDictionary *toReturn = @{TM_Title:@"Welcome",TM_Body:@"Let's get started! The HelpWELL app helps you track wellness information. Tap \"Rate My Mood\" to get started."};
        return toReturn;
    }
    
    return nil;
}

+(NSDictionary *)LoggedActivity{
    NSNumber *count= [[NSUserDefaults standardUserDefaults] objectForKey:TM_LoggedActivityKey];
    
    if (!count) {
        count = @1;
    }else{
        count =[NSNumber numberWithInteger: (count.integerValue +1)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:count forKey:TM_LoggedActivityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (count.integerValue == 1) {
        NSDictionary *toReturn  = [TriggerManager SaveAchievementWithName:@"Taking good care of youself" andDescription:@"First time tracking an activity"];
        return toReturn;
    }else if(count.integerValue == 20){
        NSDictionary *toReturn  = [TriggerManager SaveAchievementWithName:@"Maintaining your WELLness" andDescription:@"Track 20 activities"];
        return toReturn;
    }else if(count.integerValue == 100){
        NSDictionary *toReturn  = [TriggerManager SaveAchievementWithName:@"Dedicated to your WELLbeing" andDescription:@"Track 100 activities"];
        return toReturn;
    }else{
        NSInteger randomNumber = (NSInteger)1 + arc4random() % (5);
        if (randomNumber == 5) {
            NSArray *messages = @[@"Good job!",@"Way to take care of yourself", @"Awesome work!", @"Keep up the good work!",@"Fantastic!",@"Excellent Work!",@"Keep it up!"];
            NSInteger randomIndex = arc4random() % (messages.count);
            if (randomIndex>-1 && randomIndex < messages.count) {
                return @{TM_Title:messages[randomIndex],TM_Body:@""};
            }
        }
    }
    
    
    return nil;
}

+(NSDictionary *)AddedActivity{
    NSNumber *count= [[NSUserDefaults standardUserDefaults] objectForKey:TM_AddedActivityKey];
    
    if (!count) {
        count = @1;
    }else{
        count =[NSNumber numberWithInteger: (count.integerValue +1)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:count forKey:TM_AddedActivityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (count.integerValue == 1) {
        NSDictionary * toReturn = [TriggerManager SaveAchievementWithName:@"\"The journey of 1000 miles...\"" andDescription:@"Enter your first self-care activity"];
        return toReturn;
    }else if(count.integerValue == 5){
        NSDictionary *toReturn = [TriggerManager SaveAchievementWithName:@"Self-Care Star" andDescription:@"Create a list of 5 self-care activities"];
        return toReturn;
    }

    return nil;
}

+(NSDictionary *)LoggedMood{
    NSNumber *count= [[NSUserDefaults standardUserDefaults] objectForKey:TM_LoggedMoodKey];
    
    if (!count) {
        count = @1;
    }else{
        count =[NSNumber numberWithInteger: (count.integerValue +1)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:count forKey:TM_LoggedMoodKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (count.integerValue == 1) {
        
        [TriggerManager SaveAchievementWithName:@"Know Thyself" andDescription:@"First mood log!"];
        NSDictionary *toReturn = @{TM_Title:@"Great Work!",TM_Body:@"Great Work! Use the HelpWELL app to track this information every day. Over time, the HelpWELL monitor will graph your wellness information here. \n\nTap Settings to set a daily reminder to enter this information."};
        return toReturn;
    }
    else if(count.integerValue == 7){
        NSDictionary *toReturn = [TriggerManager SaveAchievementWithName:@"On the Road to WELLness" andDescription:@"Log your mood 7 times"];
        return toReturn;
    }
    else if(count.integerValue == 30){
        NSDictionary *toReturn = [TriggerManager SaveAchievementWithName:@"Really Getting to Know Thyself" andDescription:@"Log your mood 30 times"];
        return toReturn;
    }else{
        NSInteger randomNumber = (NSInteger)1 + arc4random() % (7);
        if (randomNumber == 7) {
            NSArray *messages = @[@"Good job!",@"Way to take care of yourself", @"Awesome work!", @"Keep up the good work!",@"Fantastic!",@"Excellent Work!",@"Keep it up!"];
            NSInteger randomIndex = arc4random() % (messages.count);
            if (randomIndex>-1 && randomIndex < messages.count) {
                return @{TM_Title:messages[randomIndex],TM_Body:@""};
            }
        }
    }
    return nil;
}

+(NSDictionary *)ContactedSupport{
    NSNumber *count= [[NSUserDefaults standardUserDefaults] objectForKey:TM_ContactedSupportKey];
    
    if (!count) {
        count = @1;
    }else{
        count =[NSNumber numberWithInteger: (count.integerValue +1)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:count forKey:TM_ContactedSupportKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (count.integerValue == 1) {
        NSDictionary *toReturn = [TriggerManager SaveAchievementWithName:@"No person is an island" andDescription:@"Contact a support"];
        return toReturn;
    }
    
    
    return nil;
}

+(NSDictionary *)AddedSupport{
    NSNumber *count= [[NSUserDefaults standardUserDefaults] objectForKey:TM_AddedSupportKey];
    
    if (!count) {
        count = @1;
    }else{
        count =[NSNumber numberWithInteger: (count.integerValue +1)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:count forKey:TM_AddedSupportKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (count.integerValue == 3) {
        NSDictionary *toReturn = [TriggerManager SaveAchievementWithName:@"WELL-Connected" andDescription:@"Add 3 supports"];
        return toReturn;
    }
    
    
    return nil;
}

+(NSDictionary *)SaveAchievementWithName:(NSString *)name andDescription:(NSString *)description{
    NSArray *achievs = [[NSUserDefaults standardUserDefaults] objectForKey:TM_AchievementKey];
    if (!achievs) {
        achievs = @[];
    }
    NSMutableArray *toSave = [[NSMutableArray alloc]initWithArray:achievs];
    NSDictionary *toReturn = @{TM_Title:name, TM_Body:description};
    [toSave addObject:toReturn];
    [[NSUserDefaults standardUserDefaults] setObject:toSave forKey:TM_AchievementKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return toReturn;
}

+(NSArray *)Achievements{
    NSArray *achievs = [[NSUserDefaults standardUserDefaults] objectForKey:TM_AchievementKey];
    if (!achievs) {
        achievs = @[];
    }
    return achievs;
}


@end
