//
//  MMDeviceHelpers.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/13/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    natural_t usedMemory;
    natural_t freeMemory;
    natural_t totalMemory;
} MMMemoryStatus;


void fillMemoryStatusWithData(MMMemoryStatus * status, const natural_t usedMemory, const natural_t freeMemory, const natural_t totalMemory);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MMDeviceHelpers : NSObject

+ (MMMemoryStatus)getDeviceCurrentMemoryStatus;

@end
