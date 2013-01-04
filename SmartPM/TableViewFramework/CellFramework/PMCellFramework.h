//
//  PMCellFramework.h
//
//  Created by Bruno Bulić on 12/6/12.
//  Copyright (c) 2012 Pinjamar d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMCellProtocols.h"



@protocol PMMutableCellFrameworkDelegate <PMCellFrameworkDelegate>

- (void)CUTableView:(UITableView *)tableView object:(id<PMCellItem>)object isRemovedAtPath:(NSIndexPath *)indexPath;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PMCellDataSource : NSObject<UITableViewDataSource>

- (id)initWithDelegate:(id<PMCellFrameworkDelegate>)delegate;
- (id)initWithArray:(NSArray *)array withDelegate:(id<PMCellFrameworkDelegate>)delegate;
- (id)initWithSectionedArray:(NSArray *)array withDelegate:(id<PMCellFrameworkDelegate>)delegate;

- (id<PMCellItem>)itemForIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, unsafe_unretained) id<PMCellFrameworkDelegate> delegate;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PMMutableCellDataSource : PMCellDataSource

- (void)addObject:(id<PMCellItem>)object toIndexPath:(NSIndexPath *)indexPath;
- (void)removeObject:(id<PMCellItem>)object;
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, unsafe_unretained) id<PMMutableCellFrameworkDelegate> delegate;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////


@interface PMCellGenerator : NSObject

+ (UITableViewCell *)PMTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath forObject:(id<PMCellItem>)userData;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PMTableViewDelegate : NSObject<UITableViewDelegate>

- (id)initWithDataSource:(PMCellDataSource *)dataSource;

@property (nonatomic, unsafe_unretained) id<PMTableViewDelegateProtocol> delegate;

@end