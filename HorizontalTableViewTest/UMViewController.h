//
//  UMViewController.h
//  HorizontalTableViewTest
//
//  Created by UlhasM on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTableView.h"

@interface UMViewController : UIViewController <HTableViewDataSource, HTableViewDelegate>

- (IBAction)reloadTableViewButtonClicked:(UIButton *)sender;

@end
