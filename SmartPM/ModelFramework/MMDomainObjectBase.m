//
//  MMDomainObjectBase.m
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/19/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "MMDomainObjectBase.h"
#import "JSONKit.h"

@implementation MMDomainObjectBase

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return [NSDictionary dictionary];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSDictionaryBuilder ()

@property (nonatomic, strong) NSMutableDictionary * resultDictionary;

@end

@implementation NSDictionaryBuilder

- (id)init {
    return [self initWithDictionary:[NSDictionary dictionary]];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.resultDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    
    return self;
}

- (NSDictionaryBuilder *)addObject:(id<NSObject>)object forKey:(NSString *)key {
    
    NSAssert(self.resultDictionary != nil, @"A dictionary exists here");
    [self.resultDictionary setObject:object forKey:key];
    
    return self;
}

- (NSDictionary *)build {
    return [NSDictionary dictionaryWithDictionary:self.resultDictionary];
}

- (NSData *)buildJson {
    return [self.resultDictionary JSONData];
}

- (NSString *)buildJSONString {
    return [self.resultDictionary JSONString];
}


@end
