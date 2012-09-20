//
//  HTableView.h
//  TestGCalendar
//
//  Created by Ulhas Mandrawadkar on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableViewCell.h"

@class HTableView;

@protocol HTableViewDataSource <NSObject>

- (NSInteger)numberOfColumnsInHTableView:(HTableView *)hTableView;
- (HTableViewCell *)hTableView:(HTableView *)hTableView cellForColumnAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol HTableViewDelegate <NSObject>

- (void)hTableView:(HTableView *)hTableView didSelectColumnAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)hTableView:(HTableView *)hTableView widthForColumnAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSIndexPath (HTableView)

+ (NSIndexPath *)indexPathForColumn:(NSUInteger)column;

@property (nonatomic, readonly) NSUInteger column;

@end

@interface HTableView : UIView

@property (nonatomic, assign) IBOutlet id<HTableViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<HTableViewDelegate> delegate;

- (void)reloadData;
- (HTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
