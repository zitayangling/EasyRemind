//
//  LineChartManager.m
//  StatisticalFigure
//
//  Created by ChangRJey on 16/5/20.
//  Copyright © 2016年 ChangRJey. All rights reserved.
//

#import "LineChartManager.h"
#import <UIKit/UIKit.h>
@implementation LineChartManager

#pragma mark ------------------------ 折线图 ------------------------
/**    周收入折线图      */
- (void)showWeakRevenueLineChart : (UIView *) theView
{
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 200, SCREEN_HEIGHT/2.0 -200, 400, 550)];
    self.lineChart.xLineValueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267", nil];
    self.lineChart.xLineTitleArray = [NSMutableArray arrayWithObjects:@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六",@"星期天", nil];
    self.lineChart.yLineMaxValue = 500;
    self.lineChart.yLineSectionCount = 10;
    [theView addSubview:self.lineChart];
    [self.lineChart strokePath];
}

/**    周支出折线图      */
- (void)showWeakSpendingLineChart : (UIView *) theView
{
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 200, SCREEN_HEIGHT/2.0 -200, 400, 550)];
    self.lineChart.xLineValueArray = [NSMutableArray arrayWithObjects:@"111", @"222", @"333", @"444", @"555", @"666", nil];
    self.lineChart.xLineTitleArray = [NSMutableArray arrayWithObjects:@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六",@"星期天", nil];
    self.lineChart.yLineMaxValue = 500;
    self.lineChart.yLineSectionCount = 10;
    [theView addSubview:self.lineChart];
    [self.lineChart strokePath];
}

@end
