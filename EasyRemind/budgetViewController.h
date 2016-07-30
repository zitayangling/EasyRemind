//
//  budgetViewController.h
//  HJB
//
//  Created by 周建臣 on 16/5/31.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

@protocol PassValuesDelegate <NSObject>

@optional
- (void)PassValuesWithBill:(Bill *)bill;

@end

@interface budgetViewController : UIViewController
@property (strong, nonatomic) Bill *theBill;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) id<PassValuesDelegate> PassValueDelegeta;

@end
