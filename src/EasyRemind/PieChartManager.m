//
//  PieChartManager.m
//  StatisticalFigure
//
//  Created by ChangRJey on 16/5/20.
//  Copyright © 2016年 ChangRJey. All rights reserved.
//

#import "PieChartManager.h"
@implementation PieChartManager

#pragma mark ------------------------ 饼图 ------------------------
/**    总收入饼图      */
- (void)showTotalRevenuePieChart : (UIView *) theView
{
    self.FMDB = [SqliteManager sharedManager];
    NSMutableArray *array = [self.FMDB queryCategoryIncome];
    NSMutableArray *nameArray = [self.FMDB queryCategoryIncomeName];
    NSMutableArray *imageArray = [self.FMDB queryCategoryIncomeImage];
    
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 175, SCREEN_HEIGHT/2 -175, 350, 350)];
    self.pieChart.valueArray = [NSMutableArray arrayWithArray:array];
    self.pieChart.nameArray = [NSMutableArray arrayWithArray:nameArray];
    self.pieChart.colorArray = [NSMutableArray arrayWithArray:imageArray];
    if(self.pieChart.valueArray.count <=1 && [self.pieChart.valueArray.firstObject isEqualToString:@"0.0"]){
        [LCProgressHUD showMessage:@"本月无账单"];
    }else{
        [theView addSubview:self.pieChart];
        [self.pieChart strokePath];
    }
}


/**    总支出饼图      */
- (void)showTotalSpendingPieChart : (UIView *) theView
{
    self.FMDB = [SqliteManager sharedManager];
    NSMutableArray *array = [self.FMDB queryCategory];
    NSMutableArray *nameArray = [self.FMDB queryCategoryName];
    NSMutableArray *imageArray = [self.FMDB queryCategoryMoneyImage];
    
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 175, SCREEN_HEIGHT/2 -175, 350, 350)];
    self.pieChart.valueArray = [NSMutableArray arrayWithArray:array];
    self.pieChart.nameArray = [NSMutableArray arrayWithArray:nameArray];
    self.pieChart.colorArray = [NSMutableArray arrayWithArray:imageArray];
    if(self.pieChart.valueArray.count <=1 && [self.pieChart.valueArray.firstObject isEqualToString:@"0.0"]){
        [LCProgressHUD showMessage:@"本月无账单"];
    }else{
        [theView addSubview:self.pieChart];
        [self.pieChart strokePath];
    }
}

/**    月收入饼图      */
- (void)showTotalRevenueMonthPieChart : (NSString *)time : (UIView *) theView
{
    self.FMDB = [SqliteManager sharedManager];
    
    NSMutableArray * array = [self.FMDB monthIncomeOfSurplus :time];
    NSMutableArray * nameArray = [self.FMDB monthIncomeNameOfSurplus:time];
    NSMutableArray * imageArray = [self.FMDB monthIncomeImageOfSurplus:time];
    
    
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 175, SCREEN_HEIGHT/2 -175, 350, 350)];
    self.pieChart.valueArray = [NSMutableArray arrayWithArray:array];
    self.pieChart.nameArray = [NSMutableArray arrayWithArray:nameArray];
    self.pieChart.colorArray = [NSMutableArray arrayWithArray:imageArray];
    if(self.pieChart.valueArray.count <=2 && [self.pieChart.valueArray.firstObject isEqualToString:@"0.0"]){
        [LCProgressHUD showMessage:@"本月无账单"];
    }else{
        [theView addSubview:self.pieChart];
        [self.pieChart strokePath];
    }
    
    
}
/**    月支出饼图      */
- (void)showTotalSpendingMonthPieChart : (NSString *)time : (UIView *) theView
{
    self.FMDB = [SqliteManager sharedManager];
    
    NSMutableArray * array = [self.FMDB monthMoneyOfSurplus :time];
    NSMutableArray * nameArray = [self.FMDB monthMoneyNameOfSurplus:time];
    NSMutableArray * imageArray = [self.FMDB monthMoneyImageOfSurplus:time];
    
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 175, SCREEN_HEIGHT/2 -175, 350, 350)];
    self.pieChart.valueArray = [NSMutableArray arrayWithArray:array];
    self.pieChart.nameArray = [NSMutableArray arrayWithArray:nameArray];
    self.pieChart.colorArray = [NSMutableArray arrayWithArray:imageArray];
    if(self.pieChart.valueArray.count <=1 && [self.pieChart.valueArray.firstObject isEqualToString:@"0.0"]){
        [LCProgressHUD showMessage:@"本月无账单"];
    }else{
        [theView addSubview:self.pieChart];
        [self.pieChart strokePath];
    }
}
@end
