//
//  MMUUIDHelpers.m
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/19/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "MMUUIDHelpers.h"

@implementation MMUUIDHelpers

+ (NSString *)createUUIDFromAPNSToken:(NSData *)aps {
    NSUInteger len = [aps length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [aps bytes], len);
    
    CFUUIDBytes bytes;
    
    bytes.byte0 = *(byteData + 0);
    bytes.byte1 = *(byteData + 1);
    bytes.byte2 = *(byteData + 2);
    bytes.byte3 = *(byteData + 3);
    bytes.byte4 = *(byteData + 4);
    bytes.byte5 = *(byteData + 5);
    bytes.byte6 = *(byteData + 6);
    bytes.byte7 = *(byteData + 7);
    bytes.byte8 = *(byteData + 8);
    bytes.byte9 = *(byteData + 9);
    bytes.byte10 = *(byteData + 10);
    bytes.byte11 = *(byteData + 11);
    bytes.byte12 = *(byteData + 12);
    bytes.byte13 = *(byteData + 13);
    bytes.byte14 = *(byteData + 14);
    bytes.byte15 = *(byteData + 15);
    
    CFUUIDRef uuid = CFUUIDCreateFromUUIDBytes(kCFAllocatorDefault, bytes);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    free(byteData);
    
    return uuidString;
}

@end
