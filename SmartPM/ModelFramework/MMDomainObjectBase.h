//
//  MMDomainObjectBase.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/19/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDomainObject.h"

@interface MMDomainObjectBase : NSObject<MMDomainObject>

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSDictionaryBuilder : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionaryBuilder *)addObject:(id<NSObject>)object forKey:(NSString *)key;

- (NSDictionary *)build;

- (NSData *)buildJson;
- (NSString *)buildJSONString;

@end
