//
//  MMObservableObject+ProtectedMethods.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/26/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "MMObservableObject.h"

@interface MMObservableObjectData : NSObject

@property (nonatomic, strong) id<MMListenerDelegate> invocationTarget;
@property (nonatomic, strong) NSArray * invokeKeys;

@end

@interface MMObservableObject (ProtectedMethods)

- (void)invokeChange;
- (void)invokeChangeForKey:(NSString *)key;

- (NSUInteger)listenerCount;

- (void)doInvocationForObject:(id<MMListenerDelegate>)object forKeyOrNil:(NSString *)keyOrNil;
- (NSArray *)supportedKeysForObject:(id<MMListenerDelegate>)object;


@end
