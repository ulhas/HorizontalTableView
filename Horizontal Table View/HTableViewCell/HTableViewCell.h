//
//  HTableViewCell.h
//  TestGCalendar
//
//  Created by Ulhas Mandrawadkar on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTableViewCell;

@protocol HTableViewCellDelegate <NSObject>

- (void)didTapHTableViewCell:(HTableViewCell *)hTableViewCell;

@end

@interface HTableViewCell : UIView

@property (nonatomic, assign) IBOutlet id<HTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

@end
