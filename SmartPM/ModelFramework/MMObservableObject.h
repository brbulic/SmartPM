//
//  MMObservableObject.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/26/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMObservableObject;

@protocol MMListenerDelegate <NSObject>

@end


@interface MMObservableObject : NSObject

@property (nonatomic, unsafe_unretained) id<MMListenerDelegate> delegate;

- (void)registerListener:(id<MMListenerDelegate>)delegate;
- (void)unregisterListener:(id<MMListenerDelegate>)delegate;

@end
