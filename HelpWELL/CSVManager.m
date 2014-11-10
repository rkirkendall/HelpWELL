//
//  CSVManager.m
//  HelpWELL
//
//  Created by Ricky Kirkendall on 11/10/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import "CSVManager.h"
#import "MoodManager.h"
#import "ActivitiesManager.h"
@implementation CSVManager
+(NSString *)ExportAsCSV{
    NSDictionary *moodDict = [MoodManager GetMoods];
    NSDictionary *activityDict = [ActivitiesManager ActivityLogs];
    
    NSMutableSet *Mset = [[NSMutableSet alloc]initWithArray:[moodDict allKeys]];
    NSMutableSet *Aset = [[NSMutableSet alloc]initWithArray:[activityDict allKeys]];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
    NSArray *sortedArrayA = [Aset sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSArray *sortedArrayM = [Mset sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    NSMutableString *toReturn = [[NSMutableString alloc]init];
    [toReturn appendString:@"Mood and activity data\n\n"];
    
    [toReturn appendString:@"Mood Data:\n"];
    [toReturn appendString:@"Date, Mood(0-24), Anxiety(0-24), Hours of Sleep(0-24)\n"];
    for (NSString *key in sortedArrayM) {
        NSString *date = key;
        NSString *mood = moodDict[key][MM_MoodKey];
        if (!mood) {
            mood=@"";
        }
        NSString *anxiety = moodDict[key][MM_AnxietyKey];
        if (!anxiety) {
            anxiety = @"";
        }
        NSString *hours = moodDict[key][MM_SleepKey];
        if(!hours){
            hours = @"";
        }
        
        [toReturn appendFormat:@"%@, %@, %@, %@\n",date,mood,anxiety,hours];
    }
    
    [toReturn appendString:@"\n"];
    [toReturn appendString:@"Activities:\n"];
    
    for (NSString *key in sortedArrayA) {
        NSArray *act = activityDict[key];
        [toReturn appendFormat:@"%@: %@\n",key,[act componentsJoinedByString:@","]];
    }
    
    return toReturn;
}
@end
