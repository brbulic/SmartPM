//
//  CUTableViewDelegate+ProtectedMethods.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/14/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "PMCellFramework.h"

@interface PMTableViewDelegate (ProtectedMethods)

@property (nonatomic, unsafe_unretained) PMCellDataSource *dataSource;

- (void)tableView:(UITableView *)tableView didSelectObject:(id<PMCellItem>)cellItem atIndexPath:(NSIndexPath *)indexPath;

@end
