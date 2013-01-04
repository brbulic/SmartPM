//
//  MMObservableObject.m
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/26/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "MMObservableObject.h"
#import "MMObservableObject+ProtectedMethods.h"
#import "MMExceptionUtils.h"

@implementation MMObservableObjectData


@end

@interface MMObservableObject ()

@property (nonatomic, strong) NSArray * invokerArray;

@end


@implementation MMObservableObject {
    NSObject * lockObject;
}

- (id)init {
    self = [super init];
    if(self) {
        lockObject = [[NSObject alloc] init];
        self.invokerArray = [NSArray array];
    }
    
    return self;
}

- (void)registerListener:(id<MMListenerDelegate>)delegate {
    NSArray * currentArrayOfListeners = nil;
    
    @synchronized(lockObject) {
        currentArrayOfListeners = [self.invokerArray copy];
        
        BOOL contains = NO;
        
        for (MMObservableObjectData *element in currentArrayOfListeners) {
            if([element.invocationTarget isEqual:delegate]) {
                contains = YES;
                break;
            };
        }
        
        if(!contains) {
            
            MMObservableObjectData * data = [[MMObservableObjectData alloc] init];
            
            NSArray * keyArrays = [self supportedKeysForObject:delegate];
            
            data.invocationTarget = delegate;
            data.invokeKeys = [NSArray arrayWithArray:keyArrays];
            self.invokerArray = [currentArrayOfListeners arrayByAddingObject:data];
        }
    }
}

- (void)unregisterListener:(id<MMListenerDelegate>)delegate {
    
    NSMutableArray * currentArrayOfListners = nil;
    
    @synchronized(lockObject) {
        currentArrayOfListners = [self.invokerArray mutableCopy];
        
        MMObservableObjectData * containable = nil;
        
        for (MMObservableObjectData *element in currentArrayOfListners) {
            if([element.invocationTarget isEqual:delegate]) {
                containable = element;
                break;
            };
        }
        
        if(containable) {
            [currentArrayOfListners removeObject:containable];
        }
        
        self.invokerArray = [NSArray arrayWithArray:currentArrayOfListners];
    }
}

@end

@implementation MMObservableObject (ProtectedMethods)

- (void)invokeChangeForKey:(NSString *)key {
    NSArray * array = nil;
    
    // if the key is nil, call for all keys
    if(key == nil) {
        [self invokeChange];
        return;
    }
    
    @synchronized(lockObject) {
        array = [self.invokerArray copy];
    }
    
    for (MMObservableObjectData * data in array) {
        
        if([data.invokeKeys containsObject:key]) {
            [self doInvocationForObject:data.invocationTarget forKeyOrNil:key];
        }
    }
}

- (NSUInteger)listenerCount {
    return self.invokerArray.count;
}

- (void)invokeChange {
    
    NSArray * array = nil;
    
    @synchronized(lockObject) {
        array = [self.invokerArray copy];
    }
    
    for (MMObservableObjectData * data in array) {
        [self doInvocationForObject:data.invocationTarget forKeyOrNil:nil];
    }
}

- (void)doInvocationForObject:(id<MMListenerDelegate>)object forKeyOrNil:(NSString *)keyOrNil {
    [MMExceptionUtils raiseInvalidAccessException:@"Inherit this method in your class"];
}

- (NSArray *)supportedKeysForObject:(id<MMListenerDelegate>)object {
    [MMExceptionUtils raiseInvalidAccessException:@"Inherit this method in your class"];
    
    return nil;
}

@end
