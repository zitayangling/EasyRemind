//
//  Bill.h
//  HJB
//
//  Created by zitayangling on 16/5/17.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Bill : NSObject

@property (copy, nonatomic) NSString * billID;         ///<账单id
@property (strong, nonatomic) NSData * imageName;        ///<照片
@property (strong, nonatomic) NSData *categoryImage;     ///类别图片
@property (copy, nonatomic) NSString * AccountingTime; ///<记账时间
@property (copy, nonatomic) NSString * categoryID;     ///<类别id
@property (copy, nonatomic) NSString * month;///< 月份

@property (copy, nonatomic) NSString * categoryName;       ///<类别名
@property (copy, nonatomic) NSString * remarks;        ///<备注
@property (copy, nonatomic) NSString *month_income;///< 月收入
@property (copy, nonatomic) NSString *month_money;///<月支出
@property (assign, nonatomic) float money;          ///<支出金额
@property (assign, nonatomic) float income;          ///收入金额
@property (assign, nonatomic) float budget;          ///预算
@property (assign, nonatomic) float balance;         ///余额
@property (strong, nonatomic, readonly) UIImage * billImage;
@property (assign, nonatomic) NSInteger passWordIndex;   ///<记录密码开启状态
@property (assign, nonatomic) NSInteger fingerPassWordIndex;  ///<记录指纹解锁开启状态
@property (copy, nonatomic) NSString * passWord;         ///<密码
@property (copy, nonatomic) NSString * allMoney;///<总支出
@property (copy, nonatomic) NSString * allIncome;///<总收入
@property (copy, nonatomic) NSString * allMonthIncome;///<月总收入
@property (copy, nonatomic) NSString * allMonthMoney;///<月总支出
@property (copy, nonatomic) NSString *SUM_money;///类别相同的支出金额
@property (copy, nonatomic) NSString *SUM_income;///类别相同的收入金额




//- (float) monthlyIncome;     ///<月收入
//- (float) monthlySpend;     ///<月支出
//- (BOOL)addBill:(Bill *)bill;          ///<插入数据
//- (Bill *)billAtIndex:(NSUInteger)index;          ///<查询数据
//- (BOOL)modifyType:(Bill *)bill;                  ///<修改数据


@end
