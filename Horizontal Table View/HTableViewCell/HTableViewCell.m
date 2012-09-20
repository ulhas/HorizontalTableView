//
//  HTableViewCell.m
//  TestGCalendar
//
//  Created by Ulhas Mandrawadkar on 14/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTableViewCell.h"

@interface HTableViewCell ()

@property (nonatomic, readwrite, retain) NSString *identifier;

@end

@implementation HTableViewCell

@synthesize delegate = _delegate;
@synthesize index = _index;
@synthesize identifier = _identifier;

#pragma mark - Tap Gesture Methods

- (void)handleGesture:(UITapGestureRecognizer *)recognizer
{
    [self.delegate didTapHTableViewCell:self];
}

- (void)setupTapGesture
{
    UITapGestureRecognizer *_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
    [_tapGestureRecognizer release], _tapGestureRecognizer = nil;
}

#pragma mark - Init With Frame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupTapGesture];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andIdentifier:(NSString *)identifier
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        self.identifier = identifier;
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupTapGesture];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_identifier release], _identifier = nil;
    [super dealloc];
}

@end
