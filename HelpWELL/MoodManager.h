//
//  MoodManager.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/22/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoodManager : NSObject
extern NSString * const MM_StoreKey;
extern NSString * const MM_MoodKey;
extern NSString * const MM_AnxietyKey;
extern NSString * const MM_SleepKey;
extern NSString * const MM_DateKey;

-(void)SaveMood:(NSNumber *)mood anxiety:(NSNumber *)anxiety sleep:(NSNumber *)sleep forDate:(NSDate *)date;
-(NSArray *)GetRecentMoods;

@end