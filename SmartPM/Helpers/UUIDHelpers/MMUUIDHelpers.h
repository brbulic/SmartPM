//
//  MMUUIDHelpers.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/19/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMUUIDHelpers : NSObject

+ (NSString *)createUUIDFromAPNSToken:(NSData *)data;

@end
