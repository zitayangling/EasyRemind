//
//  HJBCategory.h
//  HJB
//
//  Created by 1403812 on 16/5/18.
//  Copyright © 2016年 zhoujianchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJBCategory : NSObject
@property (copy, nonatomic) NSString * categoryID;        ///<收支类别ID
@property (copy, nonatomic) NSString * categoryName;      ///<收支类别名称
@property (strong, nonatomic) NSData * categoryImageName;   ///<收支类别图标
@property (assign, nonatomic) float budget;            ///<预算金额
@property (assign, nonatomic) BOOL isExpenditure;       ///<收支类型



//- (void)setTheBudget:(HJBCategory *)Budget;          ///<添加预算金额
//- (BOOL)modifyBudget:(HJBCategory *)Budget;          ///<修改预算金额
//- (float)balanceOfBudget:(float)money;          ///<计算预算余额

@end
