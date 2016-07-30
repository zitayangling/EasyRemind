//
//  SqliteManager.h
//  HJB
//
//  Created by zitayangling on 16/5/17.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bill.h"
#import "HJBCategory.h"
#import "colorAtPixel.h"

@interface SqliteManager : NSObject
@property (strong, nonatomic) NSMutableArray *arry;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *categoryName;
@property (strong, nonatomic) NSMutableArray * categoryMoneyImage;
@property (strong, nonatomic) NSMutableArray * timeArray;
@property (strong, nonatomic) NSMutableArray * categoryIncomeImage;
@property (strong, nonatomic) NSMutableArray * monthArray;///<月收入
@property (strong, nonatomic) NSMutableArray * monthName;///<月类名
@property (strong, nonatomic) NSMutableArray * monthImage;///<月类别图标
@property (strong, nonatomic) NSMutableArray * categoryMoneyName;

@property (copy, nonatomic) NSString * allMoney;///<总支出金额
@property (copy, nonatomic) NSString * allIncome;///<总收入金额

@property (copy, nonatomic) NSString * monthMoney;///<月总支出
@property (copy, nonatomic) NSString * monthIncome;///<月总收入
@property (strong, nonatomic) colorAtPixel *colorAtPixel;

+ (SqliteManager *)sharedManager;
-(NSString *)DBfilepath;
-(instancetype)init;

-(NSMutableArray *)readBillList:(NSString *)time;  ///<读取账单
-(BOOL)saveBill:(Bill *)theBill;
-(BOOL)updateBill:(Bill *)theBill;///<修改账单

-(BOOL)deleteBill:(Bill *)theBill;///<删除账单
-(BOOL)deleteAllBill;
-(float)monthOfSurplus:(NSString *)year :(NSString *)month;
-(NSMutableArray *)allBill:(NSString *)year :(NSString *)month;//按月显示账单
-(NSMutableArray *)readMonth:(NSString *)year;//显示每年月份（升序）
-(float)monthOfMoney:(NSString *)year :(NSString *)month;//每月总支出




- (NSMutableArray *)readCategoryID ;///<读取类别
-(BOOL)saveCategory:(HJBCategory *)theCategory;///<保存类别
-(BOOL)updateCategory:(HJBCategory *)theCategory;///<修改类别
-(BOOL)deleteCategory:(HJBCategory *)theCategory;///<删除类别

- (double)queryAllExpend;
- (double)queryAllIncome;
-(float)oneDayOfIncome:(NSString * )year :(NSString *)month;///每月总收入
-(float)oneDayOfmoney:(NSString * )year :(NSString *)month;///每月总支出

/** 读取类别名中不重复的类别 */
-(NSMutableArray *) queryCategory;
-(NSMutableArray *) queryCategoryName;
/** 支出类别图片 */
-(NSMutableArray *) queryCategoryMoneyImage;

-(NSMutableArray *) queryCategoryIncome;
-(NSMutableArray *) queryCategoryIncomeName;
/** 收入类别图片 */
-(NSMutableArray *) queryCategoryIncomeImage;
-(NSMutableArray *) queryCategoryIncomeImage : (NSString *)name;
/** 月收入账单 */
-(NSMutableArray *)monthIncomeOfSurplus :(NSString *)month;
-(NSMutableArray *)monthIncomeNameOfSurplus :(NSString *)month;
-(NSMutableArray *)monthIncomeImageOfSurplus :(NSString *)month;
/** 月支出账单 */
-(NSMutableArray *)monthMoneyOfSurplus :(NSString *)month;
-(NSMutableArray *)monthMoneyNameOfSurplus :(NSString *)month;
-(NSMutableArray *)monthMoneyImageOfSurplus :(NSString *)month;
/** 计算总收入 */
- (NSString *) calculateAllIncome;
/** 计算总支出 */
- (NSString *) calculateAllMoney;
/** 月总收入 */
- (NSString *)calculateMonthIncome :(NSString *)month;
/** 月总支出 */
- (NSString *)calculateMonthMoney :(NSString *)month;
#pragma mark - 计算时间
-(NSMutableArray *)calculateTime;
/*****
 *
 *设置
 ＊＊＊*/
- (NSString *)queryPassWord;//查询所有账单
- (NSMutableArray *)allCategoryID:(NSInteger)index ;
- (NSInteger)isExpenditure;
- (NSInteger)isExpenditure1;
- (NSMutableArray *)selectAllBill;
-(BOOL)savePassWordIndex:(NSInteger)index;
-(BOOL)saveFingerPassWordIndex:(NSInteger)index;
-(BOOL)savePassWord : (NSString *)index : (NSInteger)passWordIndex : (NSInteger)fingerPassWordIndex;
-(NSInteger )selectPassWordIndex;// 查询passWord状态
-(BOOL)updatePassWord:(NSString *)passWord;
-(NSInteger )selectFingerPassWordIndex;
@end
