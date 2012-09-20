//
//  HTableView.m
//  TestGCalendar
//
//  Created by Ulhas Mandrawadkar on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTableView.h"

#define INDEX_AT_POSITION 0

#pragma mark - H Reusable Queue Class

@interface HReusableCellQueue : NSObject

@property (nonatomic, retain) NSString *identifier;

+ (HReusableCellQueue *)reusableCellQueueWithIdentifier:(NSString *)identifier;

- (HTableViewCell *)reusableCell;

@end

@interface HReusableCellQueue ()

#define FIRST_OBJECT_INDEX 0

@property (nonatomic, retain) NSMutableArray *queue;

@end

@implementation HReusableCellQueue

@synthesize identifier = _identifier;
@synthesize queue = _queue;

#pragma mark - Initialization Methods

+ (HReusableCellQueue *)reusableCellQueueWithIdentifier:(NSString *)identifier
{
    HReusableCellQueue *_cellQueue = [[[HReusableCellQueue alloc] init] autorelease];
    _cellQueue.identifier = identifier;
    
    return _cellQueue;
}

#pragma mark - Instance Methods

- (void)dealloc
{
    [_queue release], _queue = nil;
    [_identifier release], _identifier = nil;
    [super dealloc];
}

- (NSMutableArray *)queue
{
    if (!_queue) {
        _queue = [[NSMutableArray alloc] init];
    }
    
    return _queue;
}

- (HTableViewCell *)reusableCell
{
    HTableViewCell *_cell = nil;
    
    @try {
        _cell = [self.queue objectAtIndex:FIRST_OBJECT_INDEX];
    }
    @catch (NSException *exception) {
        NSLog(@"%s, Identifier %@, %@", __FUNCTION__, self.identifier, exception.description);
    }
    
    return _cell;
}

@end

#pragma mark - End H Reusable Queue Class

#pragma mark - IndexPath Extention

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

#pragma mark - End IndexPath Extention

#pragma mark - Horizontal Table View Implementation

@interface HTableView () <HTableViewCellDelegate, UIScrollViewDelegate>

#define DEFAULT_CONTENT_WIDTH 44.0f;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *reusableCellQueues;
@property (nonatomic, assign) CGFloat contentWidth;

- (void)clearScrollViewContents;
- (void)calculateContentWidth;
- (void)setScrollViewContentSize;

- (HReusableCellQueue *)reusableCellQueueWithIdentifier:(NSString *)identifier;
- (HReusableCellQueue *)createReusableCellQueueWithIdentifier:(NSString *)identifier;

@property (nonatomic, readonly) NSInteger currentIndex;

@end

@implementation HTableView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize reusableCellQueues = _reusableCellQueues;
@synthesize scrollView = _scrollView;
@synthesize contentWidth = _contentWidth;

#pragma mark - Custom Methods

- (void)layoutSubviews
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSInteger cellCount = [self.dataSource numberOfColumnsInHTableView:self];
    
    [self clearScrollViewContents];
    
    for (int index = 0; index < cellCount; index++) {
        NSIndexPath *_indexPath = [NSIndexPath indexPathForColumn:index];
        
        HTableViewCell *tableViewCell = [self.dataSource hTableView:self cellForColumnAtIndexPath:_indexPath];
        
        NSInteger _columnWidth;
        if ([self.delegate respondsToSelector:@selector(hTableView:widthForColumnAtIndexPath:)])
            _columnWidth = [self.delegate hTableView:self widthForColumnAtIndexPath:_indexPath];
        else
            _columnWidth = tableViewCell.frame.size.width;
        
        CGSize _scrollViewContentSize = self.scrollView.contentSize;
        
        tableViewCell.delegate = self;
        tableViewCell.index = index;
        tableViewCell.frame = CGRectMake(_scrollViewContentSize.width, self.scrollView.bounds.origin.y, _columnWidth, self.scrollView.bounds.size.height);
        
        [self.scrollView addSubview:tableViewCell];
        
        _scrollViewContentSize.width += tableViewCell.frame.size.width;
        self.scrollView.contentSize = _scrollViewContentSize;
    }
    
    if (![self.scrollView.superview isEqual:self]) {
        [self addSubview:self.scrollView];
    }
    
    [pool drain];
}

#pragma mark - HTableViewDelegate Methods

- (void)didTapHTableViewCell:(HTableViewCell *)hTableViewCell
{
    [self.delegate hTableView:self didSelectColumnAtIndexPath:[NSIndexPath indexPathForColumn:hTableViewCell.index]];
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setNeedsLayout];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setNeedsLayout];
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
    [_scrollView release], _scrollView = nil;
    [_reusableCellQueues release], _reusableCellQueues = nil;
    [super dealloc];
}

- (NSMutableArray *)reusableCellQueues
{
    if (!_reusableCellQueues) {
        _reusableCellQueues = [[NSMutableArray alloc] init];
    }
    
    return _reusableCellQueues;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

#pragma mark - Table View Custom Methods

- (void)reloadData
{
//    [self calculateContentWidth];
//    [self setScrollViewContentSize];
    [self clearScrollViewContents];
    [self setNeedsLayout];
}

#pragma mark - Dequeing Methods

- (HReusableCellQueue *)createReusableCellQueueWithIdentifier:(NSString *)identifier
{
    HReusableCellQueue *_cellQueue = [HReusableCellQueue reusableCellQueueWithIdentifier:identifier];
    
    [self.reusableCellQueues addObject:_cellQueue];
    return _cellQueue;
}

- (HReusableCellQueue *)reusableCellQueueWithIdentifier:(NSString *)identifier
{
    HReusableCellQueue *_cellQueue = nil;
    
    for (HReusableCellQueue *_queue in self.reusableCellQueues) {
        if ([_queue.identifier isEqualToString:identifier]) {
            _cellQueue = _queue;
            break;
        }
    }
    
    return !_cellQueue ? [self createReusableCellQueueWithIdentifier:identifier] : _cellQueue;
}

- (HTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    HReusableCellQueue *_reusableCellQueue = [self reusableCellQueueWithIdentifier:identifier];
    
    return [_reusableCellQueue reusableCell];
}

#pragma mark - ScrollView Methods

- (void)clearScrollViewContents
{
    for (UIView *_subView in self.scrollView.subviews) {
        [_subView removeFromSuperview];
    }
}

- (void)calculateContentWidth
{
    self.contentWidth = 0.0f;
    
    NSInteger cellCount = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInHTableView:)]) {
        cellCount = [self.dataSource numberOfColumnsInHTableView:self];
    } else
        return;
    
    if (0 > cellCount)
        return;
    
    for (int index = 0; index < cellCount; index++) {
        if ([self.delegate respondsToSelector:@selector(hTableView:widthForColumnAtIndexPath:)]) {
            NSIndexPath *_indexPath = [NSIndexPath indexPathForColumn:index];
            
            self.contentWidth += [self.delegate hTableView:self widthForColumnAtIndexPath:_indexPath];
        } else {
            self.contentWidth += DEFAULT_CONTENT_WIDTH; 
        }
    }
}

- (void)setScrollViewContentSize
{
    self.scrollView.contentSize = CGSizeMake(self.contentWidth, self.scrollView.bounds.size.height);
}

- (NSInteger)currentIndex
{
    CGFloat _minimumWidth = 1.0f;
    
    CGRect _currentIndexBound = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, _minimumWidth, self.scrollView.bounds.size.height);
    
    return 0;
}

#pragma mark - End Horizontal Table View Implementation

@end
