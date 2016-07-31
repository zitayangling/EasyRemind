//
//  StatisticalViewController.m
//  StatisticalFigure
//
//  Created by ChangRJey on 16/5/18.
//  Copyright © 2016年 ChangRJey. All rights reserved.
//

#import "StatisticalViewController.h"
//#import "CSItemSelectView.h"
#import "ZFChart.h"
#import "SqliteManager.h"
@interface StatisticalViewController ()<CSItemSelectViewDelegate>

@property (strong, nonatomic) PieChartManager *pieChartManager;///<饼图管理类
@property (strong, nonatomic) SqliteManager *FMDB;
@property (strong, nonatomic) CSItemSelectView * selectView;///<选择
@property (strong, nonatomic) ZFPieChart *pieChart;

@property (weak, nonatomic) IBOutlet UIButton *totalRevenueBtn;///<总收入按钮
@property (weak, nonatomic) IBOutlet UILabel *totalRevenueLabel;///<总收入Label
@property (weak, nonatomic) IBOutlet UIButton *totalSpendingBtn;///<总支出按钮
@property (weak, nonatomic) IBOutlet UILabel *totalSpendingLabel;///<总支出Label

@property (weak, nonatomic) IBOutlet UIButton *weakRevenueBtn;///<周收入按钮
@property (weak, nonatomic) IBOutlet UILabel *weakRevenueLabel;///<周收入Label
@property (weak, nonatomic) IBOutlet UIButton *weakSpendingBtn;///<周支出按钮
@property (weak, nonatomic) IBOutlet UILabel *weakSpendingLabel;///<周支出Label
@property (copy, nonatomic) NSString *item;
@property (assign, nonatomic) NSInteger index;


@end

@implementation StatisticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pieChartManager = [[PieChartManager alloc]init];
    self.FMDB = [SqliteManager sharedManager];
    self.pieChart = [[ZFPieChart alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeView];
    self.weakRevenueBtn.hidden = YES;
    self.weakRevenueLabel.hidden = YES;
    self.weakSpendingBtn.hidden = YES;
    self.weakSpendingLabel.hidden = YES;
    
    self.totalRevenueBtn.hidden = NO;
    self.totalRevenueLabel.hidden = NO;
    self.totalSpendingBtn.hidden = NO;
    self.totalSpendingLabel.hidden = NO;
    
    self.totalRevenueBtn.selected = YES;
    self.totalSpendingBtn.selected = NO;
    
    self.totalRevenueLabel.textColor = [UIColor orangeColor];
    self.totalRevenueLabel.text = [self.FMDB calculateAllIncome];
    self.totalSpendingLabel.textColor = [UIColor grayColor];
    self.totalSpendingLabel.text = [self.FMDB calculateAllMoney];
    
    [self addSelectView:self.view];
    [self.pieChartManager showTotalRevenuePieChart:self.view];
    self.index = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------------ 选择视图 ------------------------
- (void) addSelectView : (UIView *) view
{
    self.selectView = [CSItemSelectView itemSelectViewWithData:[self data] delegate:self selectViewWidth:60 defalutIndex:5];
    self.selectView.frame = CGRectMake(10, 100, self.view.bounds.size.width - 20, 40);
    self.selectView.selectTitleColor = [UIColor greenColor];
    self.selectView.selectViewColor = [UIColor cyanColor];
    self.selectView.normalTitleColor = [UIColor blueColor];
    self.selectView.titleFont = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:self.selectView];
}

