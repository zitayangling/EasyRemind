//
//  AddBillViewController.h
//  HJB
//
//  Created by zitayangling on 16/5/19.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

@protocol passValuesDelegate <NSObject>

@optional

- (void)passValuesWithBill:(Bill *)bill;

@end

@interface AddBillViewController : UIViewController
@property (strong, nonatomic) Bill *theBill;

@property (weak, nonatomic)id<passValuesDelegate> passValueDelegeta;

@end
