//
//  PMCellProtocols.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/14/12.
//  Copyright (c) 2012 Pinjamar d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* Cell configuration protocols */

@protocol PMCellItem <NSObject>

- (Class)classForCellItem;

@end


@protocol PMCell <NSObject>

- (BOOL)shouldUpdateCell:(id)cellObject;

@end

@protocol PMTableViewDelegateProtocol <NSObject>
@optional
- (void)tableView:(UITableView *) selectedObject:(id<PMCellItem>)object atIndexPath:(NSIndexPath *)indexPath;
@end

/* Cell configuration delegate */

@protocol PMCellFrameworkDelegate <NSObject>
- (UITableViewCell *)PMTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath forObject:(id)userData;
@end