- (void)itemSelectView:(CSItemSelectView *)itemView didSelectItem:(NSString *)item atIndex:(NSInteger)index
{
    self.FMDB = [SqliteManager sharedManager];
    [self removeView];
    if([item isEqualToString:@"全部"])
    {
        self.weakRevenueBtn.hidden = YES;
        self.weakRevenueLabel.hidden = YES;
        self.weakSpendingBtn.hidden = YES;
        self.weakSpendingLabel.hidden = YES;
        self.totalRevenueBtn.hidden = NO;
        self.totalRevenueLabel.hidden = NO;
        self.totalSpendingBtn.hidden = NO;
        self.totalSpendingLabel.hidden = NO;
        
        if(self.index == 0){
            self.totalRevenueBtn.selected = YES;
            self.totalSpendingBtn.selected = NO;
            self.totalRevenueLabel.textColor = [UIColor orangeColor];
            self.totalSpendingLabel.textColor = [UIColor grayColor];
            [self.pieChartManager showTotalRevenuePieChart:self.view];
            
        }else if(self.index == 1){
            self.totalRevenueBtn.selected = NO;
            self.totalSpendingBtn.selected = YES;
            self.totalRevenueLabel.textColor = [UIColor grayColor];
            self.totalSpendingLabel.textColor = [UIColor orangeColor];
            [self.pieChartManager showTotalSpendingPieChart:self.view];
        }
    }
    else
    {
        self.weakRevenueBtn.hidden = NO;
        self.weakRevenueLabel.hidden = NO;
        self.weakSpendingBtn.hidden = NO;
        self.weakSpendingLabel.hidden = NO;
        self.totalRevenueBtn.hidden = YES;
        self.totalRevenueLabel.hidden = YES;
        self.totalSpendingBtn.hidden = YES;
        self.totalSpendingLabel.hidden = YES;
        self.item = item;
        if(self.index == 0)
        {
            self.weakRevenueBtn.selected = YES;
            self.weakSpendingBtn.selected = NO;
            self.weakRevenueLabel.textColor = [UIColor orangeColor];
            self.weakSpendingLabel.textColor = [UIColor grayColor];
            
            [self.pieChartManager showTotalRevenueMonthPieChart:self.item :self.view];
            self.weakRevenueLabel.text = [self.FMDB calculateMonthIncome:self.item];
            
        }
        else if(self.index == 1)
        {
            self.weakRevenueBtn.selected = NO;
            self.weakSpendingBtn.selected = YES;
            self.weakRevenueLabel.textColor = [UIColor grayColor];
            self.weakSpendingLabel.textColor = [UIColor orangeColor];
            
            [self.pieChartManager showTotalSpendingMonthPieChart:self.item :self.view];
            self.weakSpendingLabel.text = [self.FMDB calculateMonthMoney:self.item];
        }
    }
}

//fake data
- (NSArray *)data
{
    self.FMDB = [SqliteManager sharedManager];
    NSMutableArray *timeArray = [self.FMDB calculateTime];
    NSString *str1 = [NSString stringWithFormat:@"全部"];
    [timeArray addObject:str1];
    return [timeArray copy];
}


#pragma mark ------------------------ 饼图 ------------------------
/**    总收入按钮点击事件      */
- (IBAction)TotalRevenue:(UIButton *)sender
{
    [self removeView];
    //    [self addSelectView:self.view];
    self.index = 0;
    if(self.totalRevenueBtn.hidden == NO)
    {
        self.totalRevenueBtn.selected = YES;
        self.totalSpendingBtn.selected = NO;
        
        if(self.totalRevenueBtn.selected == YES)
        {
            [self.pieChartManager showTotalRevenuePieChart:self.view];
        }
        /**
         * 设置总收入与总支出Label的字体颜色 随着其按钮变化而变化
         */
        self.totalRevenueLabel.textColor = [UIColor orangeColor];
        self.totalSpendingLabel.textColor = [UIColor grayColor];
        
    }
    return;
}

