//
//  PMCellFramework.m
//
//  Created by Bruno Bulić on 12/6/12.
//  Copyright (c) 2012 Pinjamar d.o.o. All rights reserved.
//

#import "PMCellFramework.h"
#import "PMTableViewDelegate+ProtectedMethods.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
@interface PMCellDataSource ()

@property (nonatomic, unsafe_unretained) UITableView *myTableView;

@property (nonatomic, assign) BOOL isSectionedArray;
@property (nonatomic, strong) NSArray * sectionNames;


- (void)configureSections:(NSArray *)sections;
- (id<PMCellItem>)itemForIndexPath:(NSIndexPath *)path;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PMCellDataSource

- (id)initWithArray:(NSArray *)array withDelegate:(id<PMCellFrameworkDelegate>)delegate {
    self = [super init];
    
    if(self) {
        _delegate = delegate;
        _itemArray = array;
    }
    
    return self;
}

- (id)initWithSectionedArray:(NSArray *)array withDelegate:(id<PMCellFrameworkDelegate>)delegate {
    
    self = [super init];
    if (self) {
        [self configureSections:array];
        self.isSectionedArray = YES;
        _delegate = delegate;
    }
    
    return self;
}

- (id<PMCellItem>)itemForIndexPath:(NSIndexPath *)indexPath; {
    id object;
    
    if(self.isSectionedArray) {
        object = [[self.itemArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else {
        object = [self.itemArray objectAtIndex:indexPath.row];
    }
    
    BOOL conformsToProtocol = [object conformsToProtocol:@protocol(PMCellItem)];
    NSAssert(conformsToProtocol, @"The class name %@ doesn't conform to PMCellItem protocol.", NSStringFromClass([object class]));
    
    return object;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isSectionedArray)
        return [self.sectionNames count];
    return 1;
}

- (void)configureSections:(NSArray *)sections {
    NSMutableArray * finalArray = [[NSMutableArray alloc] init];

    int currentSection = -1;
    
    NSMutableArray *sectionNames = [[NSMutableArray alloc] init];
    
    for (id object in sections) {
        
        // section header
        if([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSMutableString class]]) {
            currentSection++;
            [sectionNames insertObject:object atIndex:currentSection];
            [finalArray addObject:[NSMutableArray array]];
            continue;
        }
        
        if(![object conformsToProtocol:@protocol(PMCellItem)]) {
            @throw [NSException exceptionWithName:@"NSInvalidItemInArray" reason:@"You are to have PMCellItems in array with section names" userInfo:nil];
        }
        
        [[finalArray objectAtIndex:currentSection] addObject:object];
    }
    
    
    self.itemArray = [NSArray arrayWithArray:finalArray];
    self.sectionNames = [NSArray arrayWithArray:sectionNames];
}

- (id)initWithDelegate:(id<PMCellFrameworkDelegate>)delegate {
    self = [super init];
    
    if(self) {
        _delegate = delegate;
    }
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert(self.delegate != nil, @"Delegate must exist here!");
    id object = [self itemForIndexPath:indexPath];
    
    return [self.delegate PMTableView:tableView atIndexPath:indexPath forObject:object];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(!self.isSectionedArray) return nil;

    return [self.sectionNames objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.myTableView == nil) self.myTableView = tableView;

    
    if(self.isSectionedArray) {
        return [[self.itemArray objectAtIndex:section] count];
    }
    else {
        return [self.itemArray count];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PMMutableCellDataSource

- (void)addObject:(id<PMCellItem>)object toIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * array = [self.itemArray mutableCopy];
    
    
    if(self.isSectionedArray) {
        [[array objectAtIndex:indexPath.section] insertObject:object atIndex:indexPath.row];
    }
    else {
        [array insertObject:object atIndex:indexPath.row];
    }

    self.itemArray = [NSArray arrayWithArray:array];
    
    NSAssert(self.myTableView != nil, @"An UITableView must exist here I'm afraid...");
    
    [self.myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeObject:(id<PMCellItem>)object {
    NSAssert([object conformsToProtocol:@protocol(PMCellItem)], @"Object of class %@ must implement the PMCellItem protocol!", NSStringFromClass([object class]));
    
    NSMutableArray * array = [self.itemArray mutableCopy];
    
    if(self.isSectionedArray) {
        for (id sections in array) {
            if([sections containsObject:object]) {
                [sections removeObject:object];
            }
        }
    }
    else {
        [array removeObject:object];
    }
    
    self.itemArray = [NSArray arrayWithArray:array];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    id<PMCellItem> removableObject = [self.itemArray objectAtIndex:indexPath.row];
    
    NSMutableArray * mutableArray = [self.itemArray mutableCopy];
    [mutableArray removeObject:removableObject];
    
    self.itemArray = [NSArray arrayWithArray:mutableArray];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!self.delegate) return;
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        id<PMCellItem> itemOfInterest = [self itemForIndexPath:indexPath];
        [self.delegate CUTableView:tableView object:itemOfInterest isRemovedAtPath:indexPath];
        [self removeObject:itemOfInterest];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PMCellGenerator


+ (UITableViewCell *)PMTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath forObject:(id<PMCellItem>)userData {
    
    Class cellClass = [userData classForCellItem];
    NSString *identifier = NSStringFromClass(cellClass);
    
    UITableViewCell<PMCell> * tableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(tableViewCell) {
        [tableViewCell shouldUpdateCell:userData];
    } else {
        tableViewCell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        BOOL conformsToProtocol = [tableViewCell conformsToProtocol:@protocol(PMCell)];
        NSAssert(conformsToProtocol, @"TableViewCell %@ should conform to protocol PMCell", identifier);
        
        [tableViewCell shouldUpdateCell:userData];
    }
    
    return tableViewCell;
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PMTableViewDelegate ()

@property (nonatomic, unsafe_unretained) PMCellDataSource *dataSource;

@end

@implementation PMTableViewDelegate

- (id)initWithDataSource:(PMCellDataSource *)dataSource {
    self = [super init];
    
    if(self) {
        self.dataSource = dataSource;
    }
    
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<PMCellItem> item = [self.dataSource itemForIndexPath:indexPath];
    [self tableView:tableView didSelectObject:item atIndexPath:indexPath];
}


@end


@implementation PMTableViewDelegate (ProtectedMethods)

@dynamic dataSource;

- (void)tableView:(UITableView *)tableView didSelectObject:(id<PMCellItem>)cellItem atIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableView:selectedObject:atIndexPath:)]) {
        [self.delegate tableView:tableView:cellItem atIndexPath:indexPath];
    }
}

@end