//
//  StatisticalViewController.h
//  StatisticalFigure
//
//  Created by ChangRJey on 16/5/18.
//  Copyright © 2016年 ChangRJey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kChartTypeBarChart = 0,
    kChartTypeLineChart = 1,
    kChartTypePieChart = 2
}kChartType;

@interface StatisticalViewController : UIViewController
@property (nonatomic, assign) kChartType chartType;

@end
