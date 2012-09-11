//
//  HTableView.m
//  TestGCalendar
//
//  Created by Ulhas Mandrawadkar on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTableView.h"

#define INDEX_AT_POSITION 0

@implementation NSIndexPath (HTableView)

+ (NSIndexPath *)indexPathForColumn:(NSUInteger)column
{    
    return [NSIndexPath indexPathWithIndex:column];
}

- (NSUInteger)column
{
    return [self indexAtPosition:INDEX_AT_POSITION];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"IndexPath Column : %d", self.column];
}

@end

@interface HTableView ()

@end

@implementation HTableView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

#pragma mark - Custom Methods

- (void)initializeHTableView
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UIScrollView *_horizontalScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _horizontalScrollView.showsHorizontalScrollIndicator = NO;
    _horizontalScrollView.showsVerticalScrollIndicator = NO;
    
    NSInteger cellCount = [self.dataSource numberOfColumnsInHTableView:self];
    
    for (int index = 0; index < cellCount; index++) {
        NSIndexPath *_indexPath = [NSIndexPath indexPathForColumn:index];
        
        HTableViewCell *tableViewCell = [self.dataSource hTableView:self cellForColumnAtIndexPath:_indexPath];
        
        NSInteger _columnWidth;
        if ([self.dataSource respondsToSelector:@selector(hTableView:widthForColumnAtIndexPath:)])
            _columnWidth = [self.dataSource hTableView:self widthForColumnAtIndexPath:_indexPath];
        else
            _columnWidth = tableViewCell.frame.size.width;
        
        CGSize _scrollViewContentSize = _horizontalScrollView.contentSize;
        
        tableViewCell.delegate = self;
        tableViewCell.index = index + 1;
        tableViewCell.frame = CGRectMake(_scrollViewContentSize.width, _horizontalScrollView.bounds.origin.y, _columnWidth, _horizontalScrollView.bounds.size.height);
        
        [_horizontalScrollView addSubview:tableViewCell];
        
        _scrollViewContentSize.width += tableViewCell.frame.size.width;
        _horizontalScrollView.contentSize = _scrollViewContentSize;
    }
    
    [self addSubview:_horizontalScrollView];
    [_horizontalScrollView release], _horizontalScrollView = nil;
    
    [pool drain];
}

#pragma mark - HTableViewDelegate Methods

- (void)didTapHTableViewCell:(HTableViewCell *)hTableViewCell
{
    [self.delegate hTableView:self didSelectColumnAtIndexPath:[NSIndexPath indexPathForColumn:(hTableViewCell.index - 1)]];
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeHTableView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initializeHTableView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Memory Management

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Table View Custom Methods

- (void)reloadData
{
    UIScrollView *_horizontalScrollView = (UIScrollView *)[[[self subviews] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass:%@", [UIScrollView class]]] lastObject];
    [_horizontalScrollView removeFromSuperview];
    [self initializeHTableView];
}

@end
