//
//  CUCellBase.h
//  Cuepid
//
//  Created by Bruno Bulić on 12/6/12.
//  Copyright (c) 2012 HolosOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCellFramework.h"

@interface PMCellBase : UITableViewCell <PMCell>

@property (nonatomic, strong) IBOutlet UIView * nibView;
@property (nonatomic, strong) id userData;

+ (NSString *)nibName;
- (NSString *)nibName;

@end

