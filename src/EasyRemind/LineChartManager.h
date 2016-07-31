//
//  LineChartManager.h
//  StatisticalFigure
//
//  Created by ChangRJey on 16/5/20.
//  Copyright © 2016年 ChangRJey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFChart.h"
#import "ZFPieChart.h"
#import "ZFLineChart.h"
#import "StatisticalViewController.h"
@interface LineChartManager : NSObject

@property (strong, nonatomic) ZFPieChart *pieChart;
@property (strong, nonatomic) ZFLineChart *lineChart;
@property (strong, nonatomic) StatisticalViewController *statisticalView;

///周收入折线图
- (void)showWeakRevenueLineChart : (UIView *) theView;
///周支出折线图
- (void)showWeakSpendingLineChart : (UIView *) theView;
@end
