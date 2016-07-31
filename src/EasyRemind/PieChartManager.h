//
//  PieChartManager.h
//  StatisticalFigure
//
//  Created by ChangRJey on 16/5/20.
//  Copyright © 2016年 ChangRJey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFChart.h"
#import "ZFPieChart.h"
#import "StatisticalViewController.h"
#import "SqliteManager.h"
#import "Bill.h"
#import <UIKit/UIKit.h>
#import "LCProgressHUD.h"

@interface PieChartManager : NSObject
@property (strong, nonatomic)  ZFPieChart * _Nullable pieChart;
@property (strong, nonnull) SqliteManager * FMDB;
@property (strong, nonatomic) colorAtPixel * _Nullable colorAtPixel;
@property (strong, nonatomic) Bill *_Nullable theBill;
@property (strong, nonatomic) LCProgressHUD *_Nullable LCProgressHUD;

///总收入饼图
- (void)showTotalRevenuePieChart : (UIView * _Nullable) theView;
///总支出饼图
- (void)showTotalSpendingPieChart : (UIView * _Nullable) theView;
/**    月收入饼图      */
- (void)showTotalRevenueMonthPieChart:(NSString * _Nullable) time : (UIView * _Nullable) theView;
/**  月支出饼图 */
- (void)showTotalSpendingMonthPieChart : (NSString * _Nullable)time : (UIView * _Nullable) theView;
@end
