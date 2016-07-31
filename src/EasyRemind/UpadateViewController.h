//
//  UpadateViewController.h
//  HJB
//
//  Created by 周建臣 on 16/5/29.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"
#import "SqliteManager.h"


@interface UpadateViewController : UIViewController
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) Bill *theBill;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) SqliteManager *SQLmanager;

@end
