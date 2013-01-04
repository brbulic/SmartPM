//
//  MMBatteryDataHelper.m
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/21/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "MMBatteryDataHelper.h"
#import "MMExceptionUtils.h"
#import "UIDeviceHardware.h"
#import "MMObservableObject+ProtectedMethods.h"

#define MMBatteryHelperBatteryType @"Li-Po"

@interface MMBatteryDataHelper ()

- (void)batteryLevelChanged:(id)not;
- (void)batteryStateChanged:(id)not;

- (id)initPrivate:(UIDeviceHardware *)hardwareData;

@end

@implementation MMBatteryDataHelper

static MMBatteryDataHelper * sharedHelper;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIDeviceHardware * dh = [[UIDeviceHardware alloc] init];
        sharedHelper = [[MMBatteryDataHelper alloc] initPrivate:dh];
    });
}

+ (MMBatteryDataHelper *)sharedHelper {
    return sharedHelper;
}

- (id)init {
    [MMExceptionUtils raiseNotImplementedException:@"Cannot instantiate object by yourself!"];
    return nil;
}

- (void)doInvocationForObject:(id<MMBatteryDataDelegate>)object forKeyOrNil:(NSString *)keyOrNil {
    
    NSAssert(object != nil, @"Callback delegate must exist!");
    
    
    BOOL shouldRun = [keyOrNil isEqualToString:UIDeviceBatteryLevelDidChangeNotification] || keyOrNil == nil;
    
    if([object respondsToSelector:@selector(batteryHelper:batteryLevelChangedTo:)] && shouldRun) {
        [object batteryHelper:self batteryLevelChangedTo:self.currentBatteryLevel];
    }
    
    shouldRun = [keyOrNil isEqualToString:UIDeviceBatteryStateDidChangeNotification] || keyOrNil == nil;
    
    if([object respondsToSelector:@selector(batteryHelper:batteryStateChangedTo:)] && shouldRun) {
        [object batteryHelper:self batteryStateChangedTo:self.currentBatteryState];
    }

}

- (NSArray *)supportedKeysForObject:(id<MMListenerDelegate>)object {
    
    if ([object conformsToProtocol:@protocol(MMBatteryDataDelegate)]) {
        return @[UIDeviceBatteryStateDidChangeNotification, UIDeviceBatteryLevelDidChangeNotification];
    }
    
    return [NSArray array];
}

-(id)initPrivate:(UIDeviceHardware *)hardwareData {
    self = [super init];
    if (self) {
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChanged:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateChanged:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
        
        NSString *platform = [hardwareData platform];
        _batteryCapacity = @"Unknown";
        
        if ([platform isEqualToString:@"iPhone1,1"]) _batteryCapacity = @"1400mAh";
        if ([platform isEqualToString:@"iPhone1,2"]) _batteryCapacity = @"1150mAh";
        if ([platform isEqualToString:@"iPhone2,1"]) _batteryCapacity = @"1219mAh";
        if ([platform isEqualToString:@"iPhone3,1"]) _batteryCapacity = @"1420mAh";
        if ([platform isEqualToString:@"iPhone3,3"]) _batteryCapacity = @"1420mAh";
        if ([platform isEqualToString:@"iPhone3,1"]) _batteryCapacity = @"1420mAh";
        if ([platform isEqualToString:@"iPhone3,3"]) _batteryCapacity = @"1420mAh";
        if ([platform isEqualToString:@"iPhone4,1"]) _batteryCapacity = @"1432mAh";
        if ([platform isEqualToString:@"iPhone5,1"]) _batteryCapacity = @"1440mAh";
        if ([platform isEqualToString:@"iPhone5,2"]) _batteryCapacity = @"1440mAh";
        
        _batteryType = MMBatteryHelperBatteryType;
        _batteryHealth = @"Unknown";
        _currentBatteryState = [UIDevice currentDevice].batteryState;
        _currentBatteryLevel = [UIDevice currentDevice].batteryLevel;
    }
    
    return self;
}


- (void)batteryLevelChanged:(id)not {
    _currentBatteryLevel = [UIDevice currentDevice].batteryLevel;
    [super invokeChangeForKey:UIDeviceBatteryLevelDidChangeNotification];
    
    NSLog(@"Invoking level changed...");
}

- (void)batteryStateChanged:(id)not {
    _currentBatteryState = [UIDevice currentDevice].batteryState;
    [super invokeChangeForKey:UIDeviceBatteryStateDidChangeNotification];
    
    NSLog(@"Invoking state changed...");
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation MMBatteryDataHelper (MMDomainObject)

- (NSString *)stringFromBatteryState {
    
    UIDeviceBatteryState state = self.currentBatteryState;
    NSString * result = nil;
    
    switch (state) {
            /*
        case UIDeviceBatteryStateUnplugged:
            result = STRING_BY_KEY(@"BATTERY_UNPLUGGED");
            break;
        case UIDeviceBatteryStateCharging:
            result = STRING_BY_KEY(@"BATTERY_CHARGING");
            break;
        case UIDeviceBatteryStateFull:
            result = STRING_BY_KEY(@"BATTERY_FULL");
            break;
        case UIDeviceBatteryStateUnknown:*/
        default:
//            result = STRING_BY_KEY(@"BATTERY_UNKNOWN");
            break;
    }
    
    return result;
}

- (NSNumber *)percentFromCurrentBatteryLevel {
    NSNumber *level = [NSNumber numberWithFloat:self.currentBatteryLevel*100];
    return level;
}

@end
