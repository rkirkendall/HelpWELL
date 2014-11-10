//
//  TriggerManager.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/9/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TriggerManager : NSObject
extern NSString * const TM_Title;
extern NSString * const TM_Body;


+(NSDictionary *)OpenedDashboard;
+(NSDictionary *)OpenedResources;

+(NSDictionary *)LoggedActivity;
+(NSDictionary *)AddedActivity;

+(NSDictionary *)LoggedMood;

+(NSDictionary *)ContactedSupport;
+(NSDictionary *)AddedSupport;

+(NSArray *)Achievements;

@end
