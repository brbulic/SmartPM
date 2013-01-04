//
//  MMBatteryDataHelper.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/21/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MMObservableObject.h"

//////////////////////////////////////////////////

@class MMBatteryDataHelper;

@protocol MMBatteryDataDelegate <MMListenerDelegate>

- (void)batteryHelper:(MMBatteryDataHelper *)helper batteryStateChangedTo:(UIDeviceBatteryState)batteryState;
- (void)batteryHelper:(MMBatteryDataHelper *)helper batteryLevelChangedTo:(NSUInteger)currentLevel;

@end

//////////////////////////////////////////////////

@interface MMBatteryDataHelper : MMObservableObject

+ (MMBatteryDataHelper *)sharedHelper;

@property (nonatomic, readonly) UIDeviceBatteryState currentBatteryState;
@property (nonatomic, readonly) float_t currentBatteryLevel;

@property (nonatomic, readonly) NSString * batteryType; 
@property (nonatomic, readonly) NSString * batteryCapacity;
@property (nonatomic, readonly) NSString * batteryHealth;

@end


@interface MMBatteryDataHelper (MMDomainObject)

- (NSString *)stringFromBatteryState;
- (NSNumber *)percentFromCurrentBatteryLevel;

@end