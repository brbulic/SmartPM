//
//  MMDeviceHelpers.m
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/13/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "MMDeviceHelpers.h"

#import <mach/mach.h>
#import <mach/mach_host.h>


void fillMemoryStatusWithData(MMMemoryStatus * status, const natural_t usedMemory, const natural_t freeMemory, const natural_t totalMemory) {
    status->usedMemory = usedMemory;
    status->freeMemory = freeMemory;
    status->totalMemory = totalMemory;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MMDeviceHelpers

+ (MMMemoryStatus)getDeviceCurrentMemoryStatus {
    
    MMMemoryStatus currentStatus;
    
    /* memory checking code */
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;

    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
        fillMemoryStatusWithData(&currentStatus, -1, -1, -1);
    }
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;

    fillMemoryStatusWithData(&currentStatus, mem_used, mem_free, mem_total);
    
    return currentStatus;
}

@end