/**    总支出按钮点击事件      */
- (IBAction)TotalSpending:(UIButton *)sender
{
    [self removeView];
    //    [self addSelectView:self.view];
    self.index = 1;
    if(self.totalSpendingBtn.hidden == NO)
    {
        self.totalSpendingBtn.selected = YES;
        self.totalRevenueBtn.selected = NO;
        
        if(self.totalSpendingBtn.selected == YES)
        {
            [self.pieChartManager showTotalSpendingPieChart:self.view];
        }
        
        /**
         * 设置总收入与总支出Label的字体颜色 随着其按钮变化而变化
         */
        self.totalRevenueLabel.textColor = [UIColor grayColor];
        self.totalSpendingLabel.textColor = [UIColor orangeColor];
        
    }
    return;
}


#pragma mark ------------------------ 折线图 ------------------------
/**    周收入按钮点击事件      */
- (IBAction)WeakRevenue:(UIButton *)sender
{
    [self removeView];
    self.index = 0;
    if(self.weakRevenueBtn.hidden == NO)
    {
        self.weakRevenueBtn.selected = YES;
        self.weakSpendingBtn.selected = NO;
        
        if(self.weakRevenueBtn.selected == YES && self.index == 0)
        {
            [self.pieChartManager showTotalRevenueMonthPieChart:self.item :self.view];
            self.weakRevenueLabel.text = [self.FMDB calculateMonthIncome:self.item];
            
        }
        
        /**
         * 设置总收入与总支出Label的字体颜色 随着其按钮变化而变化
         */
        self.weakRevenueLabel.textColor = [UIColor orangeColor];
        self.weakSpendingLabel.textColor = [UIColor grayColor];
    }
    return;
}

/**    周支出按钮点击事件      */
- (IBAction)weakSpending:(UIButton *)sender
{
    [self removeView];
    
    self.index = 1;
    //    [self addSelectView:self.view];
    if(self.weakSpendingBtn.hidden == NO)
    {
        self.weakSpendingBtn.selected = YES;
        self.weakRevenueBtn.selected = NO;
        
        if(self.weakSpendingBtn.selected == YES && self.index == 1)
        {
            [self.pieChartManager showTotalSpendingMonthPieChart:self.item :self.view];
            self.weakSpendingLabel.text = [self.FMDB calculateMonthMoney:self.item];
        }
        
        /**
         * 设置总收入与总支出Label的字体颜色 随着其按钮变化而变化
         */
        self.weakRevenueLabel.textColor = [UIColor grayColor];
        self.weakSpendingLabel.textColor = [UIColor orangeColor];
    }
    return;
}

#pragma mark ------------------------ 函数 ------------------------
/**
 *  在折线图中的隐藏控件
 */
- (void)hiddenInLineChart
{
    self.totalRevenueBtn.hidden = YES;
    self.totalRevenueLabel.hidden = YES;
    self.totalSpendingBtn.hidden = YES;
    self.totalSpendingLabel.hidden = YES;
    
    self.weakRevenueBtn.hidden = NO;
    self.weakRevenueLabel.hidden = NO;
    self.weakSpendingBtn.hidden = NO;
    self.weakSpendingLabel.hidden = NO;
    
}
/**
 *  在饼图中的隐藏控件
 */
- (void) hiddenInPieChart
{
    self.totalRevenueBtn.hidden = NO;
    self.totalRevenueLabel.hidden = NO;
    self.totalSpendingBtn.hidden = NO;
    self.totalSpendingLabel.hidden = NO;
    
    self.weakRevenueBtn.hidden = YES;
    self.weakRevenueLabel.hidden = YES;
    self.weakSpendingBtn.hidden = YES;
    self.weakSpendingLabel.hidden = YES;
    
}
/**
 *  推出View 避免视图重叠和无线创建新视图
 */
- (void) removeView
{
    //    [self.pieChartManager.pieChart removeFromSuperview];
    self.pieChartManager.pieChart.hidden = YES;
}
/**
 *  点击空白view收回饼图出现的半透明path
 */
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pieChartManager.pieChart removeZFTranslucencePath];
}

- (void)dealloc {
    NSLog(@"good bye AddBillViewController");
}


@end
