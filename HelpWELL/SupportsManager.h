//
//  SupportsManager.h
//  HelpWELL
//
//  Created by Ricky Kirkendall on 10/30/14.
//  Copyright (c) 2014 WellWVU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportsManager : NSObject

extern NSString * const Support_StoreKey;
extern NSString * const Support_NameKey;
extern NSString * const Support_NumberKey;

+(NSArray *)AllSupports;
+(NSArray *)CustomSupports;
+(NSArray *)StandardSupports;

+(void)SaveCustomSupportWithName:(NSString *)name andNumber:(NSString *)number;
+(NSArray *)DeleteCustomSupportWithName:(NSString *)name andNumber:(NSString *)number;

@end
