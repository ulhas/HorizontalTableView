//
//  UMViewController.m
//  HorizontalTableViewTest
//
//  Created by UlhasM on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UMViewController.h"

@interface UMViewController ()

- (void)setupHorizontalTableView;
@property (nonatomic, retain) HTableView *hTableView;

@end

@implementation UMViewController

@synthesize hTableView = _hTableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupHorizontalTableView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    [_hTableView release], _hTableView = nil;
    [super dealloc];
}

#pragma mark - View Controller Methods

- (IBAction)reloadTableViewButtonClicked:(UIButton *)sender
{
    [self.hTableView reloadData];
}

#pragma mark - Horizontal Table View Datasource

- (NSInteger)numberOfColumnsInHTableView:(HTableView *)hTableView
{
    return 5;
}

- (CGFloat)hTableView:(HTableView *)hTableView widthForColumnAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.column % 2) {
        return 100.0f;
    }
    
    return 150.0f;
}

- (HTableViewCell *)hTableView:(HTableView *)hTableView cellForColumnAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    HTableViewCell *_horizontalCell = [hTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!_horizontalCell) {
        _horizontalCell = [[[HTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, hTableView.frame.size.height) andIdentifier:identifier] autorelease];
    }
    
    int _evenColumn = indexPath.column % 2;
    
    switch (_evenColumn) {
        case 0:
            _horizontalCell.backgroundColor = [UIColor greenColor];
            break;
            
        case 1:
            _horizontalCell.backgroundColor = [UIColor redColor];
            break;
            
        default:
            break;
    }
    
    return _horizontalCell;
}

#pragma mark - Horizontal Table View Delegate

- (void)hTableView:(HTableView *)hTableView didSelectColumnAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Table View Tapped at indexpath : %@", indexPath);
}

#pragma mark - Setup Methods

- (HTableView *)hTableView
{
    if (!_hTableView) {
        _hTableView = [[HTableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 150)];
        _hTableView.dataSource = self;
        _hTableView.delegate = self;
    }
    return _hTableView;
}

- (void)setupHorizontalTableView
{
    [self.view addSubview:self.hTableView];
    [self.hTableView reloadData];
}

@end
